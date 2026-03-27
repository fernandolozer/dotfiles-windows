# Git prompt integration
# Loads git branch info if not already provided by the prompt theme (e.g., oh-my-posh)

if command -v git &> /dev/null; then
    # Source git completion if available
    if [ -f /usr/share/zsh/site-functions/_git ]; then
        autoload -Uz compinit && compinit
    fi

    # Helper: print current branch name
    git_branch() {
        git symbolic-ref --short HEAD 2>/dev/null
    }

    # Helper: print short repo status for use in custom prompts
    git_status_symbol() {
        local status
        status=$(git status --porcelain 2>/dev/null)
        if [ -n "$status" ]; then
            echo "*"
        fi
    }
fi
