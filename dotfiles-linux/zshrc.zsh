# Main zsh profile
# Sources all component files in order

# Enable Powerlevel10k instant prompt. Must stay near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DOTFILES_DIR="${0:A:h}"

# Load exports first so PATH and env vars are set
source "$DOTFILES_DIR/exports.sh"

# oh-my-zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

source "$ZSH/oh-my-zsh.sh"

# Load shell functions
source "$DOTFILES_DIR/functions.sh"

# Load aliases
source "$DOTFILES_DIR/aliases.sh"

# Load component modules
source "$DOTFILES_DIR/components/git.sh"

# Case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit && compinit

# Bracketed paste (safe paste - avoids executing pasted newlines immediately)
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Load extra user-specific config if it exists (not tracked in git)
[ -f "$HOME/.extra" ] && source "$HOME/.extra"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey "^[[1;5C" forward-word   # Ctrl+Right
bindkey "^[[1;5D" backward-word  # Ctrl+Left
