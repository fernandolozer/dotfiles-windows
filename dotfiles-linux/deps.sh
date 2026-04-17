#!/usr/bin/env bash
set -uo pipefail

# Must be run as a regular user (sudo will be called where needed)
if [ "$EUID" -eq 0 ]; then
    echo "Run this script as your normal user, not root."
    exit 1
fi

# ── Helpers ──────────────────────────────────────────────────────────────────

FAILED_STEPS=()

# Run a command. On failure: print a warning and record it, but keep going.
try() {
    local label="$1"; shift
    echo "  → $label"
    if "$@"; then
        return 0
    else
        echo "  ✗ FAILED: $label"
        FAILED_STEPS+=("$label")
        return 0  # intentionally don't propagate — caller decides if fatal
    fi
}

section() { echo; echo "──── $1 ────"; }

# Like try(), but skips entirely if the given command is already on PATH.
try_if_missing() {
    local label="$1" cmd="$2"; shift 2
    if command -v "$cmd" &>/dev/null; then
        echo "  → $label already installed, skipping"
        return 0
    fi
    try "$label" "$@"
}

# Install an RPM from the latest GitHub release matching a filename pattern
install_github_rpm() {
    local repo="$1"
    local pattern="$2"
    local url
    url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" \
        | grep '"browser_download_url"' \
        | grep "$pattern" \
        | head -1 \
        | cut -d'"' -f4)
    if [ -z "$url" ]; then
        echo "  ✗ Could not find a release for $repo matching '$pattern'" >&2
        return 1
    fi
    sudo dnf install -y "$url"
}

# ── System upgrade ────────────────────────────────────────────────────────────

section "System upgrade"
# Hard dependency — if this fails something is seriously wrong
sudo dnf upgrade --refresh -y

# ── Repos ─────────────────────────────────────────────────────────────────────

section "Repos"

# RPM Fusion free and nonfree are split so a timeout on one doesn't block the other
try "RPM Fusion free" \
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

try "RPM Fusion nonfree" \
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

try "Brave Browser repo" \
    sudo dnf config-manager addrepo \
        --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

try "Joplin COPR" \
    sudo dnf copr enable -y taw/joplin

# ── DNF packages ──────────────────────────────────────────────────────────────

section "DNF packages"

# Core CLI tools — install as a group; if this fails something is very wrong
# Add extra repository
sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

sudo dnf install -y \
    curl \
    git \
    git-credential-libsecret \
    zsh \
    neovim \
    fastfetch \
    yazi \
    gh \
    ffmpeg \
    p7zip \
    p7zip-plugins \
    unrar \
    xclip \
    btop \
    ruby \
    ruby-devel \
    gcc \
    make \
    nodejs \
    npm \
    flatpak

# GUI apps — each optional; a missing repo from above won't break these others
for pkg in brave-browser celluloid bottles flatseal joplin; do
    try "$pkg" sudo dnf install -y "$pkg"
done

sudo dnf install -y espanso-wayland
espanso service register
espanso start

# ── Direct RPM downloads ──────────────────────────────────────────────────────

section "Direct RPM installs"

try_if_missing "Obsidian" obsidian \
    install_github_rpm "obsidianmd/obsidian-releases" "x86_64.rpm"

# Slack — follow their download redirect to get the latest RPM URL
if command -v slack &>/dev/null; then
    echo "  → Slack already installed, skipping"
else
    echo "  → Slack"
    SLACK_URL=$(curl -sI "https://slack.com/ssb/download-linux-x64-rpm" \
        | grep -i "^location:" | tr -d '\r' | awk '{print $2}')
    if [ -n "$SLACK_URL" ]; then
        try "Slack" sudo dnf install -y "$SLACK_URL"
    else
        echo "  ✗ FAILED: Slack (could not resolve download URL)"
        FAILED_STEPS+=("Slack — install manually from https://slack.com/downloads/linux")
    fi
fi

# ── Flatpak (LocalSend only) ──────────────────────────────────────────────────

section "Flatpak"

try "Flathub remote" \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

try "LocalSend" \
    flatpak install -y flathub io.github.localsend.localsend_app

# ── oh-my-zsh + Powerlevel10k ─────────────────────────────────────────────────

section "oh-my-zsh + Powerlevel10k"

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  → oh-my-zsh already installed, skipping"
else
    try "oh-my-zsh install" \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    echo "  → powerlevel10k already installed, skipping"
else
    try "powerlevel10k clone" \
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ── nvm + Node ────────────────────────────────────────────────────────────────
section "nvm + Node"

try_if_missing "nvm install" nvm \
    bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command -v nvm &>/dev/null; then
    try "Node LTS" nvm install --lts
    try "nvm use lts" nvm use --lts
    try "npm update" npm install -g npm
else
    echo "  ✗ nvm not available in current shell — run 'nvm install --lts' after restarting"
    FAILED_STEPS+=("Node LTS — run manually: nvm install --lts")
fi

# ── Ruby gems ─────────────────────────────────────────────────────────────────

section "Ruby gems"
try "gem update" gem update --system

# ── Yazi ─────────────────────────────────────────────────────────────────────

section "Yazi"
try "Yazi Dracula flavor" ya pkg add --force yazi-rs/flavors:dracula

# ── SSH key ───────────────────────────────────────────────────────────────────

section "SSH key"

if ls ~/.ssh/id_*.pub &>/dev/null 2>&1; then
    echo "  → SSH key already exists, skipping."
else
    echo "  → No SSH key found. Generating ed25519 key..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    ssh-keygen -t ed25519 \
        -C "$(git config user.email 2>/dev/null || hostname)" \
        -f ~/.ssh/id_ed25519 \
        -N ""
    chmod 600 ~/.ssh/id_ed25519
    echo "  ✓ SSH key generated: ~/.ssh/id_ed25519"
    echo "  Public key:"
    cat ~/.ssh/id_ed25519.pub
fi

# ── Default shell ─────────────────────────────────────────────────────────────

section "Default shell"
try "Set zsh as default shell" chsh -s "$(which zsh)"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "════════════════════════════════════"
if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
    echo "All steps completed successfully."
else
    echo "Done with ${#FAILED_STEPS[@]} failure(s):"
    for step in "${FAILED_STEPS[@]}"; do
        echo "  • $step"
    done
fi
echo ""
echo "Log out and back in for the shell change to take effect."
echo "Then run ./bootstrap.sh to link config files."
