#!/usr/bin/env bash
# ============================================================
#  install-tools.sh - CLI Tools Installation Script
#  Installs CLI tools based on detected distribution
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

# Track results
declare -a INSTALLED=()
declare -a FAILED=()

# 6.1 Install a single tool with error handling
install_tool() {
    local tool_name="$1"
    local pkg_name="${2:-$1}"  # Package name may differ from command name
    local alt_cmd="${3:-}"     # Alternative binary (bat is batcat on Debian/Ubuntu)

    if command -v "$tool_name" &>/dev/null || { [ -n "$alt_cmd" ] && command -v "$alt_cmd" &>/dev/null; }; then
        ok "$tool_name is already installed"
        INSTALLED+=("$tool_name")
        return 0
    fi

    info "Installing $tool_name..."
    case "$PKG_MGR" in
        dnf)
            if sudo dnf install -y "$pkg_name" >/dev/null 2>&1; then
                ok "$tool_name installed"
                INSTALLED+=("$tool_name")
            else
                warn "$tool_name failed to install via dnf"
                FAILED+=("$tool_name")
            fi
            ;;
        apt)
            if sudo apt-get install -y "$pkg_name" >/dev/null 2>&1; then
                ok "$tool_name installed"
                INSTALLED+=("$tool_name")
            else
                warn "$tool_name failed to install via apt"
                FAILED+=("$tool_name")
            fi
            ;;
        *)
            error "Unknown package manager: $PKG_MGR"
            FAILED+=("$tool_name")
            ;;
    esac
}

# 6.2 Install core CLI tools
info "Installing core CLI tools..."

install_tool "fzf" "fzf"
install_tool "bat" "bat" "batcat"
install_tool "eza" "eza"
install_tool "zoxide" "zoxide"
install_tool "starship" "starship"
install_tool "lazygit" "lazygit"
install_tool "ranger" "ranger"
install_tool "thefuck" "thefuck"
install_tool "duf" "duf"

# 6.2b Tools used by personal aliases (best effort: not all exist in every repo)
install_tool "fastfetch" "fastfetch"
install_tool "tty-clock" "tty-clock"
install_tool "scrcpy" "scrcpy"
install_tool "podman" "podman"

# ncspot and tldr are not packaged in Ubuntu repos - only attempt on other distros
if [ "$DISTRO" != "ubuntu" ]; then
    install_tool "ncspot" "ncspot"
    install_tool "tldr" "tldr"
else
    info "Skipping ncspot and tldr (not available via apt on Ubuntu)"
fi

# 6.3 Install neovim
info "Installing neovim..."
if command -v nvim &>/dev/null; then
    ok "neovim is already installed"
    INSTALLED+=("neovim")
else
    case "$PKG_MGR" in
        dnf)
            # Try official repos first, then AppImage
            if sudo dnf install -y neovim >/dev/null 2>&1; then
                ok "neovim installed via dnf"
                INSTALLED+=("neovim")
            else
                warn "neovim not in repos, trying AppImage..."
                mkdir -p "$HOME/.local/bin"
                if curl -fSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage" -o "$HOME/.local/bin/nvim" >/dev/null 2>&1; then
                    chmod +x "$HOME/.local/bin/nvim"
                    ok "neovim installed via AppImage"
                    INSTALLED+=("neovim")
                else
                    warn "neovim AppImage download failed"
                    FAILED+=("neovim")
                fi
            fi
            ;;
        apt)
            # Try official repos first
            if sudo apt-get install -y neovim >/dev/null 2>&1; then
                ok "neovim installed via apt"
                INSTALLED+=("neovim")
            else
                # Add PPA for newer version
                sudo add-apt-repository -y ppa:neovim-ppa/unstable >/dev/null 2>&1
                sudo apt-get update >/dev/null 2>&1
                if sudo apt-get install -y neovim >/dev/null 2>&1; then
                    ok "neovim installed via PPA"
                    INSTALLED+=("neovim")
                else
                    warn "neovim installation failed"
                    FAILED+=("neovim")
                fi
            fi
            ;;
    esac
fi

# 6.4 WSL-specific installations
if [ "$IS_WSL" = true ]; then
    info "Installing WSL-specific tools..."

    # win32yank for clipboard
    if ! command -v win32yank.exe &>/dev/null; then
        info "Installing win32yank..."
        WIN32YANK_URL="https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip"
        if curl -fSL "$WIN32YANK_URL" -o /tmp/win32yank.zip >/dev/null 2>&1; then
            unzip -o /tmp/win32yank.zip -d /tmp/win32yank >/dev/null 2>&1
            sudo mv /tmp/win32yank/win32yank.exe /usr/local/bin/ 2>/dev/null
            sudo chmod +x /usr/local/bin/win32yank.exe 2>/dev/null
            rm -rf /tmp/win32yank /tmp/win32yank.zip
            ok "win32yank installed"
            INSTALLED+=("win32yank")
        else
            warn "win32yank download failed"
            FAILED+=("win32yank")
        fi
    else
        ok "win32yank is already installed"
        INSTALLED+=("win32yank")
    fi
fi

# 6.6 Summary
echo ""
echo "=========================================="
echo "  Installation Summary"
echo "=========================================="
echo ""
if [ ${#INSTALLED[@]} -gt 0 ]; then
    echo -e "${GREEN}Installed/Available:${NC}"
    for tool in "${INSTALLED[@]}"; do
        echo "  ✓ $tool"
    done
fi
if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Failed:${NC}"
    for tool in "${FAILED[@]}"; do
        echo "  ✗ $tool"
    done
fi
echo ""
