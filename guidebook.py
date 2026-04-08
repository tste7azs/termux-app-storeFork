#!/usr/bin/env python3
# this is a tool guidebook - Interactive Bilingual Guidebook for Termux App Store
# github.com/djunekz/termux-app-store

import os, sys, shutil

R="\033[0m"; B="\033[1m"; DIM="\033[2m"; IT="\033[3m"
RED="\033[31m"; GRN="\033[32m"; CYN="\033[36m"
BGRN="\033[92m"; BYLW="\033[93m"; BCYN="\033[96m"

def TW(): return shutil.get_terminal_size((80,24)).columns
def TH(): return shutil.get_terminal_size((80,24)).lines

def hline(char="─", color=DIM):
    return f"{color}{char * min(TW(), 72)}{R}"

def center(text, width=None):
    if width is None: width = min(TW(), 72)
    clean, i = "", 0
    while i < len(text):
        if text[i] == "\033":
            while i < len(text) and text[i] != "m": i += 1
        else: clean += text[i]
        i += 1
    return " " * max(0, (width - len(clean)) // 2) + text

def cls(): os.system("clear" if os.name != "nt" else "cls")

def pause(lang="id"):
    msg = "[ Press Enter to continue... ]" if lang == "en" else "[ Tekan Enter untuk lanjut... ]"
    print(f"\n  {DIM}{msg}{R}", end="")
    try: input()
    except (EOFError, KeyboardInterrupt): pass

def pager(lines, lang="id"):
    back = "back" if lang == "en" else "kembali"
    cont = "next" if lang == "en" else "lanjut"
    msg = f"[ Enter = {cont} | q = {back} ]"
    chunk = max(TH() - 4, 10)
    i = 0
    while i < len(lines):
        cls()
        for ln in lines[i:i+chunk]: print(ln)
        i += chunk
        if i < len(lines):
            print(f"\n  {DIM}{msg}{R}", end="", flush=True)
            try: ch = input()
            except (EOFError, KeyboardInterrupt): break
            if ch.strip().lower() == "q": break
        else:
            pause(lang)

def sec(title, icon="◆"):
    w = min(TW(), 72)
    bar = f"{CYN}{'=' * w}{R}"
    return ["", bar, center(f"{CYN}{B}{icon}  {title}  {icon}{R}"), bar, ""]

def code(*cmds):
    W = 52
    out = [f"  {DIM}+{'-'*W}+{R}"]
    for c in cmds:
        out.append(f"   {BGRN}{c.ljust(W)}{R}")
    out.append(f"  {DIM}+{'-'*W}+{R}")
    return out

def bul(items, color=BCYN):
    return [f"  {color}*{R} {it}" for it in items]

def note(text, lang="id"):
    label = "NOTE" if lang == "en" else "CATATAN"
    return [
        f"  {BYLW}[ {label} ]{R}",
        f"  {BYLW}>{R}  {IT}{text}{R}",
        f"  {BYLW}{'=' * 42}{R}",
    ]

def content_about(L):
    if L == "en":
        lines = sec("ABOUT TERMUX APP STORE", "*")
        lines += [
            f"  {B}What is Termux App Store?{R}", "",
            f"  Termux App Store is the first {CYN}{B}TUI (Terminal User Interface){R}",
            f"  package manager built natively for Termux.",
            f"  Built with Python ({CYN}Textual{R}) and CLI, it lets Termux users",
            f"  browse, build, and manage tools/apps directly on Android,",
            f"  with no account, no telemetry, and no cloud dependency.", "",
            hline(),
            f"  {B}{BYLW}Philosophy{R}", "",
            f"  {IT}{DIM}\"Local first. Control over convenience. Transparency over magic.\"{R}", "",
        ]
        lines += bul([
            f"{B}Offline-first{R}  -- no server or cloud required",
            f"{B}Source-based{R}   -- all builds transparent, full user control",
            f"{B}Binary-safe{R}    -- binary distribution only for the store itself",
            f"{B}Termux-native{R}  -- built for the Termux/Android ecosystem",
        ])
        lines += [
            "", hline(), f"  {B}Who built it?{R}", "",
            f"  Created by {BGRN}{B}Djunekz{R} -- Independent Developer.",
            f"  Not an official Termux project, but a community project.", "",
            f"  {DIM}GitHub  :{R} {CYN}https://github.com/djunekz{R}",
            f"  {DIM}Repo    :{R} {CYN}https://github.com/djunekz/termux-app-store{R}",
            f"  {DIM}Issues  :{R} {CYN}https://github.com/djunekz/termux-app-store/issues{R}",
            f"  {DIM}Email   :{R} {CYN}gab288.gab288@passinbox.com{R}",
            f"  {DIM}License :{R} {GRN}MIT License{R}",
            "", hline(), f"  {B}History & Timeline{R}", "",
            f"  {CYN}v0.0.1{R}  {DIM}Jan 2026{R}  -- Internal prototype, local-only",
            f"  {CYN}v0.1.0{R}  {DIM}Feb 2026{R}  -- First TUI with Textual, package browser",
            f"  {CYN}v0.1.2{R}  {DIM}Feb 2026{R}  -- tasctl, lint/check-pr, status badges",
            f"  {CYN}v0.1.4{R}  {DIM}Feb 2026{R}  -- termux-build create, CLI upgrade, new UI",
            f"  {CYN}v0.1.6{R}  {DIM}Feb 2026{R}  -- index.json, update/upgrade, CI workflows",
            f"  {CYN}v0.1.7{R}  {DIM}Mar 2026{R}  -- 15+ new packages, uninstall button in TUI",
            f"  {CYN}v0.2.3{R}  {DIM}Apr 2026{R}  -- pip install support, source mode resolver",
            f"  {CYN}v0.2.4{R}  {DIM}Apr 2026{R}  -- termux-build init (auto create & build)",
            "", hline(), f"  {B}Architecture overview{R}", "",
            f"  {DIM}User Interface (Textual TUI){R}",
            f"         |", f"  {DIM}Application Core (State, Events, Logic){R}",
            f"         |", f"  {DIM}Package Resolver (build.sh inspection){R}",
            f"         |", f"  {DIM}Build Executor (build-package.sh){R}",
            f"         |", f"  {DIM}Termux Environment (pkg / apt / shell){R}", "",
        ]
        lines += note("Termux App Store is NOT a replacement for pkg/apt.", L)
    else:
        lines = sec("TENTANG TERMUX APP STORE", "*")
        lines += [
            f"  {B}Apa itu Termux App Store?{R}", "",
            f"  Termux App Store adalah {CYN}{B}TUI (Terminal User Interface){R} package",
            f"  manager pertama yang dibangun khusus untuk Termux secara native.",
            f"  Dibuat dengan Python ({CYN}Textual{R}) dan CLI, memungkinkan pengguna",
            f"  Termux untuk browse, build, dan manage tools/apps langsung di",
            f"  Android tanpa akun, tanpa telemetri, dan tanpa cloud.", "",
            hline(),
            f"  {B}{BYLW}Filosofi{R}", "",
            f"  {IT}{DIM}\"Local first. Control over convenience. Transparency over magic.\"{R}", "",
        ]
        lines += bul([
            f"{B}Offline-first{R}  -- tidak butuh server atau cloud",
            f"{B}Source-based{R}   -- semua build transparan, user punya kontrol penuh",
            f"{B}Binary-safe{R}    -- binary distribution hanya untuk app-store-nya sendiri",
            f"{B}Termux-native{R}  -- dibangun khusus untuk ekosistem Termux/Android",
        ])
        lines += [
            "", hline(), f"  {B}Siapa yang membuatnya?{R}", "",
            f"  Dibuat oleh {BGRN}{B}Djunekz{R} -- Independent Developer.",
            f"  Bukan proyek resmi Termux, tapi merupakan proyek komunitas.", "",
            f"  {DIM}GitHub  :{R} {CYN}https://github.com/djunekz{R}",
            f"  {DIM}Repo    :{R} {CYN}https://github.com/djunekz/termux-app-store{R}",
            f"  {DIM}Issues  :{R} {CYN}https://github.com/djunekz/termux-app-store/issues{R}",
            f"  {DIM}Email   :{R} {CYN}gab288.gab288@passinbox.com{R}",
            f"  {DIM}Lisensi :{R} {GRN}MIT License{R}",
            "", hline(), f"  {B}Sejarah & Timeline{R}", "",
            f"  {CYN}v0.0.1{R}  {DIM}Jan 2026{R}  -- Prototype internal, local-only",
            f"  {CYN}v0.1.0{R}  {DIM}Feb 2026{R}  -- TUI pertama dengan Textual, package browser",
            f"  {CYN}v0.1.2{R}  {DIM}Feb 2026{R}  -- tasctl, lint/check-pr, badge status",
            f"  {CYN}v0.1.4{R}  {DIM}Feb 2026{R}  -- termux-build create, CLI upgrade, UI baru",
            f"  {CYN}v0.1.6{R}  {DIM}Feb 2026{R}  -- index.json, update/upgrade, CI workflows",
            f"  {CYN}v0.1.7{R}  {DIM}Mar 2026{R}  -- 15+ package baru, uninstall button di TUI",
            f"  {CYN}v0.2.3{R}  {DIM}Apr 2026{R}  -- pip install support, source mode resolver",
            f"  {CYN}v0.2.4{R}  {DIM}Apr 2026{R}  -- termux-build init (auto create & build)",
            "", hline(), f"  {B}Arsitektur singkat{R}", "",
            f"  {DIM}User Interface (Textual TUI){R}",
            f"         |", f"  {DIM}Application Core (State, Events, Logic){R}",
            f"         |", f"  {DIM}Package Resolver (build.sh inspection){R}",
            f"         |", f"  {DIM}Build Executor (build-package.sh){R}",
            f"         |", f"  {DIM}Termux Environment (pkg / apt / shell){R}", "",
        ]
        lines += note("Termux App Store BUKAN pengganti pkg/apt. Ini adalah source-based app store.", L)
    lines.append("")
    return lines


def content_install(L):
    if L == "en":
        lines = sec("HOW TO INSTALL TERMUX APP STORE", "#")
        lines += [f"  {B}Requirements{R}", ""]
        lines += bul([
            "Termux (latest version recommended)",
            "Internet connection",
            f"Architecture: {CYN}aarch64{R} (recommended) / {CYN}armv7l{R} / {CYN}x86_64{R}",
        ])
        lines += ["", hline(), f"  {B}{BGRN}Option 1 -- Recommended (pip){R}", ""]
        lines += code("pkg install python", "pip install termux-app-store")
        lines += ["", f"  {B}Option 2 -- Manual (git clone){R}", ""]
        lines += code("git clone https://github.com/djunekz/termux-app-store",
                      "cd termux-app-store", "bash install.sh")
        lines += ["", f"  or with tasctl:", ""]
        lines += code("git clone https://github.com/djunekz/termux-app-store",
                      "cd termux-app-store", "./tasctl install")
        lines += ["", f"  {B}After install, run:{R}", ""]
        lines += code("termux-app-store        # Open interactive TUI",
                      "termux-app-store -h     # Show CLI help")
        lines += [
            "", hline(), f"  {B}File locations after install{R}", "",
            f"  {DIM}Binary/source :{R} {CYN}$PREFIX/lib/.tas/{R}",
            f"  {DIM}Symlink       :{R} {CYN}$PREFIX/bin/termux-app-store{R}",
            f"  {DIM}packages/     :{R} {CYN}$PREFIX/lib/.tas/packages/{R}",
            "", hline(), f"  {B}Install troubleshooting{R}", "",
            f"  {BYLW}command not found{R}   -- Restart Termux or: {CYN}hash -r{R}",
            f"  {BYLW}Permission denied{R}   -- {CYN}chmod +x $PREFIX/bin/termux-app-store{R}",
            f"  {BYLW}Arch unsupported{R}    -- Check: {CYN}uname -m{R}",
            f"  {BYLW}ModuleNotFoundError{R} -- {CYN}pip install textual{R}", "",
        ]
    else:
        lines = sec("CARA INSTALL TERMUX APP STORE", "#")
        lines += [f"  {B}Requirements{R}", ""]
        lines += bul([
            "Termux (versi terbaru direkomendasikan)",
            "Koneksi internet",
            f"Arsitektur: {CYN}aarch64{R} (direkomendasikan) / {CYN}armv7l{R} / {CYN}x86_64{R}",
        ])
        lines += ["", hline(), f"  {B}{BGRN}Opsi 1 -- Recommended (pip){R}", ""]
        lines += code("pkg install python", "pip install termux-app-store")
        lines += ["", f"  {B}Opsi 2 -- Manual (git clone){R}", ""]
        lines += code("git clone https://github.com/djunekz/termux-app-store",
                      "cd termux-app-store", "bash install.sh")
        lines += ["", f"  atau dengan tasctl:", ""]
        lines += code("git clone https://github.com/djunekz/termux-app-store",
                      "cd termux-app-store", "./tasctl install")
        lines += ["", f"  {B}Setelah install, jalankan:{R}", ""]
        lines += code("termux-app-store        # Buka TUI interaktif",
                      "termux-app-store -h     # Tampilkan CLI help")
        lines += [
            "", hline(), f"  {B}Lokasi file setelah install{R}", "",
            f"  {DIM}Binary/source :{R} {CYN}$PREFIX/lib/.tas/{R}",
            f"  {DIM}Symlink       :{R} {CYN}$PREFIX/bin/termux-app-store{R}",
            f"  {DIM}packages/     :{R} {CYN}$PREFIX/lib/.tas/packages/{R}",
            "", hline(), f"  {B}Troubleshooting install{R}", "",
            f"  {BYLW}command not found{R}   -- Restart Termux atau: {CYN}hash -r{R}",
            f"  {BYLW}Permission denied{R}   -- {CYN}chmod +x $PREFIX/bin/termux-app-store{R}",
            f"  {BYLW}Arch unsupported{R}    -- Cek: {CYN}uname -m{R}",
            f"  {BYLW}ModuleNotFoundError{R} -- {CYN}pip install textual{R}", "",
        ]
    return lines


def content_uninstall(L):
    if L == "en":
        lines = sec("HOW TO UNINSTALL", "X")
        lines += [f"  {B}Option 1 -- pip (if installed via pip){R}", ""]
        lines += code("pip uninstall termux-app-store")
        lines += ["", f"  {B}Option 2 -- tasctl{R}", ""]
        lines += code("./tasctl uninstall")
        lines += ["", f"  {B}Option 3 -- Manual{R}", ""]
        lines += code("rm -f $PREFIX/bin/termux-app-store", "rm -rf $PREFIX/lib/.tas")
        lines += [""]
        lines += note("Uninstall does not remove packages/ you created manually.", L)
    else:
        lines = sec("CARA UNINSTALL", "X")
        lines += [f"  {B}Opsi 1 -- pip (jika install via pip){R}", ""]
        lines += code("pip uninstall termux-app-store")
        lines += ["", f"  {B}Opsi 2 -- tasctl{R}", ""]
        lines += code("./tasctl uninstall")
        lines += ["", f"  {B}Opsi 3 -- Manual{R}", ""]
        lines += code("rm -f $PREFIX/bin/termux-app-store", "rm -rf $PREFIX/lib/.tas")
        lines += [""]
        lines += note("Uninstall tidak menghapus packages/ yang sudah kamu buat sendiri.", L)
    lines.append("")
    return lines


def content_usage(L):
    if L == "en":
        lines = sec("USING termux-app-store", ">")
        lines += [f"  {B}TUI -- Interactive Interface{R}", ""]
        lines += code("termux-app-store")
        lines += ["", f"  TUI Navigation:"]
        lines += bul([
            f"{CYN}Up/Down{R} -- navigate packages",
            f"{CYN}Enter{R}   -- view detail / install",
            f"{CYN}Ctrl+Q{R}  -- quit",
            "Full touchscreen support",
        ])
        lines += ["", hline(), f"  {B}CLI -- Command Line{R}", ""]
        lines += code(
            "termux-app-store list",
            "termux-app-store show <package>",
            "termux-app-store install <package>",
            "termux-app-store update",
            "termux-app-store upgrade",
            "termux-app-store upgrade <package>",
            "termux-app-store version",
            "termux-app-store help",
        )
        lines += [
            "", f"  {B}CLI Shortcuts{R}", "",
            f"  {CYN}-h{R}           -- help",
            f"  {CYN}-v{R}           -- version",
            f"  {CYN}-i <package>{R} -- install package",
            f"  {CYN}-l / -L{R}      -- list packages",
            "", hline(), f"  {B}Package Status Badges{R}", "",
            f"  {BGRN}INSTALLED{R}   -- installed version is up-to-date",
            f"  {BCYN}UPDATE{R}      -- a newer version is available",
            f"  {BYLW}NEW{R}         -- newly added (< 7 days)",
            f"  {RED}UNSUPPORTED{R} -- dependency not available in Termux", "",
        ]
    else:
        lines = sec("PENGGUNAAN termux-app-store", ">")
        lines += [f"  {B}TUI -- Interface Interaktif{R}", ""]
        lines += code("termux-app-store")
        lines += ["", f"  Navigasi TUI:"]
        lines += bul([
            f"{CYN}Atas/Bawah{R} -- pindah package",
            f"{CYN}Enter{R}      -- lihat detail / install",
            f"{CYN}Ctrl+Q{R}     -- keluar",
            "Touchscreen didukung penuh",
        ])
        lines += ["", hline(), f"  {B}CLI -- Command Line{R}", ""]
        lines += code(
            "termux-app-store list",
            "termux-app-store show <package>",
            "termux-app-store install <package>",
            "termux-app-store update",
            "termux-app-store upgrade",
            "termux-app-store upgrade <package>",
            "termux-app-store version",
            "termux-app-store help",
        )
        lines += [
            "", f"  {B}Shortcut CLI{R}", "",
            f"  {CYN}-h{R}           -- help",
            f"  {CYN}-v{R}           -- version",
            f"  {CYN}-i <package>{R} -- install package",
            f"  {CYN}-l / -L{R}      -- list package",
            "", hline(), f"  {B}Status Badge Package{R}", "",
            f"  {BGRN}INSTALLED{R}   -- versi terinstal sudah up-to-date",
            f"  {BCYN}UPDATE{R}      -- ada versi baru tersedia",
            f"  {BYLW}NEW{R}         -- package baru (< 7 hari)",
            f"  {RED}UNSUPPORTED{R} -- dependency tidak tersedia di Termux", "",
        ]
    return lines


def content_tasctl(L):
    if L == "en":
        lines = sec("USING tasctl", "!")
        lines += [
            f"  {DIM}tasctl = Termux App Store Controller{R}",
            f"  Tool to install, update, and uninstall Termux App Store itself.", "",
            hline(), f"  {B}tasctl commands{R}", "",
        ]
        lines += code(
            "tasctl install      # Install latest TAS",
            "tasctl update       # Update to latest version",
            "tasctl uninstall    # Remove TAS",
            "tasctl doctor       # Diagnose environment",
            "tasctl self-update  # Update tasctl itself",
            "tasctl help         # Show help",
        )
        lines += ["", hline(), f"  {B}tasctl doctor checks:{R}", ""]
        lines += bul([
            "CPU architecture (aarch64 / armv7l / x86_64)",
            "Python & pip installed",
            "Textual (TUI framework) installed",
            "curl available",
            "TAS install status (binary/source/unknown)",
            "TERMUX_APP_STORE_HOME in wrapper",
        ])
        lines += [""]
        lines += note("If something feels broken, run 'tasctl doctor' before reporting a bug.", L)
    else:
        lines = sec("PENGGUNAAN tasctl", "!")
        lines += [
            f"  {DIM}tasctl = Termux App Store Controller{R}",
            f"  Tool untuk install, update, dan uninstall Termux App Store itu sendiri.", "",
            hline(), f"  {B}Perintah tasctl{R}", "",
        ]
        lines += code(
            "tasctl install      # Install TAS versi terbaru",
            "tasctl update       # Update ke versi terbaru",
            "tasctl uninstall    # Hapus TAS",
            "tasctl doctor       # Diagnosa environment",
            "tasctl self-update  # Update tasctl itu sendiri",
            "tasctl help         # Tampilkan bantuan",
        )
        lines += ["", hline(), f"  {B}tasctl doctor -- cek apa saja?{R}", ""]
        lines += bul([
            "Arsitektur CPU (aarch64 / armv7l / x86_64)",
            "Python & pip terinstall",
            "Textual (TUI framework) terinstall",
            "curl tersedia",
            "Status instalasi TAS (binary/source/unknown)",
            "TERMUX_APP_STORE_HOME di wrapper",
        ])
        lines += [""]
        lines += note("Jika ada masalah aneh, coba 'tasctl doctor' dulu sebelum report bug.", L)
    lines.append("")
    return lines


def content_termux_build(L):
    if L == "en":
        lines = sec("USING termux-build", "@")
        lines += [
            f"  {DIM}termux-build = validation & review tool{R}",
            f"  NOT auto-upload or auto-publish. Only reads and validates.", "",
            hline(), f"  {B}All sub-commands{R}", "",
        ]
        lines += code(
            "./termux-build create <package>",
            "./termux-build init <repo-url>",
            "./termux-build lint <package>",
            "./termux-build check-pr <package>",
            "./termux-build doctor",
            "./termux-build suggest <package>",
            "./termux-build explain <package>",
            "./termux-build template",
            "./termux-build guide",
        )
        lines += [
            "", hline(), f"  {B}Command descriptions{R}", "",
            f"  {CYN}create{R}    -- Create new package folder with empty build.sh",
            f"  {CYN}init{R}      -- {BGRN}Auto-detect{R} GitHub repo, generate build.sh",
            f"  {CYN}lint{R}      -- Validate build.sh (fields, format, version)",
            f"  {CYN}check-pr{R}  -- Check Pull Request readiness",
            f"  {CYN}doctor{R}    -- Diagnose build environment",
            f"  {CYN}suggest{R}   -- Get improvement suggestions for a package",
            f"  {CYN}explain{R}   -- Detailed package explanation",
            f"  {CYN}template{R}  -- Generate a new build.sh template",
            f"  {CYN}guide{R}     -- Show contribution guide",
            "", hline(), f"  {B}termux-build init -- how to use{R}", "",
            f"  The most powerful feature: auto-detect a GitHub repo,",
            f"  generate a complete build.sh, and optionally build a .deb.", "",
        ]
        lines += code("./termux-build init https://github.com/user/repo")
        lines += ["", f"  What it does automatically:"]
        lines += bul([
            "Fetch GitHub metadata (name, description, license, language)",
            "Download source code",
            "Detect build method (python-script/pip/shell/cargo/etc)",
            "Detect main entrypoint file",
            "Detect installer scripts (install_Termux.sh, install.sh, etc)",
            "Scan dependencies (imports, requirements.txt, shell deps)",
            "Compute SHA256 checksum automatically",
            "Generate complete build.sh",
            "Optional: test build & install as .deb",
        ])
        lines += [""]
        lines += note("termux-build does NOT modify files, auto-build, or upload to GitHub.", L)
    else:
        lines = sec("PENGGUNAAN termux-build", "@")
        lines += [
            f"  {DIM}termux-build = validation & review tool{R}",
            f"  Bukan auto-upload atau auto-publish. Hanya membaca & memvalidasi.", "",
            hline(), f"  {B}Semua sub-command{R}", "",
        ]
        lines += code(
            "./termux-build create <package>",
            "./termux-build init <repo-url>",
            "./termux-build lint <package>",
            "./termux-build check-pr <package>",
            "./termux-build doctor",
            "./termux-build suggest <package>",
            "./termux-build explain <package>",
            "./termux-build template",
            "./termux-build guide",
        )
        lines += [
            "", hline(), f"  {B}Penjelasan tiap command{R}", "",
            f"  {CYN}create{R}    -- Buat folder package baru dengan build.sh kosong",
            f"  {CYN}init{R}      -- {BGRN}Auto-detect{R} repo GitHub, generate build.sh otomatis",
            f"  {CYN}lint{R}      -- Cek validasi build.sh (field, format, versi)",
            f"  {CYN}check-pr{R}  -- Cek kesiapan Pull Request",
            f"  {CYN}doctor{R}    -- Diagnosa environment build",
            f"  {CYN}suggest{R}   -- Saran perbaikan untuk package",
            f"  {CYN}explain{R}   -- Penjelasan detail package",
            f"  {CYN}template{R}  -- Generate template build.sh baru",
            f"  {CYN}guide{R}     -- Tampilkan contribution guide",
            "", hline(), f"  {B}termux-build init -- cara pakai{R}", "",
            f"  Fitur paling powerful: auto-detect repo GitHub,",
            f"  generate build.sh lengkap, lalu opsional build jadi .deb.", "",
        ]
        lines += code("./termux-build init https://github.com/user/repo")
        lines += ["", f"  Yang dilakukan otomatis:"]
        lines += bul([
            "Fetch metadata GitHub (nama, deskripsi, lisensi, bahasa)",
            "Download source code",
            "Deteksi build method (python-script/pip/shell/cargo/dll)",
            "Deteksi entrypoint utama",
            "Deteksi installer script (install_Termux.sh, install.sh, dll)",
            "Scan dependency (imports, requirements.txt, shell deps)",
            "Hitung SHA256 checksum otomatis",
            "Generate build.sh lengkap",
            "Opsional: langsung test build & install jadi .deb",
        ])
        lines += [""]
        lines += note("termux-build TIDAK memodifikasi file, tidak auto-build, tidak upload ke GitHub.", L)
    lines.append("")
    return lines


def content_build_package(L):
    if L == "en":
        lines = sec("USING build-package.sh", "$")
        lines += [
            f"  {DIM}build-package.sh = core build engine{R}",
            f"  Used by TUI and CLI to build & install packages as .deb files.", "",
            hline(), f"  {B}Manual usage{R}", "",
        ]
        lines += code("./build-package.sh <package-name>", "", "# Example:", "./build-package.sh mr-holmes")
        lines += ["", f"  {B}What build-package.sh does{R}", ""]
        lines += bul([
            "Validate build.sh (syntax + required fields)",
            "Detect CPU architecture",
            "Install dependencies via pkg",
            "Download source from TERMUX_PKG_SRCURL",
            "Verify SHA256 checksum",
            "Extract source archive",
            "Run termux_step_make_install()",
            "Generate .deb metadata",
            "Build .deb with dpkg-deb",
            "Install package with dpkg -i",
            "Hold package from pkg upgrade overwrite",
        ])
        lines += [
            "", hline(), f"  {B}Output structure{R}", "",
            f"  {DIM}build/<package>/  :{R} build working directory",
            f"  {DIM}output/<pkg>.deb  :{R} generated .deb package file", "",
        ]
    else:
        lines = sec("PENGGUNAAN build-package.sh", "$")
        lines += [
            f"  {DIM}build-package.sh = core build engine{R}",
            f"  Dipakai oleh TUI dan CLI untuk build & install package jadi .deb.", "",
            hline(), f"  {B}Cara pakai manual{R}", "",
        ]
        lines += code("./build-package.sh <package-name>", "", "# Contoh:", "./build-package.sh mr-holmes")
        lines += ["", f"  {B}Yang dilakukan build-package.sh{R}", ""]
        lines += bul([
            "Validasi build.sh (syntax + required fields)",
            "Deteksi arsitektur CPU",
            "Install dependencies via pkg",
            "Download source dari TERMUX_PKG_SRCURL",
            "Verifikasi SHA256 checksum",
            "Extract source archive",
            "Jalankan termux_step_make_install()",
            "Generate metadata .deb",
            "Build file .deb dengan dpkg-deb",
            "Install package dengan dpkg -i",
            "Hold package dari pkg upgrade",
        ])
        lines += [
            "", hline(), f"  {B}Struktur output{R}", "",
            f"  {DIM}build/<package>/  :{R} working directory build",
            f"  {DIM}output/<pkg>.deb  :{R} file .deb hasil build", "",
        ]
    return lines


def content_upload(L):
    if L == "en":
        lines = sec("HOW TO UPLOAD A TOOL TO TERMUX APP STORE", "^")
        steps = [
            ("Step 1 -- Fork the repository",
             bul(["Open: https://github.com/djunekz/termux-app-store",
                  "Click Fork -> Create fork",
                  "Keep the repo name: termux-app-store"]), []),
            ("Step 2 -- Clone your fork", [],
             code("git clone https://github.com/USERNAME/termux-app-store",
                  "cd termux-app-store")),
            ("Step 3 -- Create a new branch", [],
             code("git checkout -b your-tool-name")),
            ("Step 4 -- Create package folder", [],
             code("mkdir -p packages/your-tool-name",
                  "nano packages/your-tool-name/build.sh")),
            ("Step 5 -- Fill in build.sh", [],
             code('TERMUX_PKG_HOMEPAGE=https://github.com/user/tool',
                  'TERMUX_PKG_DESCRIPTION="Short tool description"',
                  'TERMUX_PKG_LICENSE="MIT"',
                  'TERMUX_PKG_MAINTAINER="@your-github-username"',
                  "TERMUX_PKG_VERSION=1.0.0",
                  "TERMUX_PKG_SRCURL=https://...",
                  "TERMUX_PKG_SHA256=abc123...")),
            ("Step 6 -- Validate before committing", [],
             code("./termux-build lint packages/your-tool-name",
                  "./termux-build check-pr your-tool-name",
                  "./termux-build doctor")),
            ("Step 7 -- Commit and push", [],
             code("git add packages/your-tool-name",
                  'git commit -m "pkg: add your-tool-name"',
                  "git push origin your-tool-name")),
            ("Step 8 -- Create a Pull Request",
             bul(["Open your fork on GitHub",
                  "Click Compare & Pull Request",
                  "Describe: what the tool does, upstream source, how to test",
                  "Submit PR -- CI will validate automatically"]), []),
        ]
        rules = bul([
            f"{RED}DO NOT{R} upload locally compiled binaries",
            f"{RED}DO NOT{R} hardcode paths outside $PREFIX",
            "Source MUST come from official upstream",
            "CI (GitHub Actions) will reject PRs that fail lint",
            f"Commit message: {CYN}pkg: add <n>{R} or {CYN}fix: ..{R}",
        ])
        note_txt = "Auto-generate build.sh with: ./termux-build init <repo-url>"
        rules_title = f"  {B}Important rules{R}"
    else:
        lines = sec("CARA UPLOAD TOOL KE TERMUX APP STORE", "^")
        steps = [
            ("Langkah 1 -- Fork repository",
             bul(["Buka: https://github.com/djunekz/termux-app-store",
                  "Klik tombol Fork -> Create fork",
                  "Pastikan nama repo tetap: termux-app-store"]), []),
            ("Langkah 2 -- Clone fork kamu", [],
             code("git clone https://github.com/USERNAME/termux-app-store",
                  "cd termux-app-store")),
            ("Langkah 3 -- Buat branch baru", [],
             code("git checkout -b nama-tool-kamu")),
            ("Langkah 4 -- Buat folder package", [],
             code("mkdir -p packages/nama-tool-kamu",
                  "nano packages/nama-tool-kamu/build.sh")),
            ("Langkah 5 -- Isi build.sh", [],
             code("TERMUX_PKG_HOMEPAGE=https://github.com/user/tool",
                  'TERMUX_PKG_DESCRIPTION="Deskripsi singkat tool"',
                  'TERMUX_PKG_LICENSE="MIT"',
                  'TERMUX_PKG_MAINTAINER="@github-username-kamu"',
                  "TERMUX_PKG_VERSION=1.0.0",
                  "TERMUX_PKG_SRCURL=https://...",
                  "TERMUX_PKG_SHA256=abc123...")),
            ("Langkah 6 -- Validasi sebelum commit", [],
             code("./termux-build lint packages/nama-tool-kamu",
                  "./termux-build check-pr nama-tool-kamu",
                  "./termux-build doctor")),
            ("Langkah 7 -- Commit dan push", [],
             code("git add packages/nama-tool-kamu",
                  'git commit -m "pkg: add nama-tool-kamu"',
                  "git push origin nama-tool-kamu")),
            ("Langkah 8 -- Buat Pull Request",
             bul(["Buka fork kamu di GitHub",
                  "Klik Compare & Pull Request",
                  "Isi deskripsi: apa tool-nya, sumber upstream, cara test",
                  "Submit PR -- CI akan otomatis validasi"]), []),
        ]
        rules = bul([
            f"{RED}JANGAN{R} upload binary compiled dari local",
            f"{RED}JANGAN{R} hardcode path di luar $PREFIX",
            "Source HARUS dari upstream resmi",
            "CI (GitHub Actions) akan reject PR yang gagal lint",
            f"Commit message: {CYN}pkg: add <nama>{R} atau {CYN}fix: ..{R}",
        ])
        note_txt = "Bisa generate otomatis dengan: ./termux-build init <url-repo>"
        rules_title = f"  {B}Aturan penting{R}"

    for s_title, s_bul, s_code in steps:
        lines += [f"  {B}{s_title}{R}", ""]
        if s_bul: lines += s_bul + [""]
        if s_code:
            lines += s_code + [""]
            if "build.sh" in s_title.lower() and ("fill" in s_title.lower() or "isi" in s_title.lower()):
                lines += note(note_txt, L) + [""]
        lines += [hline()]

    lines += [rules_title, ""] + rules + [""]
    return lines


def content_buildsh(L):
    if L == "en":
        lines = sec("GUIDE TO WRITING build.sh", "%")
        lines += [
            f"  {B}Required fields{R}", "",
            f"  {CYN}TERMUX_PKG_HOMEPAGE{R}    -- Homepage URL / repo of the tool",
            f"  {CYN}TERMUX_PKG_DESCRIPTION{R} -- Short description (cannot be empty)",
            f"  {CYN}TERMUX_PKG_LICENSE{R}     -- License (MIT, GPL-3.0, Apache-2.0, etc)",
            f"  {CYN}TERMUX_PKG_MAINTAINER{R}  -- @your-github-username",
            f"  {CYN}TERMUX_PKG_VERSION{R}     -- Version, must start with a digit",
            f"  {CYN}TERMUX_PKG_SRCURL{R}      -- Download URL for source .tar.gz",
            f"  {CYN}TERMUX_PKG_SHA256{R}      -- SHA256 checksum of the source file",
            "", hline(), f"  {B}Optional fields{R}", "",
            f"  {CYN}TERMUX_PKG_DEPENDS{R}         -- pkg dependencies (python, curl, etc)",
            f"  {CYN}TERMUX_PKG_BUILD_IN_SRC{R}    -- true = build inside src directory",
            f"  {CYN}termux_step_make_install(){R}  -- Custom install function",
            "", hline(), f"  {B}Valid version formats{R}", "",
            f"  {BGRN}OK{R} 1.0.0   {BGRN}OK{R} 2.3.4   {BGRN}OK{R} 0.1-alpha   {BGRN}OK{R} 3.1.4-rc2",
            f"  {RED}NO{R} v1.2.3  (no 'v' prefix)   {RED}NO{R} latest   {RED}NO{R} T.G.D-1.0",
            "", hline(), f"  {B}Example build.sh for a Python script{R}", "",
        ]
    else:
        lines = sec("PANDUAN MENULIS build.sh", "%")
        lines += [
            f"  {B}Field wajib{R}", "",
            f"  {CYN}TERMUX_PKG_HOMEPAGE{R}    -- URL homepage / repo tool",
            f"  {CYN}TERMUX_PKG_DESCRIPTION{R} -- Deskripsi singkat (tidak boleh kosong)",
            f"  {CYN}TERMUX_PKG_LICENSE{R}     -- Lisensi (MIT, GPL-3.0, Apache-2.0, dll)",
            f"  {CYN}TERMUX_PKG_MAINTAINER{R}  -- @github-username kamu",
            f"  {CYN}TERMUX_PKG_VERSION{R}     -- Versi, harus mulai dengan angka",
            f"  {CYN}TERMUX_PKG_SRCURL{R}      -- URL download source .tar.gz",
            f"  {CYN}TERMUX_PKG_SHA256{R}      -- SHA256 checksum file source",
            "", hline(), f"  {B}Field opsional{R}", "",
            f"  {CYN}TERMUX_PKG_DEPENDS{R}         -- Dependency pkg (python, curl, dll)",
            f"  {CYN}TERMUX_PKG_BUILD_IN_SRC{R}    -- true = build langsung di src dir",
            f"  {CYN}termux_step_make_install(){R}  -- Custom install function",
            "", hline(), f"  {B}Format versi yang valid{R}", "",
            f"  {BGRN}OK{R} 1.0.0   {BGRN}OK{R} 2.3.4   {BGRN}OK{R} 0.1-alpha   {BGRN}OK{R} 3.1.4-rc2",
            f"  {RED}NO{R} v1.2.3  (tanpa 'v')   {RED}NO{R} latest   {RED}NO{R} T.G.D-1.0",
            "", hline(), f"  {B}Contoh build.sh untuk Python script{R}", "",
        ]
    lines += code(
        "TERMUX_PKG_HOMEPAGE=https://github.com/user/tool",
        'TERMUX_PKG_DESCRIPTION="Tool description"',
        'TERMUX_PKG_LICENSE="MIT"',
        'TERMUX_PKG_MAINTAINER="@username"',
        "TERMUX_PKG_VERSION=1.0.0",
        "TERMUX_PKG_SRCURL=https://github.com/user/tool/archive/v1.0.0.tar.gz",
        "TERMUX_PKG_SHA256=abc123...",
        'TERMUX_PKG_DEPENDS="python, python-pip"',
        "TERMUX_PKG_BUILD_IN_SRC=true",
        "",
        "termux_step_make_install() {",
        "    pip install -r requirements.txt \\",
        "        --break-system-packages || true",
        '    mkdir -p "$TERMUX_PREFIX/lib/tool"',
        '    cp -r . "$TERMUX_PREFIX/lib/tool/"',
        '    cat > "$TERMUX_PREFIX/bin/tool" <<\'EOF\'',
        "#!/usr/bin/env bash",
        'exec python3 "$TERMUX_PREFIX/lib/tool/main.py" "$@"',
        "EOF",
        '    chmod 0755 "$TERMUX_PREFIX/bin/tool"',
        "}",
    )
    lines.append("")
    return lines


def content_faq(L):
    if L == "en":
        title, Q = "FAQ -- FREQUENTLY ASKED QUESTIONS", [
            ("Is TAS a replacement for pkg/apt?",
             "No. TAS is a source-based app store, not a replacement for pkg.\n  pkg is still used to install dependencies."),
            ("Is this an official Termux project?",
             "No. TAS is an independent project, not affiliated with official\n  Termux maintainers."),
            ("Why are some packages marked UNSUPPORTED?",
             "Because the package depends on libraries not available in\n  Termux (e.g. gtk, zenity/X11, systemd)."),
            ("Does it work offline?",
             "The TUI works offline. Installing packages requires internet\n  to download source code."),
            ("Where are packages stored?",
             "$PREFIX/lib/.tas/packages/ (after install via tasctl)\n  or termux-app-store/packages/ if running manually."),
            ("Is root required?",
             "No. TAS runs entirely in Termux user space."),
            ("Why is installation slow?",
             "Possible reasons: slow network, large source, or a compilation\n  step. Check the log panel for progress."),
            ("Why is Python source hidden in binary releases?",
             "Binary releases speed up startup and prevent accidental edits.\n  The project remains open-source on GitHub."),
            ("Can I move the termux-app-store folder?",
             "Yes. TAS has a self-healing path resolver -- auto-detects\n  its location even after a move or rename."),
            ("Where do I report bugs?",
             "GitHub Issues: github.com/djunekz/termux-app-store/issues"),
        ]
    else:
        title, Q = "FAQ -- PERTANYAAN UMUM", [
            ("Apakah TAS pengganti pkg/apt?",
             "Tidak. TAS adalah source-based app store, bukan pengganti pkg.\n  pkg tetap dipakai untuk install dependencies."),
            ("Apakah ini proyek resmi Termux?",
             "Tidak. TAS adalah proyek independen, tidak berafiliasi dengan\n  maintainer Termux resmi."),
            ("Kenapa beberapa package ditandai UNSUPPORTED?",
             "Karena package tersebut bergantung pada library yang tidak\n  ada di Termux (misal: gtk, zenity/X11, systemd)."),
            ("Apakah bisa jalan offline?",
             "TUI bisa offline. Install package butuh internet\n  untuk download source code."),
            ("Di mana package disimpan?",
             "$PREFIX/lib/.tas/packages/ (setelah install via tasctl)\n  atau termux-app-store/packages/ jika manual."),
            ("Apakah butuh root?",
             "Tidak. TAS berjalan sepenuhnya di user space Termux."),
            ("Kok install lambat?",
             "Kemungkinan: jaringan lambat, source besar, atau ada tahap\n  kompilasi. Cek log panel untuk progress."),
            ("Kenapa Python source disembunyikan di binary?",
             "Binary release dibuat agar lebih cepat startup, mencegah\n  modifikasi tidak sengaja. Proyek tetap open-source di GitHub."),
            ("Bisa pindah folder termux-app-store?",
             "Bisa. TAS punya self-healing path resolver -- otomatis detect\n  lokasi sendiri walau folder dipindah/rename."),
            ("Dimana laporkan bug?",
             "GitHub Issues: github.com/djunekz/termux-app-store/issues"),
        ]
    lines = sec(title, "?")
    for i, (q, a) in enumerate(Q, 1):
        lines += [f"  {CYN}{B}Q{i}.{R} {B}{q}{R}", f"  {GRN}->{R}  {a}", ""]
    return lines


def content_troubleshoot(L):
    if L == "en":
        issues = [
            ("command not found: termux-app-store",
             "Restart Termux or run hash -r",
             ["hash -r", "termux-app-store"]),
            ("packages/ not found",
             "Ensure folder structure:\n  termux-app-store/packages/<n>/build.sh", []),
            ("ModuleNotFoundError: textual",
             "Install textual manually",
             ["pkg install python -y", "pip install textual"]),
            ("Permission denied",
             "Make the binary executable",
             ["chmod +x $PREFIX/bin/termux-app-store"]),
            ("Unsupported architecture",
             "Check arch -- supported: aarch64, armv7l, x86_64",
             ["uname -m"]),
            ("Build failed",
             "Scroll the log panel to find the cause",
             ["./termux-build doctor", "./termux-build lint <pkg>"]),
            ("Complete failure -- clean reinstall",
             "Clean reinstall from scratch",
             ["rm -f $PREFIX/bin/termux-app-store",
              "rm -rf $PREFIX/lib/.tas",
              "pip install termux-app-store"]),
        ]
    else:
        issues = [
            ("command not found: termux-app-store",
             "Restart Termux atau jalankan hash -r",
             ["hash -r", "termux-app-store"]),
            ("packages/ not found",
             "Pastikan struktur folder ada:\n  termux-app-store/packages/<n>/build.sh", []),
            ("ModuleNotFoundError: textual",
             "Install textual secara manual",
             ["pkg install python -y", "pip install textual"]),
            ("Permission denied",
             "Pastikan binary executable",
             ["chmod +x $PREFIX/bin/termux-app-store"]),
            ("Unsupported architecture",
             "Cek arsitektur -- support: aarch64, armv7l, x86_64",
             ["uname -m"]),
            ("Build failed",
             "Scroll log panel, cari penyebabnya",
             ["./termux-build doctor", "./termux-build lint <pkg>"]),
            ("Gagal total -- clean install",
             "Clean reinstall dari awal",
             ["rm -f $PREFIX/bin/termux-app-store",
              "rm -rf $PREFIX/lib/.tas",
              "pip install termux-app-store"]),
        ]
    lines = sec("TROUBLESHOOTING", "!")
    for err_title, desc, cmds in issues:
        lines += [f"  {BYLW}> {err_title}{R}", f"  {DIM}{desc}{R}", ""]
        if cmds:
            lines += code(*cmds) + [""]
    return lines


def content_contributing(L):
    if L == "en":
        lines = sec("CONTRIBUTING", "<3")
        lines += [f"  {B}Accepted contributions{R}", ""]
        lines += bul([
            "Add new packages (packages/<n>/build.sh)",
            "Fix existing build.sh files",
            "Fix CI / validation logic",
            "Improve CLI tools (termux-build, tasctl)",
            "Documentation & guides",
            "Bug reports & fixes",
            "Feature proposals",
        ])
        lines += ["", hline(), f"  {B}Contribution principles{R}", ""]
        lines += bul([
            f"{CYN}Automation-first{R} -- if it can be validated, it must be",
            f"{CYN}Reproducibility{R}  -- builds must be deterministic",
            f"{CYN}Transparency{R}     -- no hidden logic",
            f"{CYN}Community-first{R}  -- breaking changes require discussion",
        ])
        lines += ["", hline(), f"  {B}Commit message convention{R}", "",
                  f"  {CYN}pkg:{R}      new or updated package",
                  f"  {CYN}fix:{R}      bug fix",
                  f"  {CYN}ci:{R}       CI / workflow changes",
                  f"  {CYN}docs:{R}     documentation",
                  f"  {CYN}refactor:{R} internal changes",
                  f"  {CYN}chore:{R}    maintenance", ""]
        lines += code('git commit -m "pkg: add ripgrep"',
                      'git commit -m "fix: validate TERMUX_PKG_VERSION"')
        lines += ["", hline(), f"  {B}What is NOT allowed{R}", ""]
        lines += bul([
            f"{RED}Do not{R} submit malicious code / malware",
            f"{RED}Do not{R} submit binaries from local builds",
            f"{RED}Do not{R} hardcode paths outside $PREFIX",
            f"{RED}Do not{R} make breaking changes without discussion",
        ])
        lines += ["",
                  f"  {DIM}All PRs are automatically checked via GitHub Actions CI.{R}",
                  f"  {DIM}PRs cannot be merged if CI fails.{R}", ""]
    else:
        lines = sec("CARA KONTRIBUSI", "<3")
        lines += [f"  {B}Kontribusi yang diterima{R}", ""]
        lines += bul([
            "Tambah package baru (packages/<n>/build.sh)",
            "Perbaiki build.sh yang ada",
            "Perbaiki CI / validation logic",
            "Improvement CLI (termux-build, tasctl)",
            "Dokumentasi & panduan",
            "Bug report & fixes",
            "Feature proposal",
        ])
        lines += ["", hline(), f"  {B}Prinsip kontribusi{R}", ""]
        lines += bul([
            f"{CYN}Automation-first{R} -- kalau bisa divalidasi, harus divalidasi",
            f"{CYN}Reproducibility{R}  -- build harus deterministic",
            f"{CYN}Transparency{R}     -- tidak ada hidden logic",
            f"{CYN}Community-first{R}  -- breaking change harus diskusi dulu",
        ])
        lines += ["", hline(), f"  {B}Commit message convention{R}", "",
                  f"  {CYN}pkg:{R}      package baru atau update",
                  f"  {CYN}fix:{R}      bug fix",
                  f"  {CYN}ci:{R}       CI / workflow changes",
                  f"  {CYN}docs:{R}     dokumentasi",
                  f"  {CYN}refactor:{R} internal changes",
                  f"  {CYN}chore:{R}    maintenance", ""]
        lines += code('git commit -m "pkg: add ripgrep"',
                      'git commit -m "fix: validate TERMUX_PKG_VERSION"')
        lines += ["", hline(), f"  {B}Yang TIDAK boleh{R}", ""]
        lines += bul([
            f"{RED}Jangan{R} submit kode berbahaya / malware",
            f"{RED}Jangan{R} submit binary dari local build",
            f"{RED}Jangan{R} hardcode path di luar $PREFIX",
            f"{RED}Jangan{R} breaking change tanpa diskusi",
        ])
        lines += ["",
                  f"  {DIM}Semua PR dicek otomatis via GitHub Actions CI.{R}",
                  f"  {DIM}PR tidak bisa merge kalau CI gagal.{R}", ""]
    return lines


def get_menu(L):
    en = L == "en"
    return [
        ("1", "About Termux App Store"          if en else "Tentang Termux App Store",   content_about),
        ("2", "How to Install"                  if en else "Cara Install",                content_install),
        ("3", "How to Uninstall"                if en else "Cara Uninstall",              content_uninstall),
        ("4", "Using termux-app-store"          if en else "Penggunaan termux-app-store", content_usage),
        ("5", "Using tasctl"                    if en else "Penggunaan tasctl",           content_tasctl),
        ("6", "Using termux-build"              if en else "Penggunaan termux-build",     content_termux_build),
        ("7", "Using build-package.sh"          if en else "Penggunaan build-package.sh", content_build_package),
        ("8", "How to Upload a Tool"            if en else "Cara Upload Tool ke TAS",     content_upload),
        ("9", "Guide to Writing build.sh"       if en else "Panduan Menulis build.sh",    content_buildsh),
        ("f", "FAQ"                             if en else "FAQ",                         content_faq),
        ("t", "Troubleshooting"                 if en else "Troubleshooting",             content_troubleshoot),
        ("c", "Contributing"                    if en else "Cara Kontribusi",             content_contributing),
        ("l", f"{DIM}Switch language / Ganti bahasa{R}",                                  None),
        ("q", "Exit"                            if en else "Keluar",                      "quit"),
    ]


def banner(lang_label=""):
    cls()
    print(center(f"{BYLW}{B}Termux App Store{R}  {DIM}-- Guidebook{R}"))
    print(center(f"{DIM}github.com/djunekz/termux-app-store{R}"))
    if lang_label:
        print(center(f"{DIM}[ {lang_label} ]{R}"))
    print()
    print(hline("=", CYN))


def select_language():
    while True:
        banner()
        print(f"\n  {B}Select language / Pilih bahasa:{R}\n")
        print(f"  {DIM}[{R}{CYN}{B}1{R}{DIM}]{R}  {B}English{R}")
        print(f"  {DIM}[{R}{CYN}{B}2{R}{DIM}]{R}  {B}Indonesia{R}")
        print(f"\n  {DIM}[{R}{RED}{B}q{R}{DIM}]{R}  Exit / Keluar")
        print(f"\n{hline()}")
        print(f"  {DIM}Enter choice:{R} ", end="")
        try: ch = input().strip().lower()
        except (EOFError, KeyboardInterrupt): ch = "q"
        if ch == "1": return "en"
        if ch == "2": return "id"
        if ch == "q":
            cls()
            print(f"\n  {GRN}Goodbye / Sampai jumpa!{R}\n")
            sys.exit(0)


def main_menu(lang):
    while True:
        lang_label = "English" if lang == "en" else "Indonesia"
        menu = get_menu(lang)
        topic = "Choose a topic:" if lang == "en" else "Pilih topik:"
        prompt = "Type number/letter then Enter" if lang == "en" else "Ketik nomor/huruf lalu Enter"
        bye = (f"\n  {GRN}{B}Thanks for using Termux App Store!{R}\n"
               if lang == "en" else
               f"\n  {GRN}{B}Terima kasih telah menggunakan Termux App Store!{R}\n")
        unknown = "Unknown choice" if lang == "en" else "Pilihan tidak dikenali"

        banner(lang_label)
        print(f"  {B}{topic}{R}\n")
        for key, label, _ in menu:
            if key == "q":
                print(f"\n  {DIM}[{R}{RED}{B}{key}{R}{DIM}]{R}  {label}")
            elif key == "l":
                print(f"  {DIM}[{R}{BYLW}{B}{key}{R}{DIM}]{R}  {label}")
            else:
                print(f"  {DIM}[{R}{CYN}{B}{key}{R}{DIM}]{R}  {label}")

        print(f"\n{hline()}")
        print(f"  {DIM}{prompt}{R}", end="  ")
        try: choice = input().strip().lower()
        except (EOFError, KeyboardInterrupt): choice = "q"

        matched = False
        for key, _, fn in menu:
            if choice == key:
                matched = True
                if fn == "quit":
                    cls()
                    print(bye)
                    print(f"  {DIM}github.com/djunekz/termux-app-store{R}\n")
                    sys.exit(0)
                elif fn is None:
                    lang = "id" if lang == "en" else "en"
                else:
                    pager(fn(lang), lang)
                break

        if not matched:
            banner(lang_label)
            print(f"\n  {BYLW}{unknown}: '{choice}'{R}\n")
            pause(lang)

if __name__ == "__main__":
    try:
        lang = select_language()
        main_menu(lang)
    except KeyboardInterrupt:
        cls()
        print(f"\n  {DIM}Bye.{R}\n")
        sys.exit(0)
