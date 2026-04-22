TERMUX_PKG_HOMEPAGE=https://github.com/Tuhinshubhra/RED_HAWK
TERMUX_PKG_DESCRIPTION="All in one tool for Information Gathering, Vulnerability Scanning and Crawling. A must have tool for all penetration testers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/Tuhinshubhra/RED_HAWK/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=5988892dcea9993e7388c41c1d98c284774fb27866c6ff61e53815ef04a07077

TERMUX_PKG_DEPENDS="php"

termux_step_make_install() {
    mkdir -p "$TERMUX_PREFIX/lib/red-hawk"
    cp -r . "$TERMUX_PREFIX/lib/red-hawk/"
    cat > "$TERMUX_PREFIX/bin/red-hawk" <<'WRAPPER'
#!/usr/bin/env bash
exec php "/data/data/com.termux/files/usr/lib/red-hawk/rhawk.php" "php red-hawk rhawk.php php   "
WRAPPER
    chmod 0755 "$TERMUX_PREFIX/bin/red-hawk"
}
