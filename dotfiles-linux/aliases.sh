# Easier Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"

# Directory listing
alias ls="ls --color=auto"
alias l="ls -la"
alias la="ls -laF"
alias lsdir="ls -lF | grep --color=never '^d'"
alias ll="ls -alF"
alias lsd="ls -ltr"
# Gzip-enabled curl
alias gurl="curl --compressed"

# Navigation shortcuts
alias docs="cd ~/Documents && lsd"
alias dl="cd ~/Downloads && lsd "
alias dp="cd ~/snappcar && lsd"
alias dt="cd ~/snappcar/dotnet"


# Create a new directory and enter it
alias mkd="mkdir_and_cd"

# Disk usage
alias fs="du -sh"

# Reload the shell
alias reload="exec $SHELL -l"

# Update system packages
alias update="system_update"

# Set NeoVim as default vim
alias vim="nvim"
alias vi="nvim"

# Convenience
alias hosts="sudo $EDITOR /etc/hosts"
alias profile="$EDITOR ~/.zshrc"

# Safety nets
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Reload shell
alias ss="source ~/.zshrc"

# Clipboard
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

# VPN (OpenVPN)
alias vpnup="sudo systemctl start openvpn-client@snappcar"
alias vpndown="sudo systemctl stop openvpn-client@snappcar"

# WireGuard
alias wup="sudo wg-quick up wg0"
alias wdown="sudo wg-quick down wg0"
alias wstatus="sudo wg show"
