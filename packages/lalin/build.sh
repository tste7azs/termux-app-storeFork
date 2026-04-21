TERMUX_PKG_HOMEPAGE=https://github.com/Screetsec/LALIN
TERMUX_PKG_DESCRIPTION="this script automatically install any package for pentest with uptodate tools , and lazy command for run the tools like lazynmap , install another and update to new #actually for lazy people hahaha #and Lalin is remake the lazykali with fixed bugs , added new features and uptodate tools . It's compatible with the latest release of Kali (Rolling)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Screetsec/LALIN/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=f6d8f683a7cfea3ea7da10562976efdedd380bcbb61108702342564acbcf644e

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "Lalin.sh" "$TERMUX_PREFIX/bin/lalin"
}
