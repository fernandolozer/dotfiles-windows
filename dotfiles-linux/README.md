# dotfiles-linux

Dotfiles and setup scripts for Fedora KDE. Mirrors the organization of `../dotfiles-windows`.

## Structure

```
dotfiles-linux/
├── bootstrap.sh        # Symlinks configs to their correct system locations
├── deps.sh             # Installs all packages and tools
├── exports.sh          # Environment variables (sourced by zshrc.zsh)
├── aliases.sh          # Shell aliases (sourced by zshrc.zsh)
├── functions.sh        # Shell functions (sourced by zshrc.zsh)
├── zshrc.zsh           # Main zsh entry point — sources everything above
├── components/
│   └── git.sh          # Git prompt/completion helpers
├── home/               # Dotfiles symlinked into $HOME
│   ├── .gitconfig
│   ├── .gitignore
│   ├── .gitattributes
│   ├── .npmrc
│   ├── .gemrc
│   └── fastfetch.config.jsonc
├── nvim/               # Neovim config → ~/.config/nvim
└── yazi/               # Yazi config → ~/.config/yazi
```

## First-time setup

### Step 1 — Install dependencies

```bash
./deps.sh
```

**Run as your normal user, not root.** The script calls `sudo` internally where elevation is needed (dnf, flatpak, chsh). Running it as root would install tools into `/root` instead of your home directory and change root's shell instead of yours.

This script:
- Enables RPM Fusion (free + nonfree) for additional packages
- Adds the official Brave Browser dnf repo
- Enables the Joplin community COPR
- Installs CLI tools and GUI apps via `dnf`: `git`, `neovim`, `fastfetch`, `yazi`, `gh`, `zsh`, `btop`, `firefox`, `brave-browser`, `celluloid`, `bottles`, `flatseal`, `joplin`, etc.
- Installs GitKraken and Obsidian via direct RPM download
- Attempts to install Slack via their RPM download (prints manual instructions if it fails)
- Installs LocalSend via Flatpak (only app with no stable RPM path)
- Installs `oh-my-posh` and the MesloLGM Nerd Font
- Installs `nvm` and the latest Node LTS
- Installs the Yazi Dracula flavor
- Checks for an existing SSH key in `~/.ssh` — generates one if none is found
- Sets `zsh` as your default shell

Log out and back in after this step so the shell change takes effect.

### Step 2 — Link config files

```bash
./bootstrap.sh
```

Run as your normal user. This symlinks all configs to their correct locations:

| Config | Destination |
|---|---|
| `home/.*` | `~/.gitconfig`, `~/.gitignore`, etc. |
| `home/fastfetch.config.jsonc` | `~/.config/fastfetch/config.jsonc` |
| `nvim/` | `~/.config/nvim/` |
| `yazi/` | `~/.config/yazi/` |
| `zshrc.zsh` | sourced from `~/.zshrc` |

Any existing files that would be overwritten are backed up with a `.bak` extension first.

## After setup

Open a new terminal. Your zsh prompt will load `oh-my-posh`. If the font looks broken, set the terminal font to **MesloLGM Nerd Font** in your terminal's settings.

To update everything at once:

```bash
update
```

This runs `dnf upgrade`, `flatpak update`, gem/npm updates, and syncs Neovim plugins.
