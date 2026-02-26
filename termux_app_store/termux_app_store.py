#!/usr/bin/env python3
import asyncio
import subprocess
import time
import sys
import os
import json
import re
from pathlib import Path

from textual.app import App, ComposeResult
from textual.widgets import (
    Header,
    Input,
    ListView,
    ListItem,
    Label,
    Static,
    Button,
    ProgressBar,
)
from textual.containers import Horizontal, Vertical, VerticalScroll

CACHE_FILE = (
    Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))
    / "termux-app-store"
    / "path.json"
)

FINGERPRINT_STRING = "Termux App Store Official"

ANSI_ESCAPE = re.compile(r'\x1b\[[0-9;]*[mGKHf]')

def strip_ansi(text: str) -> str:
    return ANSI_ESCAPE.sub('', text)

def _ver_tuple(v: str):
    """
    Convert version string to comparable tuple of ints.
    Handles: 1.2.3 / 1.2.3-1 / 4.10-1 / 2.0-pre
      4.10-1  → (4, 10, 1)
      4.10    → (4, 10, 0)  ← no suffix = revision 0
      2.0-pre → (2, 0, 0)   ← non-numeric suffix = 0
    """
    v = v.strip()
    parts = v.split("-", 1)
    base = parts[0]
    rev_str = parts[1] if len(parts) > 1 else "0"

    base_parts = []
    for seg in re.split(r"[._]", base):
        try:
            base_parts.append(int(seg))
        except ValueError:
            base_parts.append(0)

    try:
        rev = int(rev_str)
    except ValueError:
        rev = 0

    return tuple(base_parts) + (rev,)

def get_installed_version(name: str):
    """
    Get installed version via dpkg-query.
    Only returns version if package is actually installed via dpkg/store.
    Packages from official Termux repo (apt) but NOT installed via store
    will NOT appear — dpkg-query only sees packages managed by dpkg.
    """
    try:
        out = subprocess.check_output(
            ["dpkg-query", "-W", "-f=${Status}\t${Version}\n", name],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        if not out:
            return None
        status_part, _, version_part = out.partition("\t")
        if "installed" in status_part:
            return version_part.strip() or None
    except Exception:
        pass
    return None

def has_store_fingerprint(path: Path) -> bool:
    build = path / "build-package.sh"
    if not build.exists():
        return False
    try:
        with build.open(errors="ignore") as f:
            for _ in range(20):
                line = f.readline()
                if not line:
                    break
                if FINGERPRINT_STRING in line:
                    return True
    except Exception:
        pass
    return False

def is_valid_root(path: Path) -> bool:
    return (
        path.is_dir()
        and (path / "packages").is_dir()
        and (path / "build-package.sh").is_file()
        and has_store_fingerprint(path)
    )

def load_cached_root():
    try:
        if CACHE_FILE.exists():
            data = json.loads(CACHE_FILE.read_text())
            p = Path(data.get("app_root", "")).expanduser()
            if is_valid_root(p):
                return p.resolve()
    except Exception:
        pass
    return None

def save_cached_root(path: Path):
    try:
        CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)
        CACHE_FILE.write_text(
            json.dumps({"app_root": str(path)}, indent=2)
        )
    except Exception:
        pass

def resolve_app_root() -> Path:
    env = os.environ.get("TERMUX_APP_STORE_HOME")
    if env:
        p = Path(env).expanduser().resolve()
        if is_valid_root(p):
            save_cached_root(p)
            return p

    cached = load_cached_root()
    if cached:
        return cached

    base = (
        Path(sys.executable).resolve().parent
        if getattr(sys, "frozen", False)
        else Path(__file__).resolve().parent
    )

    if is_valid_root(base):
        save_cached_root(base)
        return base

    raise FileNotFoundError(
        "export TERMUX_APP_STORE_HOME=/path/to/termux-app-store"
    )

APP_ROOT = resolve_app_root()
PACKAGES_DIR = APP_ROOT / "packages"
ROOT_DIR = APP_ROOT

class PackageItem(ListItem):
    def __init__(self, pkg: dict):
        super().__init__()
        self.pkg = pkg

    def compose(self) -> ComposeResult:
        yield Label(self.pkg["name"])

