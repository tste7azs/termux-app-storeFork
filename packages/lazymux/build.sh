TERMUX_PKG_HOMEPAGE=https://github.com/Gameye98/Lazymux
TERMUX_PKG_DESCRIPTION="termux tool installer"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Gameye98/Lazymux/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=a5036eec654ad1adf3736317104ec9fedd97511fe3ba8ccd956fe7bea431afcd

TERMUX_PKG_DEPENDS="python, python-core, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true

    local libdir="$TERMUX_PREFIX/lib/lazymux"
    mkdir -p "$libdir"
    cp -r . "$libdir/"

    cat > "$TERMUX_PREFIX/bin/lazymux" <<'WRAPPER'

cd "${TERMUX_PREFIX}/lib/lazymux" || exit 1
exec python3 "${TERMUX_PREFIX}/lib/lazymux/lazymux.py" "$@"
WRAPPER
    sed -i "s|\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "$TERMUX_PREFIX/bin/lazymux"
    chmod 0755 "$TERMUX_PREFIX/bin/lazymux"
}
