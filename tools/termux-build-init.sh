#!/usr/bin/env bash
# =============================================================================
#   Termux Build Init
#   Auto create & build GitHub repo as a Termux .deb package
#   github.com/djunekz/termux-app-store
# =============================================================================
set -euo pipefail

_SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ "$(basename "$_SELF_DIR")" == "tools" ]]; then
    ROOT="$(dirname "$_SELF_DIR")"
else
    ROOT="$_SELF_DIR"
fi
PACKAGES_DIR="$ROOT/packages"
BUILD_SCRIPT="$ROOT/build-package.sh"

R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'
B='\033[0;34m'; C='\033[0;36m'; W='\033[1;37m'; N='\033[0m'
ok()    { echo -e "  ${G}[  OK  ]${N}  $*"; }
info()  { echo -e "  ${C}[ INFO ]${N}  $*"; }
warn()  { echo -e "  ${Y}[  !!  ]${N}  $*"; }
fail()  { echo -e "  ${R}[ FAIL ]${N}  $*"; exit 1; }
step()  { echo -e "\n${B}:: $*${N}\n${B}$(printf '%.0s-' {1..79})${N}"; }

banner() {
cat <<'EOF'

══════════════════════════════════════════════════════════════════════════
        Termux Build Init  -  Auto Create and Build package
              github.com/djunekz/termux-app-store
══════════════════════════════════════════════════════════════════════════
EOF
}

need() {
    command -v "$1" &>/dev/null || fail "Required tool not found: $1 — install it first"
}
need curl; need tar; need sha256sum; need sed; need awk

sanitize_pkgname() {
    local raw="$1"
    local name
    name=$(echo "$raw" | tr '[:upper:]' '[:lower:]')
    name=$(echo "$name" | tr '_' '-')
    name=$(echo "$name" | sed 's/[^a-z0-9-]/-/g')
    name=$(echo "$name" | sed 's/-\+/-/g')
    name="${name#-}"; name="${name%-}"
    echo "$name"
}

join_deps() {
    echo "$*" | tr ',' ' ' | tr ' ' '\n' | grep -v '^$' | sort -u \
        | awk 'BEGIN{first=1} {if(first){printf "%s",$0;first=0} else {printf ", %s",$0}} END{print ""}'
}

pkg_deps() {
    echo "$*" | tr ' ' '\n' | grep '^pkg:' | sed 's/^pkg://' | sort -u | xargs
}

pip_deps() {
    echo "$*" | tr ' ' '\n' | grep '^pip:' | sed 's/^pip://' | sort -u | xargs
}

