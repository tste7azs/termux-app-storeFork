TERMUX_PKG_HOMEPAGE=https://github.com/D4Vinci/Clickjacking-Tester
TERMUX_PKG_DESCRIPTION="A python script designed to check if the website if vulnerable of clickjacking and create a poc"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/D4Vinci/Clickjacking-Tester/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=21c128c44d965ee337c8f946c07144de3a2a8d14320364015312870abe2267d3

TERMUX_PKG_DEPENDS="python, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true


    local libdir="$TERMUX_PREFIX/lib/clickjacking-tester"
    mkdir -p "$libdir"
    cp -r . "$libdir/"

    find "$libdir" -type d | while read -r _dir; do
        if ls "$_dir"/*.py &>/dev/null 2>&1 && [[ ! -f "$_dir/__init__.py" ]]; then
            touch "$_dir/__init__.py"
        fi
    done



    cat > "$TERMUX_PREFIX/bin/clickjacking-tester" <<'WRAPPER'
#!/usr/bin/env bash
cd "${TERMUX_PREFIX}/lib/clickjacking-tester" || exit 1
exec python3 "${TERMUX_PREFIX}/lib/clickjacking-tester/Clickjacking_Tester.py" "$@"
WRAPPER
    sed -i "s|\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "$TERMUX_PREFIX/bin/clickjacking-tester"
    chmod 0755 "$TERMUX_PREFIX/bin/clickjacking-tester"
}
