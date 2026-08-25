#!/usr/bin/env bash
# ============================================================
#  stow-packages.sh - Symlink Creation via GNU Stow
#  Creates symlinks for all dotfiles packages
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors (if not already defined)
if [ -z "${RED:-}" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Stow a single package with conflict handling
stow_package() {
    local pkg="$1"
    local target="${2:-$HOME}"

    info "Stowing: $pkg → $target"

    # Try stow normally first
    if stow -v "$pkg" -d "$DOTFILES_DIR" -t "$target" 2>/dev/null; then
        ok "Symlinks created for: $pkg"
        return 0
    fi

    # If conflict, try with --adopt (moves existing files into repo)
    warn "Conflict detected for $pkg, attempting --adopt..."
    if stow --adopt -v "$pkg" -d "$DOTFILES_DIR" -t "$target" 2>/dev/null; then
        ok "Symlinks created for: $pkg (adopted existing files)"
        return 0
    fi

    error "Failed to stow: $pkg"
    return 1
}

# 7.2 Stow bash package → ~/
stow_package "bash" "$HOME"

# 7.3 Stow nvim package → ~/.config/nvim
mkdir -p "$HOME/.config"
stow_package "nvim" "$HOME/.config"

# 7.4 Stow starship, ranger, fastfetch → ~/.config/
stow_package "starship" "$HOME/.config"
stow_package "ranger" "$HOME/.config"
stow_package "fastfetch" "$HOME/.config"

# 7.5 Stow git package → ~/
stow_package "git" "$HOME"

# 7.6 Stow personal package → ~/.personal/
mkdir -p "$HOME/.personal"
stow_package "personal" "$HOME/.personal"

# 7.8 Copy script_fast.sh to /usr/local/bin
info "Installing script_fast.sh..."
if [ -f "${DOTFILES_DIR}/scripts-personal/script_fast.sh" ]; then
    sudo cp "${DOTFILES_DIR}/scripts-personal/script_fast.sh" /usr/local/bin/script_fast.sh
    sudo chmod +x /usr/local/bin/script_fast.sh
    ok "script_fast.sh installed to /usr/local/bin/"
else
    warn "script_fast.sh not found in scripts-personal/"
fi

echo ""
ok "All stow operations complete"
