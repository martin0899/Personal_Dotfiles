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

declare -a STOW_FAILED=()

# Packages stowed into ~/.config/<name>/ must contain a <name>/ subdirectory.
# Without this check their files would be scattered directly in ~/.config/.
validate_config_package() {
    local pkg="$1"
    if [ ! -d "${DOTFILES_DIR}/${pkg}/${pkg}" ]; then
        error "Invalid structure for '${pkg}': missing ${pkg}/${pkg}/ inside the package"
        error "Refusing to stow to avoid scattering files in ~/.config/"
        STOW_FAILED+=("$pkg (bad structure)")
        return 1
    fi
}

# Stow a single package. Never uses --adopt: existing files were already
# moved to the backup by backup.sh, so a conflict here is a real problem.
stow_package() {
    local pkg="$1"
    local target="${2:-$HOME}"

    info "Stowing: $pkg → $target"

    if stow -v "$pkg" -d "$DOTFILES_DIR" -t "$target" 2>/dev/null; then
        ok "Symlinks created for: $pkg"
        return 0
    fi

    error "Failed to stow: $pkg (conflicting files in $target)"
    error "Originals should be in ~/.dotfiles-backup/ - resolve and re-run install.sh"
    STOW_FAILED+=("$pkg")
    return 0
}

# Stow bash package → ~/
stow_package "bash" "$HOME"

# Stow config packages → ~/.config/
mkdir -p "$HOME/.config"
if validate_config_package "nvim"; then
    stow_package "nvim" "$HOME/.config"
fi
stow_package "starship" "$HOME/.config"
if validate_config_package "ranger"; then
    stow_package "ranger" "$HOME/.config"
fi
if validate_config_package "fastfetch"; then
    stow_package "fastfetch" "$HOME/.config"
fi

# Stow git package → ~/
stow_package "git" "$HOME"

# Stow personal package → ~/.personal/
mkdir -p "$HOME/.personal"
stow_package "personal" "$HOME/.personal"

# Copy script_fast.sh to /usr/local/bin
info "Installing script_fast.sh..."
if [ -f "${DOTFILES_DIR}/scripts-personal/script_fast.sh" ]; then
    if sudo cp "${DOTFILES_DIR}/scripts-personal/script_fast.sh" /usr/local/bin/script_fast.sh 2>/dev/null \
       && sudo chmod +x /usr/local/bin/script_fast.sh 2>/dev/null; then
        ok "script_fast.sh installed to /usr/local/bin/"
    else
        warn "Could not install script_fast.sh (sudo unavailable or /usr/local/bin not writable)"
    fi
else
    warn "script_fast.sh not found in scripts-personal/"
fi

echo ""
if [ ${#STOW_FAILED[@]} -gt 0 ]; then
    warn "Stow finished with problems: ${STOW_FAILED[*]}"
    exit 1
fi
ok "All stow operations complete"
