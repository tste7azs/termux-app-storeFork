TERMUX_PKG_HOMEPAGE=https://github.com/Dionach/CMSmap
TERMUX_PKG_DESCRIPTION="CMSmap is a python open source CMS scanner that automates the process of detecting security flaws of the most popular CMSs. "
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Dionach/CMSmap/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=da902ef29ca2c464a100b51b596bfd31066a68a825fc2522d24f415aed5413c2

TERMUX_PKG_DEPENDS="python, python-pip, python-setuptools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true
    pip install --quiet cmsmap package setuptools --break-system-packages 2>/dev/null || true
    pip install . --prefix="$TERMUX_PREFIX" --no-deps --break-system-packages 2>/dev/null \
        || pip install . --prefix="$TERMUX_PREFIX" --no-deps --no-build-isolation --break-system-packages || {
            echo "pip failed — falling back to manual install"
            mkdir -p "$TERMUX_PREFIX/lib/cmsmap"
            cp -r . "$TERMUX_PREFIX/lib/cmsmap/"
        }
}
