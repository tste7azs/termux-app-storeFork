TERMUX_PKG_HOMEPAGE=https://github.com/LimerBoy/Impulse
TERMUX_PKG_DESCRIPTION="Denial-of-Service ToolKit with multiple attack methods"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/djunekz/archive/releases/download/v${TERMUX_PKG_VERSION}/impulse.tar.gz
TERMUX_PKG_SHA256=d03e1a4c74a09b63900ffd1bc889bbc8f5720b83914b1a2fdd5453fb23a63c18
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="python"

termux_step_make_install() {
    local dest="$TERMUX_PREFIX/share/impulse"
    rm -rf "$dest"
    cp -r "$TERMUX_PKG_SRCDIR"/. "$dest/"

    local entry="Impulse.py"
    [ -f "$dest/impulse.py" ] && entry="impulse.py"
    [ -f "$dest/main.py" ] && entry="main.py"
    [ -f "$dest/Impulse.py" ] && entry="Impulse.py"

    mkdir -p "$TERMUX_PREFIX/bin"
    cat > "$TERMUX_PREFIX/bin/impulse" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
cd "/data/data/com.termux/files/usr/share/impulse"
exec python "${entry}" "\$@"
WRAPPER
    chmod +x "$TERMUX_PREFIX/bin/impulse"
}
