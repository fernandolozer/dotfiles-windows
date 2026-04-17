#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlink helper: backup existing file, then symlink
link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up existing $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo "Linked: $dest -> $src"
}

### Home dotfiles
echo "Linking home dotfiles..."
link "$DOTFILES_DIR/home/.gitconfig"              "$HOME/.gitconfig"
link "$DOTFILES_DIR/home/.gitignore"              "$HOME/.gitignore"
link "$DOTFILES_DIR/home/.gitattributes"          "$HOME/.gitattributes"
link "$DOTFILES_DIR/home/.npmrc"                  "$HOME/.npmrc"
link "$DOTFILES_DIR/home/.gemrc"                  "$HOME/.gemrc"

### Espanso
echo 'Linking espanso base file'
link "$DOTFILES_DIR/espanso/base.yml"                  "$HOME/.config/espanso/match/base.yml"

### fastfetch
echo "Linking fastfetch config..."
mkdir -p "$HOME/.config/fastfetch"
link "$DOTFILES_DIR/home/fastfetch.config.jsonc"  "$HOME/.config/fastfetch/config.jsonc"

### Neovim
echo "Linking Neovim config..."
mkdir -p "$HOME/.config/nvim/lua/config"
link "$DOTFILES_DIR/nvim/init.lua"                "$HOME/.config/nvim/init.lua"
link "$DOTFILES_DIR/nvim/lua/config/lazy.lua"     "$HOME/.config/nvim/lua/config/lazy.lua"

### Yazi
echo "Linking Yazi config..."
mkdir -p "$HOME/.config/yazi"
link "$DOTFILES_DIR/yazi/yazi.toml"               "$HOME/.config/yazi/yazi.toml"
link "$DOTFILES_DIR/yazi/theme.toml"              "$HOME/.config/yazi/theme.toml"

### Zsh
echo "Setting up zsh..."
if ! command -v zsh &>/dev/null; then
    sudo dnf install -y zsh
fi
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell set to zsh — log out and back in for it to take effect"
else
    echo "zsh already the default shell"
fi

### Zsh profile
echo "Linking zsh profile..."
# Append a source line to .zshrc if not already present
ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source \"$DOTFILES_DIR/zshrc.zsh\""

touch "$ZSHRC"
if ! grep -qF "$SOURCE_LINE" "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# dotfiles-linux" >> "$ZSHRC"
    echo "$SOURCE_LINE" >> "$ZSHRC"
    echo "Added source line to $ZSHRC"
else
    echo "Source line already present in $ZSHRC"
fi

echo ""
echo "Bootstrap complete."
