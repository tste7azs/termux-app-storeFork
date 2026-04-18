TERMUX_PKG_HOMEPAGE=https://github.com/Ha3MrX/Gemail-Hack
TERMUX_PKG_DESCRIPTION="python script for Hack gmail account brute force"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Ha3MrX/Gemail-Hack/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=36dfa4b305e8b7660ae92e817254545e4aa6b5daf23446a2a4c475e3aef6cde9

TERMUX_PKG_DEPENDS="python, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true


    local libdir="$TERMUX_PREFIX/lib/gemail-hack"
    mkdir -p "$libdir"
    cp -r . "$libdir/"

    find "$libdir" -type d | while read -r _dir; do
        if ls "$_dir"/*.py &>/dev/null 2>&1 && [[ ! -f "$_dir/__init__.py" ]]; then
            touch "$_dir/__init__.py"
        fi
    done



    cat > "$TERMUX_PREFIX/bin/gemail-hack" <<'WRAPPER'
#!/usr/bin/env bash
cd "${TERMUX_PREFIX}/lib/gemail-hack" || exit 1
exec python3 "${TERMUX_PREFIX}/lib/gemail-hack/gemailhack.py" "$@"
WRAPPER
    sed -i "s|\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "$TERMUX_PREFIX/bin/gemail-hack"
    chmod 0755 "$TERMUX_PREFIX/bin/gemail-hack"
}