map_python_dep() {
    local mod="$1"
    case "$mod" in
        sys|os|re|io|abc|ast|cmd|csv|dis|gc|getopt|glob|gzip|hmac|http|ipaddress|\
        json|logging|math|mmap|operator|pathlib|pickle|platform|pprint|queue|\
        random|shlex|shutil|signal|socket|sqlite3|ssl|stat|string|struct|\
        subprocess|tempfile|textwrap|threading|time|traceback|typing|unicodedata|\
        unittest|urllib|uuid|warnings|xml|xmlrpc|zipfile|zlib|argparse|\
        collections|contextlib|copy|dataclasses|datetime|decimal|email|\
        enum|functools|hashlib|html|inspect|itertools|multiprocessing|\
        base64|binascii|builtins|cgi|cgitb|chunk|cmath|code|codecs|\
        compileall|concurrent|configparser|ctypes|curses|dbm|difflib|\
        doctest|encodings|filecmp|fileinput|fnmatch|fractions|ftplib|\
        getpass|gettext|grp|imaplib|importlib|keyword|lib2to3|linecache|\
        locale|lzma|mailbox|mailcap|marshal|mimetypes|modulefinder|\
        netrc|nis|nntplib|numbers|opcode|optparse|ossaudiodev|parser|\
        pdb|pkgutil|poplib|posix|posixpath|pprint|profile|pstats|pty|\
        pwd|py_compile|pyclbr|pydoc|readline|reprlib|resource|rlcompleter|\
        runpy|sched|secrets|select|selectors|shelve|smtpd|smtplib|\
        sndhdr|spwd|statistics|stringprep|sunau|symtable|sysconfig|\
        syslog|tabnanny|tarfile|telnetlib|termios|test|timeit|token|\
        tokenize|trace|tracemalloc|tty|turtle|turtledemo|types|uu|venv|\
        wave|weakref|webbrowser|wsgiref|xdrlib|zipapp|zipimport) return ;;
    esac

    case "$mod" in
        python)         echo "pkg:python" ;;
        rust)           echo "pkg:rust" ;;
        nodejs)         echo "pkg:nodejs" ;;
        nmap)           echo "pkg:nmap" ;;
        openssh)        echo "pkg:openssh" ;;
        gi)             echo "pkg:glib" ;;
        gzip)           echo "pkg:gzip" ;;
        zip)            echo "pkg:zip" ;;
        unzip)          echo "pkg:unzip" ;;
        git)            echo "pkg:git" ;;
        bzip2)          echo "pkg:bzip2" ;;
        xz)             echo "pkg:xz" ;;
        clang)          echo "pkg:clang" ;;
        cmake)          echo "pkg:cmake" ;;
        libtool)        echo "pkg:libtool" ;;
        ninja)          echo "pkg:ninja" ;;
        automake)       echo "pkg:automake" ;;
        autoconf)       echo "pkg:autoconf" ;;
        python-setuptools) echo "pkg:python-setuptools" ;;
        python-wheel)   echo "pkg:python-wheel" ;;
        python-pip)     echo "pkg:python-pip" ;;
        openssl)        echo "pkg:openssl" ;;
        openssl-dev)    echo "pkg:openssl-dev" ;;
        libffi)         echo "pkg:libffi" ;;
        zlib)           echo "pkg:zlib" ;;
        libffi-dev)     echo "pkg:libffi-dev" ;;
        zlib-dev)       echo "pkg:zlib-dev" ;;
        libxml2)        echo "pkg:libxml2" ;;
        libxml2-dev)    echo "pkg:libxml2-dev" ;;
        libjpeg-turbo)  echo "pkg:libjpeg-turbo" ;;
        libpng)         echo "pkg:libpng" ;;
        freetype)       echo "pkg:freetype" ;;
        sqlite)         echo "pkg:sqlite" ;;
        sqlite-dev)     echo "pkg:sqlite-dev" ;;
        libcurl)        echo "pkg:libcurl" ;;
        npm)            echo "pkg:npm" ;;
        perl)           echo "pkg:perl" ;;
        ruby)           echo "pkg:ruby" ;;
        gh)             echo "pkg:gh" ;;
        vim)            echo "pkg:vim" ;;
        tree)           echo "pkg:tree" ;;
        neovim)         echo "pkg:neovim" ;;
        hydra)          echo "pkg:hydra" ;;
        php)            echo "pkg:php" ;;
        libssh)         echo "pkg:libssh" ;;
        libssh2)        echo "pkg:libssh2" ;;
        mariadb)        echo "pkg:mariadb" ;;
        redis)          echo "pkg:redis" ;;
        imagemagick)    echo "pkg:imagemagick" ;;
        ffmpeg)         echo "pkg:ffmpeg" ;;
        termux-tools)   echo "pkg:termux-tools" ;;

        requests)       echo "pip:requests" ;;
        bs4|beautifulsoup4) echo "pip:beautifulsoup4" ;;
        lxml)           echo "pip:lxml" ;;
        PIL|Pillow)     echo "pip:pillow" ;;
        numpy)          echo "pip:numpy" ;;
        pandas)         echo "pip:pandas" ;;
        scipy)          echo "pip:scipy" ;;
        matplotlib)     echo "pip:matplotlib" ;;
        cryptography)   echo "pip:cryptography" ;;
        paramiko)       echo "pip:paramiko" ;;
        scapy)          echo "pip:scapy" ;;
        psutil)         echo "pip:psutil" ;;
        pexpect)        echo "pip:pexpect" ;;
        ptyprocess)     echo "pip:ptyprocess" ;;
        yaml|ruamel)    echo "pip:yaml" ;;
        six)            echo "pip:six" ;;
        attr|attrs)     echo "pip:attrs" ;;
        certifi)        echo "pip:certifi" ;;
        charset_normalizer|chardet) echo "pip:chardet" ;;
        idna)           echo "pip:idna" ;;
        urllib3)        echo "pip:urllib3" ;;
        aiohttp)        echo "pip:aiohttp" ;;
        pyzmq|zmq)      echo "pip:pyzmq" ;;
        click)          echo "pip:click" ;;
        rich)           echo "pip:rich" ;;
        colorama)       echo "pip:colorama" ;;
        tzdata)         echo "pip:tzdata" ;;
        bcrypt)         echo "pip:bcrypt" ;;
        flask)          echo "pip:flask" ;;
        sqlalchemy)     echo "pip:sqlalchemy" ;;
        toml|tomllib)   echo "pip:toml" ;;
        dotenv)         echo "pip:dotenv" ;;
        pyfiglet)       echo "pip:pyfiglet" ;;
        tqdm)           echo "pip:tqdm" ;;
        termcolor)      echo "pip:termcolor" ;;
        humanfriendly)  echo "pip:humanfriendly" ;;
        wget)           echo "pip:wget" ;;
        prettytable)    echo "pip:prettytable" ;;
        tabulate)       echo "pip:tabulate" ;;
        termtables)     echo "pip:termtables" ;;
        fire)           echo "pip:fire" ;;
        docopt)         echo "pip:docopt" ;;
        cachetools)     echo "pip:cachetools" ;;
        pytz)           echo "pip:pytz" ;;
        dateutil)       echo "pip:python-dateutil" ;;
        jwt)            echo "pip:PyJWT" ;;
        nacl)           echo "pip:pynacl" ;;
        httpx)          echo "pip:httpx" ;;
        websockets)     echo "pip:websockets" ;;
        pynput)         echo "pip:pynput" ;;
        keyboard)       echo "pip:keyboard" ;;
        loguru)         echo "pip:loguru" ;;
        typer)          echo "pip:typer" ;;
        uvicorn)        echo "pip:uvicorn" ;;
        fastapi)        echo "pip:fastapi" ;;
        django)         echo "pip:django" ;;
        flask_restful)  echo "pip:flask-restful" ;;
        pyperclip)      echo "pip:pyperclip" ;;
        netifaces)      echo "pip:netifaces" ;;
        netaddr)        echo "pip:netaddr" ;;

        *)              echo "pip:$mod" ;;
    esac
}

