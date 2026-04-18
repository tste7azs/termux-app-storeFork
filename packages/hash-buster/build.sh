TERMUX_PKG_HOMEPAGE=https://github.com/UltimateHackers/Hash-Buster
TERMUX_PKG_DESCRIPTION="hash-buster — auto-packaged by termux-build-init"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/UltimateHackers/Hash-Buster/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=16f9d31e08336b37ff52ac9cfc5f6884bcd3481f5ee2388f5f8760f4e87c2718


termux_step_make() {
    make -j"$(nproc)" PREFIX="$TERMUX_PREFIX"
}

termux_step_make_install() {
    make install PREFIX="$TERMUX_PREFIX"
}
