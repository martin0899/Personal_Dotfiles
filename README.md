# Dotfiles

Personal dotfiles repository with automated installation for Fedora, Debian/Ubuntu, and WSL2.

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's Included

| Package | Contents | Target |
|---------|----------|--------|
| `bash/` | `.bashrc`, `.bash_profile` | `~/` |
| `nvim/` | Neovim config with lazy.nvim | `~/.config/nvim/` |
| `starship/` | Starship prompt config | `~/.config/` |
| `ranger/` | Ranger file manager config | `~/.config/ranger/` |
| `fastfetch/` | Fastfetch configs (3 themes) | `~/.config/fastfetch/` |
| `git/` | Git config (no credentials) | `~/` |
| `personal/` | Aliases and personal scripts | `~/.personal/` |

## Installation

The `install.sh` script will:

1. **Detect environment** - Fedora, Debian/Ubuntu, or WSL
2. **Backup existing configs** - Saved to `~/.dotfiles-backup/<timestamp>/`
3. **Install CLI tools** - fzf, bat, eza, zoxide, starship, lazygit, ranger, thefuck, duf, neovim, fastfetch, tty-clock, scrcpy, podman (best effort per distro; ncspot and tldr are skipped on Ubuntu since apt doesn't package them)
4. **Create symlinks** - Via GNU Stow

### Prerequisites

- `git` (installed automatically if missing)
- `stow` (installed automatically if missing)
- `sudo` access for package installation

## Uninstallation

```bash
./uninstall.sh
```

The uninstall script will:
- Remove all stow symlinks
- Offer to restore the most recent backup
- Remove `/usr/local/bin/script_fast.sh`
- Show instructions for manual tool removal

## WSL Support

When running on WSL2, the installer automatically:
- Installs `win32yank` for clipboard integration
- Adds WSL-specific aliases (`explorer`, `code`)
- Skips snap-based tools and tools not available via apt (ncspot, tldr)

## Structure

```
dotfiles/
├── install.sh              # Main installation script
├── uninstall.sh            # Uninstallation script
├── scripts/
│   ├── detect-distro.sh    # Distribution detection
│   ├── install-prerequisites.sh
│   ├── install-tools.sh    # CLI tools installation
│   ├── backup.sh           # Config backup
│   └── stow-packages.sh    # Symlink creation
├── bash/                   # Bash configuration
├── nvim/                   # Neovim configuration
├── starship/               # Starship prompt
├── ranger/                 # Ranger file manager
├── fastfetch/              # Fastfetch configs
├── git/                    # Git configuration
├── personal/               # Personal aliases/scripts
└── scripts-personal/       # System scripts
```

## Customization

### Adding New Tools

1. Add installation logic to `scripts/install-tools.sh`
2. Create a new stow package directory
3. Add stow command to `scripts/stow-packages.sh`

### Modifying Bash Config

Edit `bash/.bashrc` directly. Changes will be symlinked to `~/.bashrc` on next install.

## Troubleshooting

### Stow Conflicts

Before stowing, the installer **moves** any existing conflicting configs to `~/.dotfiles-backup/<timestamp>/` so stow never needs to overwrite or adopt files. Packages that go into `~/.config/<name>/` (`nvim`, `ranger`, `fastfetch`) must contain a `<name>/` subdirectory; the installer validates this and refuses to stow otherwise, so files never get scattered in `~/.config/`. If stow still reports a conflict, remove the offending file manually and re-run `./install.sh`.

### Backup Restoration

Backups are stored in `~/.dotfiles-backup/`. To manually restore:

```bash
cp ~/.dotfiles-backup/<timestamp>/.bashrc ~/.bashrc
```

### WSL Clipboard Issues

If clipboard doesn't work in WSL, ensure `win32yank.exe` is in `/usr/local/bin/`:

```bash
which win32yank.exe
```
