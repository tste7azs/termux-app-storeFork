TERMUX_PKG_HOMEPAGE=https://github.com/mishakorzik/UserFinder
TERMUX_PKG_DESCRIPTION="userfinder — auto-packaged by termux-build-init"
TERMUX_PKG_LICENSE="UNKNOWN"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/mishakorzik/UserFinder/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=fa6bffdffae84402230f19a2d4a740ebd9b731711fb5198c78dfe6c23120526b

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "UserFinder.sh" "$TERMUX_PREFIX/bin/userfinder"
}
