# Create a new directory and enter it
mkdir_and_cd() {
    mkdir -p "$1" && cd "$1"
}

# Determine size of a file or total size of a directory
fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

# System update - update dnf packages, flatpaks, gems, npm, and nvim plugins
system_update() {
    echo "Updating system packages..."
    sudo dnf upgrade --refresh -y

    echo "Updating Flatpak apps..."
    flatpak update -y

    if command -v gem &> /dev/null; then
        echo "Updating Ruby gems..."
        gem update --system
        gem update
    fi

    if command -v npm &> /dev/null; then
        echo "Updating npm..."
        npm install npm -g
        npm update -g
    fi

    if command -v nvim &> /dev/null; then
        echo "Updating Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa
    fi
}

# Download a file to /tmp and return its path
tmpget() {
    local filename
    filename=$(basename "$1")
    local path="/tmp/$filename"
    curl -fsSL "$1" -o "$path" && echo "$path"
}

# Extract most archive types
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.tar.xz)   tar xJf "$1"    ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.rar)      unrar x "$1"    ;;
            *.gz)       gunzip "$1"     ;;
            *.tar)      tar xf "$1"     ;;
            *.tbz2)     tar xjf "$1"    ;;
            *.tgz)      tar xzf "$1"    ;;
            *.zip)      unzip "$1"      ;;
            *.Z)        uncompress "$1" ;;
            *.7z)       7z x "$1"       ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a .tar.gz archive
targz() {
    local tmpFile="${1%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1
    gzip -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"
}

# Open file manager in current directory
fm() {
    if command -v dolphin &> /dev/null; then
        dolphin . &
    elif command -v nautilus &> /dev/null; then
        nautilus . &
    fi
}

# Prepend path entry if directory exists
prepend_path() {
    [ -d "$1" ] && export PATH="$1:$PATH"
}

# Append path entry if directory exists
append_path() {
    [ -d "$1" ] && export PATH="$PATH:$1"
}
