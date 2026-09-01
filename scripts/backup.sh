#!/usr/bin/env bash
# ============================================================
#  backup.sh - Configuration Backup Script
#  Moves existing configs to the backup dir so stow can
#  create its symlinks without conflicts
# ============================================================

BACKUP_BASE="${HOME}/.dotfiles-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="${BACKUP_BASE}/${TIMESTAMP}"
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

# True if the path is a symlink already managed by this repo (re-install case)
is_ours() {
    [ -L "$1" ] || return 1
    local resolved
    resolved="$(readlink -f "$1" 2>/dev/null)" || return 1
    [[ "$resolved" == "${DOTFILES_DIR}"/* ]]
}

# 5.1 Create backup directory with timestamp
mkdir -p "$BACKUP_DIR"
if [ ! -d "$BACKUP_DIR" ]; then
    error "Failed to create backup directory: $BACKUP_DIR"
    exit 1
fi
ok "Backup directory: $BACKUP_DIR"

# 5.2 Backup by moving: this also clears the path for stow
backup_file() {
    local src="$1"
    local dest="$2"
    if is_ours "$src"; then
        info "Already managed by dotfiles, skipping: $src"
        return 0
    fi
    if [ -e "$src" ] || [ -L "$src" ]; then
        if mv "$src" "$dest"; then
            ok "Backed up: $(basename "$src")"
        else
            error "Backup failed for: $src"
            exit 1
        fi
    else
        warn "Not found, skipping: $src"
    fi
    return 0
}

backup_dir() {
    local src="$1"
    local dest="$2"
    if is_ours "$src"; then
        info "Already managed by dotfiles, skipping: $src/"
        return 0
    fi
    if [ -d "$src" ]; then
        if mv "$src" "$dest"; then
            ok "Backed up: $(basename "$src")/"
        else
            error "Backup failed for: $src"
            exit 1
        fi
    else
        warn "Not found, skipping: $src/"
    fi
    return 0
}

# Backup bash and git configs
backup_file "${HOME}/.bashrc" "${BACKUP_DIR}/.bashrc"
backup_file "${HOME}/.bash_profile" "${BACKUP_DIR}/.bash_profile"
backup_file "${HOME}/.gitconfig" "${BACKUP_DIR}/.gitconfig"

# 5.3 Backup config directories and starship.toml
backup_dir "${HOME}/.config/nvim" "${BACKUP_DIR}/nvim"
backup_dir "${HOME}/.config/ranger" "${BACKUP_DIR}/ranger"
backup_dir "${HOME}/.config/fastfetch" "${BACKUP_DIR}/fastfetch"
backup_file "${HOME}/.config/starship.toml" "${BACKUP_DIR}/starship.toml"

# 5.4 Backup ~/.personal files that stow will replace
mkdir -p "${BACKUP_DIR}/personal"
for f in "${DOTFILES_DIR}"/personal/*; do
    [ -e "$f" ] || continue
    backup_file "${HOME}/.personal/$(basename "$f")" "${BACKUP_DIR}/personal/$(basename "$f")"
done

# 5.5 Clean stray symlinks left in ~/.config/ by old installer versions
#     (they become dangling after the package restructure)
LEGACY_STRAYS=(init.lua init.vim.bak lazy-lock.json coc-settings.json
               autoload lua plug-config
               rc.conf rifle.conf commands.py commands_full.py scope.sh
               config.jsonc config1.jsonc config2.jsonc config3.jsonc logos)
for name in "${LEGACY_STRAYS[@]}"; do
    stray="${HOME}/.config/${name}"
    if is_ours "$stray"; then
        rm -f "$stray"
        warn "Removed stray link from old install: ~/.config/${name}"
    fi
done

# 5.6 Verify backup integrity
echo ""
info "Verifying backup integrity..."

BACKUP_COUNT=0
FAIL_COUNT=0

for item in "${BACKUP_DIR}"/* "${BACKUP_DIR}"/.[!.]* "${BACKUP_DIR}"/..?*; do
    if [ -e "$item" ]; then
        if [ -f "$item" ] && [ ! -s "$item" ]; then
            error "Empty file in backup: $(basename "$item")"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        else
            BACKUP_COUNT=$((BACKUP_COUNT + 1))
        fi
    fi
done

if [ "$FAIL_COUNT" -eq 0 ]; then
    ok "Backup verified: ${BACKUP_COUNT} items backed up successfully"
else
    warn "Backup completed with ${FAIL_COUNT} warnings"
fi
