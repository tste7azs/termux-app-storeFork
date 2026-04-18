TERMUX_PKG_HOMEPAGE=https://kasroudra.github.io/IP-Tracker
TERMUX_PKG_DESCRIPTION="Track anyone's IP just opening a link!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/KasRoudra/IP-Tracker/archive/refs/heads/main.tar.gz
TERMUX_PKG_SHA256=09c7aeeb82bf67868283d398d51f775985d4f43500f0edfdd03b84ac9067b777

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "ip.sh" "$TERMUX_PREFIX/bin/ip-tracker"
}
