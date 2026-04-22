TERMUX_PKG_HOMEPAGE=https://github.com/droidv1/pymaker
TERMUX_PKG_DESCRIPTION="Simple tool for create python script"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/djunekz/archive/releases/download/v${TERMUX_PKG_VERSION}/pymaker-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2fe03f6839e7b550f888d477628b852d648ea4ed688643122d3c182d495564e4
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="python"

termux_step_make_install() {
    local dest="$TERMUX_PREFIX/share/pymaker"
    rm -rf "$dest"
    cp -r "$TERMUX_PKG_SRCDIR"/. "$dest/"

    local entry="pymaker.py"
    [ -f "$dest/main.py" ] && entry="main.py"
    [ -f "$dest/pymaker.py" ] && entry="pymaker.py"

    mkdir -p "$TERMUX_PREFIX/bin"
    cat > "$TERMUX_PREFIX/bin/pymaker" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
cd "/data/data/com.termux/files/usr/share/pymaker"
exec python "${entry}" "\$@"
WRAPPER
    chmod +x "$TERMUX_PREFIX/bin/pymaker"
}
