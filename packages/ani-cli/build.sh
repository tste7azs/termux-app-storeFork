TERMUX_PKG_HOMEPAGE=https://github.com/pystardust/ani-cli
TERMUX_PKG_DESCRIPTION="A cli tool to browse and play anime"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=4.11
TERMUX_PKG_SRCURL=https://github.com/pystardust/ani-cli/releases/download/v${TERMUX_PKG_VERSION}/ani-cli
TERMUX_PKG_SHA256=1f35c47b0c6d924261d096663d16b03d489f488fcc38c74e4fe87b45a330b7cf
TERMUX_PKG_DEPENDS="nodejs, fzf"

termux_step_make_install() {
    npm install -g --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"

    if [ ! -f "$TERMUX_PREFIX/bin/ani-cli" ]; then
        cd "$TERMUX_PKG_SRCDIR"
        npm install --production
        npm link
    fi
}
