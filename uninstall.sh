#!/usr/bin/env bash
# ============================================================
#  uninstall.sh - Dotfiles Uninstallation Script
#  Removes symlinks and optionally restores backups
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${DOTFILES_DIR}/scripts"
BACKUP_BASE="${HOME}/.dotfiles-backup"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo ""
echo "=========================================="
echo "  Dotfiles Uninstallation"
echo "=========================================="
echo ""

# 1. Detect environment
info "Detecting environment..."
source "${SCRIPTS_DIR}/detect-distro.sh"
echo ""

# 2. Remove stow symlinks
info "Removing stow symlinks..."

PACKAGES=("bash" "nvim" "starship" "ranger" "fastfetch" "git" "personal")

for pkg in "${PACKAGES[@]}"; do
    if stow -D "$pkg" -d "$DOTFILES_DIR" -t "$HOME" 2>/dev/null; then
        ok "Removed symlinks for: $pkg"
    else
        warn "No symlinks found for: $pkg"
    fi
done
echo ""

# 3. Remove script_fast.sh
info "Removing script_fast.sh..."
if [ -f /usr/local/bin/script_fast.sh ]; then
    sudo rm -f /usr/local/bin/script_fast.sh
    ok "Removed /usr/local/bin/script_fast.sh"
else
    warn "/usr/local/bin/script_fast.sh not found"
fi
echo ""

# 4. Offer backup restoration
if [ -d "$BACKUP_BASE" ]; then
    info "Available backups:"
    echo ""
    ls -1dt "${BACKUP_BASE}"/*/ 2>/dev/null | head -5 | while read -r dir; do
        echo "  $(basename "$dir")"
    done
    echo ""

    LATEST=$(ls -1dt "${BACKUP_BASE}"/*/ 2>/dev/null | head -1)
    if [ -n "$LATEST" ]; then
        read -rp "Restore latest backup ($(basename "$LATEST"))? [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            info "Restoring backup from $(basename "$LATEST")..."

            # Restore bash configs
            [ -f "${LATEST}/.bashrc" ] && cp "${LATEST}/.bashrc" "${HOME}/.bashrc" && ok "Restored .bashrc"
            [ -f "${LATEST}/.bash_profile" ] && cp "${LATEST}/.bash_profile" "${HOME}/.bash_profile" && ok "Restored .bash_profile"

            # Restore nvim config
            if [ -d "${LATEST}/nvim" ]; then
                mkdir -p "${HOME}/.config"
                cp -r "${LATEST}/nvim" "${HOME}/.config/" && ok "Restored nvim config"
            fi

            # Restore other configs
            [ -f "${LATEST}/starship.toml" ] && cp "${LATEST}/starship.toml" "${HOME}/.config/starship.toml" && ok "Restored starship.toml"
            [ -d "${LATEST}/ranger" ] && cp -r "${LATEST}/ranger" "${HOME}/.config/" && ok "Restored ranger config"
            [ -d "${LATEST}/fastfetch" ] && cp -r "${LATEST}/fastfetch" "${HOME}/.config/" && ok "Restored fastfetch config"
            [ -f "${LATEST}/.gitconfig" ] && cp "${LATEST}/.gitconfig" "${HOME}/.gitconfig" && ok "Restored .gitconfig"
            [ -d "${LATEST}/personal" ] && cp -r "${LATEST}/personal" "${HOME}/.personal" && ok "Restored personal dir"

            ok "Backup restored successfully"
        else
            info "Backup restoration skipped"
        fi
    fi
else
    info "No backups found in ${BACKUP_BASE}"
fi
echo ""

# 5. Done
echo ""
echo "=========================================="
echo -e "  ${GREEN}Uninstallation complete!${NC}"
echo "=========================================="
echo ""
echo "  CLI tools were NOT uninstalled."
echo "  Use your package manager to remove them:"
echo ""
if [ "$PKG_MGR" = "dnf" ]; then
    echo "    sudo dnf remove fzf bat eza zoxide starship lazygit ranger thefuck duf"
elif [ "$PKG_MGR" = "apt" ]; then
    echo "    sudo apt remove fzf bat eza zoxide starship lazygit ranger thefuck duf"
fi
echo ""
