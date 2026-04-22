TERMUX_PKG_HOMEPAGE=https://github.com/Hax4us/TermuxAlpine
TERMUX_PKG_DESCRIPTION="Use TermuxAlpine.sh calling to install Alpine Linux in Termux on Android. This setup script will attempt to set Alpine Linux up in your Termux environment."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Hax4us/TermuxAlpine/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=2dae317bcce989a909f171c1843db9479012bcbbb23cc8f729cc73ce4d8af6fa

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "TermuxAlpine.sh" "$TERMUX_PREFIX/bin/termuxalpine"
}
