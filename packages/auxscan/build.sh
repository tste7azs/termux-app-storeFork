TERMUX_PKG_HOMEPAGE=https://github.com/Gameye98/Auxscan
TERMUX_PKG_DESCRIPTION="Vulnerability Scanner to automate certain tasks"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Gameye98/Auxscan/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=fc66c68f438df226328b6a78347c9862e33b9e30e60c3e0e73b57033c60a9631

TERMUX_PKG_DEPENDS="python, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true
    pip install --quiet requests --break-system-packages 2>/dev/null || true

    local libdir="$TERMUX_PREFIX/lib/auxscan"
    mkdir -p "$libdir"
    cp -r . "$libdir/"

    find "$libdir" -type d | while read -r _dir; do
        if ls "$_dir"/*.py &>/dev/null 2>&1 && [[ ! -f "$_dir/__init__.py" ]]; then
            touch "$_dir/__init__.py"
        fi
    done

    cat > "$TERMUX_PREFIX/bin/auxscan" <<'WRAPPER'
#!/usr/bin/env bash
cd "${TERMUX_PREFIX}/lib/auxscan" || exit 1
exec python3 "${TERMUX_PREFIX}/lib/auxscan/auxscan.py" "$@"
WRAPPER
    sed -i "s|\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "$TERMUX_PREFIX/bin/auxscan"
    chmod 0755 "$TERMUX_PREFIX/bin/auxscan"
}
