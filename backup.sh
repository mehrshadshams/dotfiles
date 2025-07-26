#!/usr/bin/env bash

# backup.sh - Create a backup of current dotfiles and system configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() {
    printf "${BLUE}ℹ${NC} %s\n" "$1"
}

success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
}

error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

# Create backup directory
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

info "Creating backup in: $BACKUP_DIR"

# Files to backup
dotfiles=(
    ".zshrc"
    ".zsh_history"
    ".gitconfig"
    ".gitignore_global"
    ".vimrc"
    ".tmux.conf"
    ".functions"
    ".alias"
    ".ssh/config"
    ".aws/config"
    ".aws/credentials"
    ".docker/config.json"
    ".npmrc"
    ".pypirc"
    ".env.local"
)

# Backup individual dotfiles
info "Backing up dotfiles..."
for file in "${dotfiles[@]}"; do
    if [[ -f "$HOME/$file" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        success "Backed up $file"
    fi
done

# Backup directories
directories=(
    ".oh-my-zsh/custom"
    ".vim"
    ".tmux"
    ".config"
)

info "Backing up directories..."
for dir in "${directories[@]}"; do
    if [[ -d "$HOME/$dir" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$dir")"
        cp -r "$HOME/$dir" "$BACKUP_DIR/$dir"
        success "Backed up $dir"
    fi
done

# Generate current system information
info "Generating system information..."
if [[ -f "$(dirname "$0")/system-info.sh" ]]; then
    cd "$(dirname "$0")"
    ./system-info.sh
    mv system-info-*.md "$BACKUP_DIR/"
    success "System information saved"
fi

# Backup Homebrew packages
if command -v brew &> /dev/null; then
    info "Backing up Homebrew packages..."
    brew bundle dump --file="$BACKUP_DIR/Brewfile" --force
    success "Homebrew packages backed up"
fi

# Backup VS Code settings and extensions
if command -v code &> /dev/null; then
    info "Backing up VS Code configuration..."

    # Extensions
    code --list-extensions > "$BACKUP_DIR/vscode-extensions.txt"

    # Settings
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    if [[ -d "$VSCODE_USER_DIR" ]]; then
        mkdir -p "$BACKUP_DIR/vscode"
        cp "$VSCODE_USER_DIR/settings.json" "$BACKUP_DIR/vscode/" 2>/dev/null || true
        cp "$VSCODE_USER_DIR/keybindings.json" "$BACKUP_DIR/vscode/" 2>/dev/null || true
        cp "$VSCODE_USER_DIR/snippets/"* "$BACKUP_DIR/vscode/" 2>/dev/null || true
    fi
    success "VS Code configuration backed up"
fi

# Backup important application preferences
info "Backing up application preferences..."
PREFS_DIR="$BACKUP_DIR/preferences"
mkdir -p "$PREFS_DIR"

# Copy important preference files
preferences=(
    "com.apple.dock.plist"
    "com.apple.finder.plist"
    "com.apple.Safari.plist"
    "com.apple.Terminal.plist"
    "com.apple.systempreferences.plist"
)

for pref in "${preferences[@]}"; do
    if [[ -f "$HOME/Library/Preferences/$pref" ]]; then
        cp "$HOME/Library/Preferences/$pref" "$PREFS_DIR/"
        success "Backed up $pref"
    fi
done

# Create a restore script
info "Creating restore script..."
cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/usr/bin/env bash

# restore.sh - Restore dotfiles and configuration from backup

set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Restoring from backup: $BACKUP_DIR"

# Restore dotfiles
for file in $(find . -name ".*" -type f | grep -v "./\.git" | sed 's|^\./||'); do
    if [[ -f "$BACKUP_DIR/$file" ]]; then
        echo "Restoring $file"
        cp "$BACKUP_DIR/$file" "$HOME/$file"
    fi
done

# Restore directories
for dir in $(find . -name ".*" -type d | grep -v "./\.git" | sed 's|^\./||'); do
    if [[ -d "$BACKUP_DIR/$dir" ]]; then
        echo "Restoring directory $dir"
        mkdir -p "$HOME/$dir"
        cp -r "$BACKUP_DIR/$dir"/* "$HOME/$dir/"
    fi
done

# Restore Homebrew packages
if [[ -f "$BACKUP_DIR/Brewfile" ]] && command -v brew &> /dev/null; then
    echo "Restoring Homebrew packages..."
    brew bundle --file="$BACKUP_DIR/Brewfile"
fi

# Restore VS Code extensions
if [[ -f "$BACKUP_DIR/vscode-extensions.txt" ]] && command -v code &> /dev/null; then
    echo "Restoring VS Code extensions..."
    while read -r extension; do
        code --install-extension "$extension"
    done < "$BACKUP_DIR/vscode-extensions.txt"
fi

echo "Restore completed!"
EOF

chmod +x "$BACKUP_DIR/restore.sh"

# Create backup summary
cat > "$BACKUP_DIR/README.md" << EOF
# Dotfiles Backup - $(date)

This backup was created on $(date) and contains:

## Contents
- Dotfiles (zsh, git, vim, tmux, etc.)
- Application configurations
- Homebrew package list
- VS Code settings and extensions
- System information report
- macOS preferences

## How to Restore
Run the restore script to restore all backed up files:
\`\`\`bash
./restore.sh
\`\`\`

## Files Included
$(find . -type f | sort)

## System Information
See the system-info-*.md file for detailed system information at the time of backup.
EOF

# Compress the backup
info "Compressing backup..."
cd "$HOME"
tar -czf "${BACKUP_DIR}.tar.gz" "$(basename "$BACKUP_DIR")"
rm -rf "$BACKUP_DIR"

success "Backup completed and compressed: ${BACKUP_DIR}.tar.gz"
success "Backup size: $(du -h "${BACKUP_DIR}.tar.gz" | cut -f1)"

echo
info "To restore this backup on another machine:"
echo "  1. Extract: tar -xzf $(basename "${BACKUP_DIR}.tar.gz")"
echo "  2. Run: cd $(basename "$BACKUP_DIR") && ./restore.sh"
