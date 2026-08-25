#!/usr/bin/env bash
# ============================================================
#  install-prerequisites.sh - Install git and stow
#  Ensures prerequisites are available before installation
# ============================================================

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

install_pkg() {
    local pkg="$1"
    if command -v "$pkg" &>/dev/null; then
        ok "$pkg is already installed"
        return 0
    fi

    info "Installing $pkg..."
    case "$PKG_MGR" in
        dnf)
            sudo dnf install -y "$pkg" >/dev/null 2>&1
            ;;
        apt)
            sudo apt-get install -y "$pkg" >/dev/null 2>&1
            ;;
        *)
            error "Unknown package manager: $PKG_MGR"
            return 1
            ;;
    esac

    if command -v "$pkg" &>/dev/null; then
        ok "$pkg installed successfully"
    else
        error "Failed to install $pkg"
        return 1
    fi
}

# Install git
install_pkg git

# Install stow
install_pkg stow