scan_python_declared_deps() {
    local src="$1"
    local deps=()

    if [[ -f "$src/requirements.txt" ]]; then
        while IFS= read -r line; do
            line=$(echo "$line" | sed 's/[>=<!~^].*//' | tr -d ' ' | cut -d'[' -f1)
            [[ -z "$line" || "$line" == \#* ]] && continue
            local mapped; mapped=$(map_python_dep "$line")
            [[ -n "$mapped" ]] && deps+=("$mapped")
        done < "$src/requirements.txt"
    fi

    if [[ -f "$src/setup.py" ]]; then
        local reqs
        reqs=$(sed -n '/install_requires/,/\]/p' "$src/setup.py" 2>/dev/null \
            | grep -o '"[^"]*"\|'\''[^'\'']*'\''' \
            | tr -d '"'\''  ' \
            | sed 's/[>=<!~^].*//' || true)
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local mapped; mapped=$(map_python_dep "$line")
            [[ -n "$mapped" ]] && deps+=("$mapped")
        done <<< "$reqs"
    fi

    if [[ -f "$src/pyproject.toml" ]]; then
        local reqs
        reqs=$(sed -n '/dependencies/,/\]/p' "$src/pyproject.toml" 2>/dev/null \
            | grep -o '"[^"]*"' \
            | tr -d '"' \
            | sed 's/[>=<!~^;\[].*//' || true)
        for mod in $reqs; do
            [[ -z "$mod" ]] && continue
            local mapped; mapped=$(map_python_dep "$mod")
            [[ -n "$mapped" ]] && deps+=("$mapped")
        done
    fi

    [[ ${#deps[@]} -eq 0 ]] && return
    printf '%s\n' "${deps[@]}" | sort -u | xargs
}

scan_python_imports() {
    local src="$1"
    local deps=()

    local pyfiles
    mapfile -t pyfiles < <(find "$src" -maxdepth 3 -name "*.py" 2>/dev/null)
    [[ ${#pyfiles[@]} -eq 0 ]] && return

    local imports
    imports=$(cat "${pyfiles[@]}" 2>/dev/null \
        | sed -n 's/^import  *\([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/p;
                   s/^from  *\([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/p' \
        | sort -u) || true

    for mod in $imports; do
        local mapped; mapped=$(map_python_dep "$mod")
        [[ -n "$mapped" ]] && deps+=("$mapped")
    done

    [[ ${#deps[@]} -eq 0 ]] && return
    printf '%s\n' "${deps[@]}" | sort -u | xargs
}

scan_shell_deps() {
    local src="$1"
    local deps=()
    local shfiles
    mapfile -t shfiles < <(find "$src" -maxdepth 3 -name "*.sh" 2>/dev/null)
    [[ ${#shfiles[@]} -eq 0 ]] && echo "" && return
    local cmds
    cmds=$(cat "${shfiles[@]}" 2>/dev/null \
        | sed -n \
            's/.*command -v  *\([a-zA-Z0-9_-]*\).*/\1/p;
             s/.*which  *\([a-zA-Z0-9_-]*\).*/\1/p;
             s/.*require  *\([a-zA-Z0-9_-]*\).*/\1/p' \
        | grep -v '^$' | sort -u || true)
    for cmd in $cmds; do
        local mapped; mapped=$(map_shell_dep "$cmd")
        [[ -n "$mapped" ]] && deps+=("$mapped")
    done
    [[ ${#deps[@]} -eq 0 ]] && echo "" && return
    printf '%s\n' "${deps[@]}" | sort -u | xargs
}

map_shell_dep() {
    local cmd="$1"
    case "$cmd" in
        bash|sh|echo|printf|read|exit|source|cd|ls|cp|mv|rm|mkdir|cat|\
        grep|sed|awk|cut|tr|sort|uniq|head|tail|find|xargs|test|\
        true|false|export|local|return) return ;;
    esac
    case "$cmd" in
        python3|python)  echo "pkg:python" ;;
        php)             echo "pkg:php" ;;
        ruby)            echo "pkg:ruby" ;;
        perl)            echo "pkg:perl" ;;
        node|nodejs)     echo "pkg:nodejs" ;;
        git)             echo "pkg:git" ;;
        curl)            echo "pkg:curl" ;;
        wget)            echo "pkg:wget" ;;
        nmap)            echo "pkg:nmap" ;;
        ssh|sshd)        echo "pkg:openssh" ;;
        zip)             echo "pkg:zip" ;;
        unzip)           echo "pkg:unzip" ;;
        openssl)         echo "pkg:openssl" ;;
        ffmpeg)          echo "pkg:ffmpeg" ;;
        convert|magick)  echo "pkg:imagemagick" ;;
        jq)              echo "pkg:jq" ;;
        dialog)          echo "pkg:dialog" ;;
        figlet|toilet)   echo "pkg:figlet" ;;
        whiptail)        echo "pkg:newt" ;;
        zenity)          echo "warn:zenity-requires-X11-not-available-in-Termux" ;;
        *)               echo "" ;;
    esac
}

