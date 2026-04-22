TERMUX_PKG_HOMEPAGE=https://github.com/UndeadSec/GoblinWordGenerator
TERMUX_PKG_DESCRIPTION="Python wordlist generator "
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/UndeadSec/GoblinWordGenerator/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=4751cc403e2bffd0540036ddc6c8fa2ec7cc50ac129bbeb17b6206d433b4f871

TERMUX_PKG_DEPENDS="python, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true


    local libdir="$TERMUX_PREFIX/lib/goblinwordgenerator"
    mkdir -p "$libdir"
    cp -r . "$libdir/"

    find "$libdir" -type d | while read -r _dir; do
        if ls "$_dir"/*.py &>/dev/null 2>&1 && [[ ! -f "$_dir/__init__.py" ]]; then
            touch "$_dir/__init__.py"
        fi
    done



    cat > "$TERMUX_PREFIX/bin/goblinwordgenerator" <<'WRAPPER'
#!/usr/bin/env bash
cd "${TERMUX_PREFIX}/lib/goblinwordgenerator" || exit 1
exec python3 "${TERMUX_PREFIX}/lib/goblinwordgenerator/goblin.py" "$@"
WRAPPER
    sed -i "s|\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "$TERMUX_PREFIX/bin/goblinwordgenerator"
    chmod 0755 "$TERMUX_PREFIX/bin/goblinwordgenerator"
}
