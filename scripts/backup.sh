#!/usr/bin/env bash
# ============================================================
#  backup.sh - Configuration Backup Script
#  Backs up existing configs before dotfiles installation
# ============================================================

BACKUP_BASE="${HOME}/.dotfiles-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="${BACKUP_BASE}/${TIMESTAMP}"

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

# 5.1 Create backup directory with timestamp
mkdir -p "$BACKUP_DIR"
if [ ! -d "$BACKUP_DIR" ]; then
    error "Failed to create backup directory: $BACKUP_DIR"
    exit 1
fi
ok "Backup directory: $BACKUP_DIR"

# 5.2 Backup bash configs
backup_file() {
    local src="$1"
    local dest="$2"
    if [ -e "$src" ]; then
        cp "$src" "$dest"
        if [ -f "$dest" ] && [ -s "$dest" ]; then
            ok "Backed up: $(basename "$src")"
            return 0
        else
            error "Backup failed for: $src"
            return 1
        fi
    else
        warn "Not found, skipping: $src"
        return 0
    fi
}

backup_dir() {
    local src="$1"
    local dest="$2"
    if [ -d "$src" ]; then
        cp -r "$src" "$dest"
        if [ -d "$dest" ]; then
            ok "Backed up: $(basename "$src")/"
            return 0
        else
            error "Backup failed for: $src"
            return 1
        fi
    else
        warn "Not found, skipping: $src"
        return 0
    fi
}

# Backup bash configs
backup_file "${HOME}/.bashrc" "${BACKUP_DIR}/.bashrc"
backup_file "${HOME}/.bash_profile" "${BACKUP_DIR}/.bash_profile"

# 5.3 Backup nvim config directory
backup_dir "${HOME}/.config/nvim" "${BACKUP_DIR}/nvim"

# 5.4 Backup tool configs
backup_file "${HOME}/.config/starship.toml" "${BACKUP_DIR}/starship.toml"
backup_dir "${HOME}/.config/ranger" "${BACKUP_DIR}/ranger"
backup_dir "${HOME}/.config/fastfetch" "${BACKUP_DIR}/fastfetch"

# 5.5 Backup personal dir and gitconfig
backup_dir "${HOME}/.personal" "${BACKUP_DIR}/personal"
backup_file "${HOME}/.gitconfig" "${BACKUP_DIR}/.gitconfig"

# 5.6 Verify backup integrity
echo ""
info "Verifying backup integrity..."

BACKUP_COUNT=0
FAIL_COUNT=0

for item in "${BACKUP_DIR}"/*; do
    if [ -e "$item" ]; then
        if [ -f "$item" ] && [ ! -s "$item" ]; then
            error "Empty file in backup: $(basename "$item")"
            ((FAIL_COUNT++))
        else
            ((BACKUP_COUNT++))
        fi
    fi
done

if [ "$FAIL_COUNT" -eq 0 ]; then
    ok "Backup verified: ${BACKUP_COUNT} items backed up successfully"
else
    warn "Backup completed with ${FAIL_COUNT} warnings"
fi