detect_method() {
    local src="$1"
    if   [[ -f "$src/Cargo.toml" ]];     then echo "cargo"
    elif [[ -f "$src/go.mod" ]];          then echo "go"
    elif [[ -f "$src/package.json" ]];    then echo "npm"
    elif [[ -f "$src/CMakeLists.txt" ]];  then echo "cmake"
    elif [[ -f "$src/configure" || -f "$src/configure.ac" ]]; then echo "autotools"
    elif [[ -f "$src/Makefile" || -f "$src/makefile" ]]; then echo "make"
    elif [[ -f "$src/setup.py" || -f "$src/pyproject.toml" ]]; then echo "pip"
    elif ls "$src"/*.py &>/dev/null 2>&1; then echo "python-script"
    elif ls "$src"/*.sh &>/dev/null 2>&1; then echo "shell"
    elif ls "$src"/*.rb &>/dev/null 2>&1; then echo "ruby"
    elif ls "$src"/*.pl &>/dev/null 2>&1; then echo "perl"
    elif ls "$src"/*.lua &>/dev/null 2>&1; then echo "lua"
    elif ls "$src"/*.php &>/dev/null 2>&1; then echo "php"
    elif ls "$src"/*.java &>/dev/null 2>&1; then echo "java"
    elif ls "$src"/*.kt &>/dev/null 2>&1;  then echo "kotlin"
    elif ls "$src"/*.swift &>/dev/null 2>&1; then echo "swift"
    elif ls "$src"/*.c "$src"/*.cpp &>/dev/null 2>&1; then echo "make"
    else echo "unknown"
    fi
}

detect_entrypoint() {
    local src="$1"
    local pkg="$2"

    local f
    f=$(grep -rl '__main__' "$src"/*.py 2>/dev/null | head -n1) \
        && { basename "$f"; return; }
    [[ -f "$src/$pkg.py" ]]      && { echo "$pkg.py"; return; }
    f=$(ls "$src"/*.py 2>/dev/null | grep -vi 'setup\|conf\|config\|test' | head -n1) \
        && { basename "$f"; return; }

    [[ -f "$src/$pkg.sh" ]]      && { echo "$pkg.sh"; return; }
    f=$(ls "$src"/*.sh 2>/dev/null | grep -vi 'setup\|install\|config\|test' | head -n1) \
        && { basename "$f"; return; }

    ls "$src" | head -n1
}

make_install_block() {
    local method="$1"
    local pkg="$2"
    local main="$3"
    local deps_joined="$4"
    local pip_extra="${5:-}"

    local pip_extra_cmd=""
    if [[ -n "$pip_extra" ]]; then
        pip_extra_cmd="    pip install --quiet $pip_extra --break-system-packages 2>/dev/null || true"
    fi

    case "$method" in

    pip)
cat <<BLOCK
TERMUX_PKG_DEPENDS="${deps_joined}"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true
${pip_extra_cmd}
    pip install . --prefix="\$TERMUX_PREFIX" --no-deps --break-system-packages 2>/dev/null \\
        || pip install . --prefix="\$TERMUX_PREFIX" --no-deps --no-build-isolation --break-system-packages || {
            echo "pip failed — falling back to manual install"
            mkdir -p "\$TERMUX_PREFIX/lib/${pkg}"
            cp -r . "\$TERMUX_PREFIX/lib/${pkg}/"
        }
}
BLOCK
    ;;

    python-script)
cat <<BLOCK
TERMUX_PKG_DEPENDS="${deps_joined}"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install --quiet setuptools wheel --break-system-packages 2>/dev/null || true
${pip_extra_cmd}

    local libdir="\$TERMUX_PREFIX/lib/${pkg}"
    mkdir -p "\$libdir"
    cp -r . "\$libdir/"

    cat > "\$TERMUX_PREFIX/bin/${pkg}" <<'WRAPPER'
#!/usr/bin/env bash
cd "\${TERMUX_PREFIX}/lib/${pkg}" || exit 1
exec python3 "\${TERMUX_PREFIX}/lib/${pkg}/${main}" "\$@"
WRAPPER
    sed -i "s|\\\${TERMUX_PREFIX}|/data/data/com.termux/files/usr|g" "\$TERMUX_PREFIX/bin/${pkg}"
    chmod 0755 "\$TERMUX_PREFIX/bin/${pkg}"
}
BLOCK
    ;;

    shell)
cat <<BLOCK
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 "${main}" "\$TERMUX_PREFIX/bin/${pkg}"
}
BLOCK
    ;;

    cmake)
cat <<BLOCK
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=\$TERMUX_PREFIX
"
BLOCK
    ;;

    autotools)
cat <<BLOCK

termux_step_pre_configure() {
    [[ -f configure.ac ]] && autoreconf -fi
}
BLOCK
    ;;

    make)
cat <<BLOCK

termux_step_make() {
    make -j"\$(nproc)" PREFIX="\$TERMUX_PREFIX"
}

termux_step_make_install() {
    make install PREFIX="\$TERMUX_PREFIX"
}
BLOCK
    ;;

    cargo)
cat <<BLOCK
TERMUX_PKG_DEPENDS="rust"

termux_step_make_install() {
    cargo install --locked --path . --root "\$TERMUX_PREFIX"
}
BLOCK
    ;;

    go)
cat <<BLOCK
TERMUX_PKG_DEPENDS="golang"

termux_step_make_install() {
    export GOPATH="\$TERMUX_PKG_BUILDDIR/gopath"
    go build -v -o "\$TERMUX_PREFIX/bin/${pkg}" .
}
BLOCK
    ;;

    npm)
cat <<BLOCK
TERMUX_PKG_DEPENDS="nodejs"

termux_step_make_install() {
    npm install --prefix "\$TERMUX_PREFIX" -g "\$TERMUX_PKG_SRCDIR"
}
BLOCK
    ;;

    ruby)
cat <<BLOCK
TERMUX_PKG_DEPENDS="ruby"

termux_step_make_install() {
    [[ -f *.gemspec ]] \\
        && gem build *.gemspec && gem install --local *.gem --no-document \\
        || { mkdir -p "\$TERMUX_PREFIX/lib/${pkg}"; cp -r . "\$TERMUX_PREFIX/lib/${pkg}/"; }
}
BLOCK
    ;;

    perl)
cat <<BLOCK
TERMUX_PKG_DEPENDS="perl"

termux_step_make_install() {
    perl Makefile.PL PREFIX="\$TERMUX_PREFIX" && make && make install
}
BLOCK
    ;;

    lua)
cat <<BLOCK
TERMUX_PKG_DEPENDS="lua54"

termux_step_make_install() {
    install -Dm755 "${main}" "\$TERMUX_PREFIX/bin/${pkg}"
}
BLOCK
    ;;

    php)
cat <<BLOCK
TERMUX_PKG_DEPENDS="php"

termux_step_make_install() {
    mkdir -p "\$TERMUX_PREFIX/lib/${pkg}"
    cp -r . "\$TERMUX_PREFIX/lib/${pkg}/"
    cat > "\$TERMUX_PREFIX/bin/${pkg}" <<'WRAPPER'
#!/usr/bin/env bash
exec php "\${PREFIX}/lib/${pkg}/${main}" "\$@"
WRAPPER
    chmod 0755 "\$TERMUX_PREFIX/bin/${pkg}"
}
BLOCK
    ;;

    *)
cat <<BLOCK

termux_step_make_install() {
    echo "⚠️ Unknown build system — edit this function manually"
    mkdir -p "\$TERMUX_PREFIX/lib/${pkg}"
    cp -r . "\$TERMUX_PREFIX/lib/${pkg}/"
}
BLOCK
    ;;
    esac
}

github_api() {
    local url="$1"
    local result
    result=$(curl -sf \
        -H "Accept: application/vnd.github+json" \
        ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
        "$url" 2>/dev/null) || true

    case "$result" in
        *rate\ limit*|*API\ rate\ limit*)
            warn "GitHub API rate limited — set GITHUB_TOKEN env var for higher limits"
            echo "" ;;
        *)
            echo "$result" ;;
    esac
}

json_field() {
    local json="$1" field="$2"
    echo "$json" | sed -n "s/.*\"${field}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n1
}

banner

REPO_URL="${1:-}"

step "Input"

if [[ -z "$REPO_URL" ]]; then
    read -rp "  GitHub repo URL (or package name): " REPO_URL
fi

PKG_NAME=$(sanitize_pkgname "$(basename "$REPO_URL")")
info "Package name: ${W}${PKG_NAME}${N}"

PKG_DIR="$PACKAGES_DIR/$PKG_NAME"
mkdir -p "$PKG_DIR"

HOMEPAGE="${REPO_URL:-https://example.com}"
DESCRIPTION="$PKG_NAME — auto-packaged by termux-build-init"
LICENSE="UNKNOWN"
VERSION="1.0.0"
SRCURL=""
SHA256="SKIP"
LANGUAGE="Unknown"
INSTALL_METHOD="unknown"
DEPENDS_RAW=""
MAIN_FILE=""

if [[ "$REPO_URL" == *"github.com"* ]]; then
    step "Fetching GitHub metadata"

    API_BASE=$(echo "$REPO_URL" \
        | sed 's#https://github.com/#https://api.github.com/repos/#' \
        | sed 's#\.git$##')

    DATA=$(github_api "$API_BASE")

    if [[ -n "$DATA" ]]; then
        DESCRIPTION=$(json_field "$DATA" "description")
        [[ -z "$DESCRIPTION" || "$DESCRIPTION" == "null" ]] && DESCRIPTION="$PKG_NAME — auto-packaged by termux-build-init"
        LICENSE=$(json_field "$DATA" "spdx_id"); LICENSE="${LICENSE:-UNKNOWN}"
        LANGUAGE=$(json_field "$DATA" "language"); LANGUAGE="${LANGUAGE:-Unknown}"
        HOMEPAGE=$(json_field "$DATA" "homepage"); HOMEPAGE="${HOMEPAGE:-$REPO_URL}"
        [[ -z "$HOMEPAGE" || "$HOMEPAGE" == "null" ]] && HOMEPAGE="$REPO_URL"
        ok "Repo: ${W}${DESCRIPTION}${N}"
    fi

    RELEASE=$(github_api "$API_BASE/releases/latest")
    TAG=$(json_field "$RELEASE" "tag_name") || true

    if [[ -n "$TAG" ]]; then
        VERSION="${TAG#v}"
        SRCURL="$REPO_URL/archive/refs/tags/$TAG.tar.gz"
        ok "Source: release ${W}${TAG}${N}"
    else
        DEFAULT_BRANCH=$(json_field "$DATA" "default_branch")

        if [[ -z "$DEFAULT_BRANCH" || "$DEFAULT_BRANCH" == "null" ]]; then
            warn "Could not detect default branch from API — probing common branch names..."
            for _branch in master main trunk dev; do
                _probe_url="$REPO_URL/archive/refs/heads/$_branch.tar.gz"
                if curl -sf --head "$_probe_url" -o /dev/null 2>/dev/null; then
                    DEFAULT_BRANCH="$_branch"
                    break
                fi
            done
            [[ -z "$DEFAULT_BRANCH" ]] && DEFAULT_BRANCH="main"
        fi

        VERSION="1.0.0"
        SRCURL="$REPO_URL/archive/refs/heads/$DEFAULT_BRANCH.tar.gz"
        warn "No release found — using branch ${W}${DEFAULT_BRANCH}${N}"
    fi
fi

step "Downloading & analyzing source"
info "URL: $SRCURL"

if ! curl -sf --head "$SRCURL" -o /dev/null 2>/dev/null; then
    fail "Source URL is not accessible: $SRCURL"$'\n'"       Cek nama branch atau pastikan repo tidak private."
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

TMPTAR="$TMP/src.tar.gz"
if ! curl -fL "$SRCURL" -o "$TMPTAR" --progress-bar; then
    fail "Failed to download source"
fi
ok "Download complete"

tar -xf "$TMPTAR" -C "$TMP"
SRC=$(find "$TMP" -mindepth 1 -maxdepth 1 -type d | head -n1)
[[ -z "$SRC" ]] && fail "Could not extract source directory"
info "Source root: ${W}$(basename "$SRC")${N}"

echo ""
echo "  📂 Files in source:"
ls "$SRC" | sed 's/^/     /'
echo ""

step "Auto-detection"

INSTALL_METHOD=$(detect_method "$SRC")
ok "Build method : ${W}${INSTALL_METHOD}${N}"

MAIN_FILE=$(detect_entrypoint "$SRC" "$PKG_NAME")
ok "Entrypoint   : ${W}${MAIN_FILE}${N}"

step "Dependency scan"

DEPS_DECLARED=""
DEPS_IMPORTS=""

DEPS_SHELL_WARNS=""
DEPS_SHELL_PKGS=""

if [[ "$INSTALL_METHOD" == "pip" || "$INSTALL_METHOD" == "python-script" ]]; then
    DEPS_DECLARED=$(scan_python_declared_deps "$SRC" || true)
    DEPS_IMPORTS=$(scan_python_imports "$SRC" || true)
    info "Declared deps : ${DEPS_DECLARED:-none}"
    info "Import deps   : ${DEPS_IMPORTS:-none}"
fi

DEPS_SHELL_RAW=$(scan_shell_deps "$SRC" || true)
if [[ -n "$DEPS_SHELL_RAW" ]]; then
    DEPS_SHELL_WARNS=$(printf '%s
' $DEPS_SHELL_RAW | grep '^warn:' | sed 's/^warn://' | xargs || true)
    DEPS_SHELL_PKGS=$(printf '%s
' $DEPS_SHELL_RAW | grep '^pkg:' | xargs || true)
    [[ -n "$DEPS_SHELL_WARNS" ]] && warn "Incompatible  : ${R}${DEPS_SHELL_WARNS}${N}"
    [[ -n "$DEPS_SHELL_PKGS"  ]] && info "Shell deps    : ${DEPS_SHELL_PKGS}"
fi

case "$INSTALL_METHOD" in
    pip|python-script)
        ALL_DEPS="$DEPS_DECLARED $DEPS_IMPORTS ${DEPS_SHELL_PKGS:-}"
        PKG_ONLY_DEPS=$(pkg_deps "pkg:python pkg:python-pip pkg:python-setuptools $ALL_DEPS")
        PIP_ONLY_DEPS=$(pip_deps "$ALL_DEPS") ;;
    cargo)      ALL_DEPS="rust" ;;
    go)         ALL_DEPS="golang" ;;
    npm)        ALL_DEPS="nodejs" ;;
    cmake)      ALL_DEPS="libandroid-support" ;;
    ruby)       ALL_DEPS="ruby" ;;
    perl)       ALL_DEPS="perl" ;;
    lua)        ALL_DEPS="lua54" ;;
    php)        ALL_DEPS="php" ;;
    shell|make|autotools|unknown) ALL_DEPS="${DEPS_SHELL_PKGS:-}" ;;
    *)          ALL_DEPS="" ;;
esac

if [[ "$INSTALL_METHOD" != "pip" && "$INSTALL_METHOD" != "python-script" ]]; then
    PKG_ONLY_DEPS="${ALL_DEPS:-}"
    PIP_ONLY_DEPS=""
fi

if [[ -n "${PKG_ONLY_DEPS:-}" ]]; then
    DEPENDS_JOINED=$(join_deps "$PKG_ONLY_DEPS")
else
    DEPENDS_JOINED=""
fi
ok "pkg deps : ${W}${DEPENDS_JOINED:-none}${N}"
ok "pip deps : ${W}${PIP_ONLY_DEPS:-none}${N}"

step "Checksum"

read -rp "  Compute SHA256 automatically? [Y/n]: " _SHA
_SHA="${_SHA:-Y}"
if [[ ! "$_SHA" =~ ^[Nn]$ ]]; then
    SHA256=$(sha256sum "$TMPTAR" | awk '{print $1}')
    ok "SHA256: ${W}${SHA256}${N}"
else
    SHA256="SKIP"
    warn "SHA256 set to SKIP — verification disabled"
fi

echo ""
echo -e "${W}════════════════════════════════════════════${N}"
echo -e "${W}  Smart Detection Result                    ${N}"
echo -e "${W}════════════════════════════════════════════${N}"
printf "${W}${N}  %-12s : %-28s ${W}${N}\n" "Package"    "$PKG_NAME"
printf "${W}${N}  %-12s : %-28s ${W}${N}\n" "Language"   "$LANGUAGE"
printf "${W}${N}  %-12s : %-28s ${W}${N}\n" "Method"     "$INSTALL_METHOD"
printf "${W}${N}  %-12s : %-28s ${W}${N}\n" "Version"    "$VERSION"
printf "${W}${N}  %-12s : %-28s ${W}${N}\n" "License"    "$LICENSE"
printf "${W}${N}  %-12s : %-28s ${W}${N}\n" "Entrypoint" "$MAIN_FILE"
echo -e "${W}════════════════════════════════════════════${N}"
echo -e "${W}${N}  Depends: ${C}${DEPENDS_JOINED:-none}${N}"
[[ -n "${DEPS_SHELL_WARNS:-}" ]] && echo -e "${R}  ⚠ Incompatible: ${DEPS_SHELL_WARNS}${N}"
echo -e "${W}════════════════════════════════════════════${N}"
echo ""

read -rp "  Continue? [Y/n]: " _CONT
[[ "${_CONT:-Y}" =~ ^[Nn]$ ]] && exit 0

step "Writing build.sh"

INSTALL_BLOCK=$(make_install_block "$INSTALL_METHOD" "$PKG_NAME" "$MAIN_FILE" "$DEPENDS_JOINED" "${PIP_ONLY_DEPS:-}")

{
    printf 'TERMUX_PKG_HOMEPAGE=%s\n'          "$HOMEPAGE"
    printf 'TERMUX_PKG_DESCRIPTION="%s"\n'     "$DESCRIPTION"
    printf 'TERMUX_PKG_LICENSE="%s"\n'         "$LICENSE"
    printf 'TERMUX_PKG_MAINTAINER="@termux-app-store"\n'
    printf 'TERMUX_PKG_VERSION=%s\n'           "$VERSION"
    printf 'TERMUX_PKG_SRCURL=%s\n'            "$SRCURL"
    printf 'TERMUX_PKG_SHA256=%s\n'            "$SHA256"
    printf '\n'
    printf '%s\n'                              "$INSTALL_BLOCK"
} > "$PKG_DIR/build.sh"

chmod +x "$PKG_DIR/build.sh"
ok "Saved: ${W}${PKG_DIR}/build.sh${N}"

echo ""
echo -e "${C}--- build.sh preview ---${N}"
cat "$PKG_DIR/build.sh"
echo -e "${C}------------------------${N}"

if [[ -f "$BUILD_SCRIPT" ]]; then
    echo ""
    read -rp "  Run test build now? [y/N]: " _TEST
    if [[ "${_TEST:-N}" =~ ^[Yy]$ ]]; then
        step "Test Build"
        bash "$BUILD_SCRIPT" "$PKG_NAME" || warn "Build finished with errors (see above)"
    fi
else
    warn "build-package.sh not found — skipping test build"
fi

echo ""
echo -e "${G}══════════════════════════════${N}"
echo -e "${G} ✅  Package ready!           ${N}"
echo -e "${G} 📦  packages/${PKG_NAME}     ${N}"
echo -e "${G}══════════════════════════════${N}"
echo ""
