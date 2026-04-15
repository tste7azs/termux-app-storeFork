TERMUX_PKG_HOMEPAGE=https://github.com/djunekz/cybertuz
TERMUX_PKG_DESCRIPTION="Comprehensive Educational Learning Platform for Termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/djunekz/cybertuz/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=de6f948ecfe97e875bdbabe2073671da29a8521de465ad6a577476749a9fef59
TERMUX_PKG_DEPENDS="nmap, python, whois, curl, dnsutils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    local dest="$TERMUX_PREFIX/share/cybertuz"
    rm -rf "$dest"
    cp -r "$TERMUX_PKG_SRCDIR"/. "$dest/"

    local entry="cybertuz.sh"
    [ -f "$dest/lang.sh" ] && entry="lang.sh"
    [ -f "$dest/cybertuz.sh" ] && entry="cybertuz.sh"

    mkdir -p "$TERMUX_PREFIX/bin"
    cat > "$TERMUX_PREFIX/bin/cybertuz" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
cd "/data/data/com.termux/files/usr/share/cybertuz"
exec bash "${entry}" "\$@"
WRAPPER
    chmod +x "$TERMUX_PREFIX/bin/cybertuz"
}
