TERMUX_PKG_HOMEPAGE=https://github.com/Rajkumrdusad/MyServer
TERMUX_PKG_DESCRIPTION="myserver — auto-packaged by termux-build-init"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Rajkumrdusad/MyServer/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=459a6caf18c8c70558a988b88c75be2d8512a165a034e3782a661967d26a9a43

TERMUX_PKG_DEPENDS="php, python, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true
    pip install --quiet apache core logo modules ng nginx pyweb system --break-system-packages 2>/dev/null || true

    local libdir="$TERMUX_PREFIX/lib/myserver"
    mkdir -p "$libdir"
    cp -r . "$libdir/"

    find "$libdir" -type d | while read -r _dir; do
        if ls "$_dir"/*.py &>/dev/null 2>&1 && [[ ! -f "$_dir/__init__.py" ]]; then
            touch "$_dir/__init__.py"
        fi
    done



    cat > "$TERMUX_PREFIX/bin/myserver" <<'WRAPPER'
#!/usr/bin/env bash
cd "${TERMUX_PREFIX}/lib/myserver" || exit 1
exec python3 "${TERMUX_PREFIX}/lib/myserver/MyServer.py" "$@"
WRAPPER
    sed -i "s|\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "$TERMUX_PREFIX/bin/myserver"
    chmod 0755 "$TERMUX_PREFIX/bin/myserver"
}
