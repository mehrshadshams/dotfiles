#!/usr/bin/env bash

# system-info.sh - Capture current system configuration

set -e

OUTPUT_FILE="system-info-$(date +%Y%m%d_%H%M%S).md"

echo "# System Information Report" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# macOS Version
echo "## macOS Version" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
sw_vers >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Hardware Information
echo "## Hardware Information" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
system_profiler SPHardwareDataType | grep -E "(Model Name|Model Identifier|Processor|Memory|Serial Number)" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Homebrew packages
if command -v brew &> /dev/null; then
    echo "## Homebrew Packages" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    brew list --formula >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    echo "## Homebrew Casks" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    brew list --cask >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# VS Code extensions
if command -v code &> /dev/null; then
    echo "## VS Code Extensions" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    code --list-extensions >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Node.js version and global packages
if command -v node &> /dev/null; then
    echo "## Node.js Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Node.js version: $(node --version)" >> "$OUTPUT_FILE"
    echo "npm version: $(npm --version)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Global npm packages:" >> "$OUTPUT_FILE"
    npm list -g --depth=0 2>/dev/null || true >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Python version and packages
if command -v python3 &> /dev/null; then
    echo "## Python Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Python version: $(python3 --version)" >> "$OUTPUT_FILE"
    echo "pip version: $(pip3 --version)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Installed packages:" >> "$OUTPUT_FILE"
    pip3 list 2>/dev/null || true >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Ruby version and gems
if command -v ruby &> /dev/null; then
    echo "## Ruby Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Ruby version: $(ruby --version)" >> "$OUTPUT_FILE"
    if command -v gem &> /dev/null; then
        echo "Gem version: $(gem --version)" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "Installed gems:" >> "$OUTPUT_FILE"
        gem list 2>/dev/null || true >> "$OUTPUT_FILE"
    fi
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Go version
if command -v go &> /dev/null; then
    echo "## Go Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Go version: $(go version)" >> "$OUTPUT_FILE"
    echo "GOPATH: $GOPATH" >> "$OUTPUT_FILE"
    echo "GOROOT: $GOROOT" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Java version
if command -v java &> /dev/null; then
    echo "## Java Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Java version:" >> "$OUTPUT_FILE"
    java -version 2>&1 >> "$OUTPUT_FILE"
    echo "JAVA_HOME: $JAVA_HOME" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Shell information
echo "## Shell Information" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "Current shell: $SHELL" >> "$OUTPUT_FILE"
echo "Zsh version: $(zsh --version 2>/dev/null || echo 'Not installed')" >> "$OUTPUT_FILE"
echo "Bash version: $(bash --version | head -1 2>/dev/null || echo 'Not installed')" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Git configuration
if command -v git &> /dev/null; then
    echo "## Git Configuration" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Git version: $(git --version)" >> "$OUTPUT_FILE"
    echo "User name: $(git config --global user.name 2>/dev/null || echo 'Not set')" >> "$OUTPUT_FILE"
    echo "User email: $(git config --global user.email 2>/dev/null || echo 'Not set')" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Docker information
if command -v docker &> /dev/null; then
    echo "## Docker Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "Docker version:" >> "$OUTPUT_FILE"
    docker --version 2>/dev/null || echo "Docker not running" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Kubernetes information
if command -v kubectl &> /dev/null; then
    echo "## Kubernetes Information" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "kubectl version:" >> "$OUTPUT_FILE"
    kubectl version --client 2>/dev/null || echo "kubectl not configured" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# SSH Keys
echo "## SSH Keys" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
if [[ -d "$HOME/.ssh" ]]; then
    echo "SSH keys found:" >> "$OUTPUT_FILE"
    ls -la "$HOME/.ssh"/*.pub 2>/dev/null | awk '{print $9}' | xargs -I {} basename {} >> "$OUTPUT_FILE" || echo "No public keys found" >> "$OUTPUT_FILE"
else
    echo "No SSH directory found" >> "$OUTPUT_FILE"
fi
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# macOS System Preferences (sample)
echo "## macOS System Preferences (Sample)" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "Dock size: $(defaults read com.apple.dock tilesize 2>/dev/null || echo 'Default')" >> "$OUTPUT_FILE"
echo "Dock autohide: $(defaults read com.apple.dock autohide 2>/dev/null || echo 'Default')" >> "$OUTPUT_FILE"
echo "Finder show extensions: $(defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null || echo 'Default')" >> "$OUTPUT_FILE"
echo "Trackpad tap to click: $(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 2>/dev/null || echo 'Default')" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Installed Applications (from /Applications)
echo "## Installed Applications" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
ls /Applications/ | grep -E '\.app$' | sed 's/\.app$//' | sort >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Current running processes (top processes by CPU)
echo "## Top Processes by CPU" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
ps aux | head -1 >> "$OUTPUT_FILE"
ps aux | sort -nr -k 3 | head -10 >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Network interfaces
echo "## Network Information" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
ifconfig | grep -E "(inet |ether )" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "System information saved to: $OUTPUT_FILE"
