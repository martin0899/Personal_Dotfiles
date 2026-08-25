#!/usr/bin/env bash
# ============================================================
#  detect-distro.sh - Distribution and Environment Detection
#  Detects Linux distribution and WSL environment
# ============================================================

# 3.1 Detect distribution from /etc/os-release
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            fedora)   DISTRO="fedora" ;;
            debian)   DISTRO="debian" ;;
            ubuntu)   DISTRO="ubuntu" ;;
            linuxmint|pop|elementary|zorin)
                      DISTRO="ubuntu" ;;  # Ubuntu-based
            *)        DISTRO="unknown" ;;
        esac
    else
        DISTRO="unknown"
    fi
}

# 3.2 Detect WSL environment
detect_wsl() {
    IS_WSL=false
    if grep -qi microsoft /proc/version 2>/dev/null; then
        IS_WSL=true
    elif [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
        IS_WSL=true
    fi
}

# 3.3 Set package manager based on distro
detect_pkg_mgr() {
    case "$DISTRO" in
        fedora)           PKG_MGR="dnf" ;;
        debian|ubuntu)    PKG_MGR="apt" ;;
        *)                PKG_MGR="unknown" ;;
    esac
}

# Run all detections
detect_distro
detect_wsl
detect_pkg_mgr

# 3.4 Export variables and show summary
export DISTRO
export IS_WSL
export PKG_MGR

echo "  Distribution: ${DISTRO}"
echo "  Package Manager: ${PKG_MGR}"
echo "  WSL: ${IS_WSL}"
