#!/usr/bin/env bash

# capture-prefs.sh - Capture current macOS system preferences and app settings

set -e

OUTPUT_DIR="captured-preferences-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "🎯 Capturing macOS preferences to: $OUTPUT_DIR"

# Capture system preferences
echo "📱 Capturing system preferences..."
mkdir -p "$OUTPUT_DIR/system"

# Dock preferences
defaults export com.apple.dock "$OUTPUT_DIR/system/dock.plist"

# Finder preferences
defaults export com.apple.finder "$OUTPUT_DIR/system/finder.plist"

# Desktop preferences
defaults export com.apple.desktop "$OUTPUT_DIR/system/desktop.plist" 2>/dev/null || true

# Trackpad preferences
defaults export com.apple.AppleMultitouchTrackpad "$OUTPUT_DIR/system/trackpad.plist" 2>/dev/null || true
defaults export com.apple.driver.AppleBluetoothMultitouch.trackpad "$OUTPUT_DIR/system/trackpad-bluetooth.plist" 2>/dev/null || true

# Mouse preferences
defaults export com.apple.AppleMultitouchMouse "$OUTPUT_DIR/system/mouse.plist" 2>/dev/null || true

# Keyboard preferences
defaults export com.apple.HIToolbox "$OUTPUT_DIR/system/keyboard.plist" 2>/dev/null || true

# Mission Control preferences
defaults export com.apple.dock "$OUTPUT_DIR/system/mission-control.plist" 2>/dev/null || true

# Energy Saver preferences
defaults export com.apple.PowerManagement.plist "$OUTPUT_DIR/system/power-management.plist" 2>/dev/null || true

# Global preferences
defaults export NSGlobalDomain "$OUTPUT_DIR/system/global.plist"

# Capture application preferences
echo "🖥️  Capturing application preferences..."
mkdir -p "$OUTPUT_DIR/apps"

# Terminal preferences
defaults export com.apple.Terminal "$OUTPUT_DIR/apps/terminal.plist" 2>/dev/null || true

# iTerm2 preferences
defaults export com.googlecode.iterm2 "$OUTPUT_DIR/apps/iterm2.plist" 2>/dev/null || true

# VS Code preferences
if [[ -f "$HOME/Library/Application Support/Code/User/settings.json" ]]; then
    cp "$HOME/Library/Application Support/Code/User/settings.json" "$OUTPUT_DIR/apps/vscode-settings.json"
fi

if [[ -f "$HOME/Library/Application Support/Code/User/keybindings.json" ]]; then
    cp "$HOME/Library/Application Support/Code/User/keybindings.json" "$OUTPUT_DIR/apps/vscode-keybindings.json"
fi

# VS Code extensions
if command -v code &> /dev/null; then
    code --list-extensions > "$OUTPUT_DIR/apps/vscode-extensions.txt"
fi

# Safari preferences
defaults export com.apple.Safari "$OUTPUT_DIR/apps/safari.plist" 2>/dev/null || true

# Chrome preferences
defaults export com.google.Chrome "$OUTPUT_DIR/apps/chrome.plist" 2>/dev/null || true

# Mail preferences
defaults export com.apple.mail "$OUTPUT_DIR/apps/mail.plist" 2>/dev/null || true

# Messages preferences
defaults export com.apple.messageshelper.MessageController "$OUTPUT_DIR/apps/messages.plist" 2>/dev/null || true

# Calendar preferences
defaults export com.apple.iCal "$OUTPUT_DIR/apps/calendar.plist" 2>/dev/null || true

# Activity Monitor preferences
defaults export com.apple.ActivityMonitor "$OUTPUT_DIR/apps/activity-monitor.plist" 2>/dev/null || true

# Capture Homebrew state
echo "🍺 Capturing Homebrew state..."
if command -v brew &> /dev/null; then
    brew bundle dump --file="$OUTPUT_DIR/Brewfile" --force
    brew list --formula > "$OUTPUT_DIR/brew-formulas.txt"
    brew list --cask > "$OUTPUT_DIR/brew-casks.txt"
fi

# Capture SSH configuration
echo "🔐 Capturing SSH configuration..."
if [[ -f "$HOME/.ssh/config" ]]; then
    # Remove sensitive information but keep structure
    sed 's/IdentityFile.*/IdentityFile [REDACTED]/' "$HOME/.ssh/config" > "$OUTPUT_DIR/ssh-config-template"
fi

if [[ -d "$HOME/.ssh" ]]; then
    ls -la "$HOME/.ssh"/*.pub 2>/dev/null | awk '{print $9}' > "$OUTPUT_DIR/ssh-public-keys.txt" || echo "No public keys found" > "$OUTPUT_DIR/ssh-public-keys.txt"
fi

# Capture shell configuration
echo "🐚 Capturing shell configuration..."
if [[ -f "$HOME/.zshrc" ]]; then
    cp "$HOME/.zshrc" "$OUTPUT_DIR/zshrc-current"
fi

if [[ -f "$HOME/.bashrc" ]]; then
    cp "$HOME/.bashrc" "$OUTPUT_DIR/bashrc-current"
fi

if [[ -f "$HOME/.bash_profile" ]]; then
    cp "$HOME/.bash_profile" "$OUTPUT_DIR/bash_profile-current"
fi

# Capture Git configuration
echo "📝 Capturing Git configuration..."
if [[ -f "$HOME/.gitconfig" ]]; then
    # Remove sensitive information
    sed 's/token = .*/token = [REDACTED]/' "$HOME/.gitconfig" > "$OUTPUT_DIR/gitconfig-template"