class TermuxAppStore(App):

    CSS = """
    Screen { background: #282a36; color: #f8f8f2; }
    #body { layout: horizontal; height: 1fr; }
    #left { width: 35%; border: heavy #6272a4; padding: 1; }
    #right { width: 65%; border: heavy #6272a4; padding: 1; }
    ListItem.-highlight { background: #44475a; color: #50fa7b; }
    ProgressBar { height: 1; }
    #footer { height: 1; content-align: center middle; color: #6272a4; }
    #log-scroll { height: 1fr; border: solid #6272a4; }
    """

    def on_mount(self):
        self.packages = []
        self.status_cache = {}
        self.search_query = ""
        self.current_item = None
        self.installing = False
        self.log_buffer = []
        self.worker_queue = asyncio.Queue()

        self.set_interval(0.1, self.consume_worker_queue)

        self.load_packages()
        self.refresh_list()

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        yield Input(placeholder="Search package...", id="search")

        with Horizontal(id="body"):
            with Vertical(id="left"):
                self.list_view = ListView()
                yield self.list_view

            with Vertical(id="right"):
                self.info = Static("Select a package")
                yield self.info

                with VerticalScroll(id="log-scroll") as self.log_container:
                    self.log_view = Static("", markup=False)
                    yield self.log_view

                self.progress = ProgressBar(total=100)
                yield self.progress

                self.install_btn = Button("Install / Update", id="install")
                yield self.install_btn

        yield Static("Official Developer @djunekz | Termux App Store", id="footer")

    def load_packages(self):
        self.packages.clear()

        for pkg_dir in sorted(PACKAGES_DIR.iterdir()):
            build = pkg_dir / "build.sh"
            if not build.exists():
                continue

            data = {
                "name": pkg_dir.name,
                "desc": "-",
                "version": "?",
                "deps": "-",
                "maintainer": "-",
            }

            with build.open(errors="ignore") as f:
                for line in f:
                    if line.startswith("TERMUX_PKG_DESCRIPTION="):
                        data["desc"] = line.split("=", 1)[1].strip().strip('"')
                    elif line.startswith("TERMUX_PKG_VERSION="):
                        data["version"] = line.split("=", 1)[1].strip().strip('"')
                    elif line.startswith("TERMUX_PKG_DEPENDS="):
                        data["deps"] = line.split("=", 1)[1].strip().strip('"')
                    elif line.startswith("TERMUX_PKG_MAINTAINER="):
                        data["maintainer"] = line.split("=", 1)[1].strip().strip('"')

            self.packages.append(data)

    def refresh_list(self):
        self.list_view.clear()
        q = self.search_query

        for pkg in self.packages:
            if q == "" or q in pkg["name"]:
                self.list_view.append(PackageItem(pkg))

        if self.list_view.children:
            self.list_view.index = 0
            self.show_preview(self.list_view.children[0])

    def on_input_changed(self, message: Input.Changed):
        self.search_query = message.value.lower().strip()
        self.refresh_list()

    def on_list_view_highlighted(self, event: ListView.Highlighted):
        if event.item:
            self.show_preview(event.item)

    def get_status(self, name: str, store_version: str) -> str:
        """
        Returns: 'NOT INSTALLED' | 'INSTALLED' | 'UPDATE'

        Uses dpkg-query (not pkg info) so only packages actually installed
        via store/dpkg are counted — not packages from official Termux repo.
        Uses proper version comparison so 4.10-1 >= 4.10 = INSTALLED.
        """
        if name in self.status_cache:
            return self.status_cache[name]

        installed = get_installed_version(name)

        if installed is None:
            status = "NOT INSTALLED"
        elif _ver_tuple(installed) >= _ver_tuple(store_version):
            status = "INSTALLED"
        else:
            status = "UPDATE"

        self.status_cache[name] = status
        return status

    def show_preview(self, item: PackageItem):
        self.current_item = item
        p = item.pkg

        status = self.get_status(p["name"], p["version"])
        installed_ver = get_installed_version(p["name"])

        if status == "UPDATE":
            badge = "[yellow]UPDATE[/yellow]"
            ver_line = f"Version    : {p['version']}  [dim](installed: {installed_ver})[/dim]"
        elif status == "INSTALLED":
            badge = "[green]INSTALLED[/green]"
            ver_line = f"Version    : {installed_ver}"
        else:
            badge = "[red]NOT INSTALLED[/red]"
            ver_line = f"Version    : {p['version']}"

        deps = (
            "\n".join(f"• {d.strip()}" for d in p["deps"].split(","))
            if p["deps"] != "-"
            else "-"
        )

        self.info.update(
            f"[b]{p['name']}[/b]  {badge}\n\n"
            f"{ver_line}\n"
            f"Maintainer : {p['maintainer']}\n\n"
            f"[b]Dependencies[/b]\n{deps}\n\n"
            f"{p['desc']}"
        )

        self.log_buffer.clear()
        self.log_view.update("")
        self.progress.progress = 0

    async def on_button_pressed(self, event: Button.Pressed):
        if event.button.id == "install" and self.current_item and not self.installing:
            await self.worker_queue.put(self.current_item.pkg["name"])

    async def consume_worker_queue(self):
        if self.installing or self.worker_queue.empty():
            return
        name = await self.worker_queue.get()
        await asyncio.to_thread(self.run_build_sync, name)

    def run_build_sync(self, name: str):
        self.installing = True
        self.call_from_thread(lambda: setattr(self.install_btn, "disabled", True))
        self.log_buffer.clear()
        self.call_from_thread(lambda: setattr(self.progress, "progress", 0))
        self.call_from_thread(lambda: self.update_log(f"Installing {name}...\n"))

        proc = subprocess.Popen(
            ["bash", "build-package.sh", name],
            cwd=str(ROOT_DIR),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )

        for line in iter(proc.stdout.readline, b""):
            clean_line = strip_ansi(line.decode(errors="ignore").rstrip())
            if clean_line:
                self.call_from_thread(
                    lambda t=clean_line: self.update_log(t)
                )

        proc.wait()

        if proc.returncode == 0:
            self.call_from_thread(lambda: setattr(self.progress, "progress", 100))
            self.call_from_thread(lambda: self.update_log("\n✔ Installation completed successfully!"))
        else:
            self.call_from_thread(lambda: self.update_log(f"\n✗ Installation failed (exit code {proc.returncode})"))

        self.installing = False
        self.call_from_thread(lambda: setattr(self.install_btn, "disabled", False))

        self.status_cache.clear()
        self.load_packages()
        self.call_from_thread(self.refresh_list)

    def update_log(self, line=None):
        if line:
            self.log_buffer.append(line)
            self.log_buffer = self.log_buffer[-500:]
        self.log_view.update("\n".join(self.log_buffer))
        self.log_container.scroll_end(animate=False)

def run_tui():
    TermuxAppStore().run()

if __name__ == "__main__":
    run_tui()
