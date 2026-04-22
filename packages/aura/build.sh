TERMUX_PKG_HOMEPAGE=https://github.com/djunekz/aura
TERMUX_PKG_DESCRIPTION="Adaptive Unified Runtime Assistant"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL=https://github.com/djunekz/aura/archive/refs/tags/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=f9cfa5f137ad035f35faace06f00eb61d368e39c24a12521da1ff1bac235d630
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    npm install --prefix "$TERMUX_PKG_SRCDIR"

    mkdir -p "$TERMUX_PREFIX/lib/aura"
    cp -r "$TERMUX_PKG_SRCDIR"/. "$TERMUX_PREFIX/lib/aura/"

    mkdir -p "$TERMUX_PREFIX/bin"
    cat > "$TERMUX_PREFIX/bin/aura" <<'WRAPPER'
#!/data/data/com.termux/files/usr/bin/bash
exec node "/data/data/com.termux/files/usr/lib/aura/aura.js" "$@"
WRAPPER
    chmod +x "$TERMUX_PREFIX/bin/aura"
}