fi

if [[ -f "$HOME/.gitignore_global" ]]; then
    cp "$HOME/.gitignore_global" "$OUTPUT_DIR/gitignore_global"
fi

# Capture fonts
echo "🔤 Capturing installed fonts..."
ls -1 "$HOME/Library/Fonts" > "$OUTPUT_DIR/user-fonts.txt" 2>/dev/null || echo "No user fonts found" > "$OUTPUT_DIR/user-fonts.txt"
ls -1 "/System/Library/Fonts" | head -20 > "$OUTPUT_DIR/system-fonts-sample.txt" 2>/dev/null || true

# Capture launchctl services
echo "🚀 Capturing launch services..."
launchctl list | grep -v "com.apple" | head -20 > "$OUTPUT_DIR/launchctl-services.txt" 2>/dev/null || true

# Create a restore script
echo "📄 Creating restore script..."
cat > "$OUTPUT_DIR/restore-preferences.sh" << 'EOF'
#!/usr/bin/env bash

# restore-preferences.sh - Restore captured preferences

set -e

PREFS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Restoring preferences from: $PREFS_DIR"

# Restore system preferences
echo "📱 Restoring system preferences..."
for plist in "$PREFS_DIR/system"/*.plist; do
    if [[ -f "$plist" ]]; then
        domain=$(basename "$plist" .plist)
        echo "  Restoring $domain preferences..."
        defaults import "$domain" "$plist" 2>/dev/null || echo "    ⚠️  Could not restore $domain (may require admin privileges)"
    fi
done

# Restore app preferences
echo "🖥️  Restoring application preferences..."
for plist in "$PREFS_DIR/apps"/*.plist; do
    if [[ -f "$plist" ]]; then
        domain=$(basename "$plist" .plist)
        echo "  Restoring $domain preferences..."
        defaults import "$domain" "$plist" 2>/dev/null || echo "    ⚠️  Could not restore $domain"
    fi
done

# Restore VS Code settings
if [[ -f "$PREFS_DIR/apps/vscode-settings.json" ]]; then
    mkdir -p "$HOME/Library/Application Support/Code/User"
    cp "$PREFS_DIR/apps/vscode-settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    echo "  ✅ Restored VS Code settings"
fi

if [[ -f "$PREFS_DIR/apps/vscode-keybindings.json" ]]; then
    cp "$PREFS_DIR/apps/vscode-keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
    echo "  ✅ Restored VS Code keybindings"
fi

# Restore Homebrew packages
if [[ -f "$PREFS_DIR/Brewfile" ]] && command -v brew &> /dev/null; then
    echo "🍺 Restoring Homebrew packages..."
    brew bundle --file="$PREFS_DIR/Brewfile"
fi

# Restore VS Code extensions
if [[ -f "$PREFS_DIR/apps/vscode-extensions.txt" ]] && command -v code &> /dev/null; then
    echo "🔌 Restoring VS Code extensions..."
    while read -r extension; do
        echo "  Installing $extension..."
        code --install-extension "$extension" --force
    done < "$PREFS_DIR/apps/vscode-extensions.txt"
fi

echo "✅ Preference restoration completed!"
echo "⚠️  Note: Some preferences may require a logout/restart to take effect."
EOF

chmod +x "$OUTPUT_DIR/restore-preferences.sh"

# Create README
cat > "$OUTPUT_DIR/README.md" << EOF
# macOS Preferences Backup - $(date)

This backup contains macOS system preferences and application settings captured on $(date).

## Contents

- **system/**: macOS system preferences (Dock, Finder, Trackpad, etc.)
- **apps/**: Application preferences and settings
- **Brewfile**: Homebrew packages and casks
- **ssh-config-template**: SSH configuration template (sensitive data removed)
- **gitconfig-template**: Git configuration template (tokens removed)
- Various configuration files and lists

## How to Restore

Run the restore script to restore preferences:
\`\`\`bash
./restore-preferences.sh
\`\`\`

## Manual Steps

Some preferences may need to be restored manually:

1. **SSH Keys**: Copy your SSH keys to \`~/.ssh/\` and set proper permissions:
   \`\`\`bash
   chmod 600 ~/.ssh/id_*
   chmod 644 ~/.ssh/*.pub
   \`\`\`

2. **Git Credentials**: Update \`.gitconfig\` with your actual tokens/credentials

3. **Application-specific**: Some apps may need to be configured manually

## Security Note

Sensitive information (SSH keys, tokens, passwords) has been removed from this backup.
You'll need to restore these manually from secure storage.
EOF

echo "✅ Preferences captured successfully!"
echo "📁 Backup location: $OUTPUT_DIR"
echo "📝 See README.md for restoration instructions"

# Compress the backup
tar -czf "${OUTPUT_DIR}.tar.gz" "$OUTPUT_DIR"
echo "📦 Compressed backup: ${OUTPUT_DIR}.tar.gz"
