TERMUX_PKG_HOMEPAGE=https://github.com/Anon4You/Termux-Ai
TERMUX_PKG_DESCRIPTION="Interactive AI tool for Termux with 10+ providers and 50+ image models ✨"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Anon4You/Termux-Ai/archive/refs/heads/main.tar.gz
TERMUX_PKG_SHA256=ca5e517ef81e8ef94bc9433514cae4ab305d79f76bc1d7682b2d5f85d41bf8b6

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "termux-ai.sh" "$TERMUX_PREFIX/bin/termux-ai"
}
