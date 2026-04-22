TERMUX_PKG_HOMEPAGE=https://github.com/EgeBalci/The-Eye
TERMUX_PKG_DESCRIPTION="Simple security surveillance script for linux distributions."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux-app-store"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/EgeBalci/The-Eye/archive/refs/heads/master.tar.gz
TERMUX_PKG_SHA256=a32f2b55436731b6347ef4c6ead5d9465e708414eda7323d0b4c63f29dde4765

TERMUX_PKG_DEPENDS="golang"

termux_step_make_install() {
    export GOPATH="$PWD/gopath"
    export GOPROXY="https://proxy.golang.org,direct"
    if [[ -f go.mod ]]; then
        go get ./... 2>/dev/null || true
        go build -v -o "$TERMUX_PREFIX/bin/the-eye" .
    else
        # No go.mod — init module, fetch deps, then build
        go mod init "the-eye" 2>/dev/null || true
        go get ./... 2>/dev/null || true
        go mod tidy 2>/dev/null || true
        go build -v -o "$TERMUX_PREFIX/bin/the-eye" . 2>/dev/null             || go build -v -o "$TERMUX_PREFIX/bin/the-eye" *.go
    fi
}
