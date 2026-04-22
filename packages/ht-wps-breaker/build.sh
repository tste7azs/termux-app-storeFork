TERMUX_PKG_HOMEPAGE=https://github.com/SilentGhostX/HT-WPS-Breaker
TERMUX_PKG_DESCRIPTION="HT-WPS Breaker (High Touch WPS Breaker)"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/SilentGhostX/HT-WPS-Breaker/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=556101fa55aeb073d0a2908f1d667e34eeefbcbdb38c8723b7f862352d40f848

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "HT-WB.sh" "$TERMUX_PREFIX/bin/ht-wps-breaker"
}
