#!/usr/bin/env bash
# ============================================================
#  install.sh - Dotfiles Installation Script
#  Installs tools and creates symlinks via GNU Stow
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${DOTFILES_DIR}/scripts"

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
echo "  Dotfiles Installation"
echo "=========================================="
echo ""

# 1. Detect environment
info "Detecting environment..."
source "${SCRIPTS_DIR}/detect-distro.sh"
echo ""

# 2. Check prerequisites
info "Checking prerequisites..."
source "${SCRIPTS_DIR}/install-prerequisites.sh"
echo ""

# 3. Backup existing configs
info "Backing up existing configurations..."
source "${SCRIPTS_DIR}/backup.sh"
echo ""

# 4. Install CLI tools
info "Installing CLI tools..."
source "${SCRIPTS_DIR}/install-tools.sh"
echo ""

# 5. Create symlinks via stow
info "Creating symlinks via stow..."
source "${SCRIPTS_DIR}/stow-packages.sh"
echo ""

# 6. Done
echo ""
echo "=========================================="
echo -e "  ${GREEN}Installation complete!${NC}"
echo "=========================================="
echo ""
echo "  Run 'exec bash' or restart your terminal"
echo "  to apply the new configuration."
echo ""
