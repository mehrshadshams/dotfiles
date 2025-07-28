#!/usr/bin/env bash

# install.sh - Setup script for dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is designed for macOS only"
    exit 1
fi

info "Starting dotfiles installation..."

# Create directories
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Backup existing dotfiles
backup_file() {
    local file="$1"
    if [[ -f "$HOME/$file" ]] || [[ -L "$HOME/$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/$file" "$BACKUP_DIR/"
        warning "Backed up existing $file to $BACKUP_DIR"
    fi
}

# Create symlink
create_symlink() {
    local file="$1"
    local source="$DOTFILES_DIR/$file"
    local target="$HOME/$file"

    if [[ -f "$source" ]]; then
        backup_file "$file"
        ln -sf "$source" "$target"
        success "Linked $file"
    else
        warning "Source file $source not found"
    fi
}

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed"
else
    info "Homebrew already installed"
fi

# Install packages from Brewfile
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    info "Installing packages from Brewfile..."
    cd "$DOTFILES_DIR"
    brew bundle
    success "Homebrew packages installed"
fi

# Install Oh My Zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed"
else
    info "Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
P10K_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    success "Powerlevel10k installed"
else
    info "Powerlevel10k already installed"
fi

# Install Zsh plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    success "zsh-autosuggestions installed"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    success "zsh-syntax-highlighting installed"
fi

if [[ ! -d "$HOME/.zsh/pure" ]]; then
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi

# Install Vim Vundle
# VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
# if [[ ! -d "$VUNDLE_DIR" ]]; then
#     info "Installing Vim Vundle..."
#     mkdir -p "$HOME/.vim/bundle"
#     git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
#     success "Vim Vundle installed"
# fi

# Install Tmux Plugin Manager
# TPM_DIR="$HOME/.tmux/plugins/tpm"
# if [[ ! -d "$TPM_DIR" ]]; then
#     info "Installing Tmux Plugin Manager..."
#     mkdir -p "$HOME/.tmux/plugins"
#     git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
#     success "Tmux Plugin Manager installed"
# fi

# Create symlinks for dotfiles
info "Creating symlinks for dotfiles..."

dotfiles=(
    ".zshrc"
    ".gitconfig"
    ".gitignore_global"
    ".gitattributes"
    ".vimrc"
    ".tmux.conf"
    ".functions"
    ".alias"
    ".macos"
    ".wgetrc"
    ".curlrc"
    ".editorconfig"
    ".hushlogin"
    ".inputrc"
    ".npmrc"
    ".gemrc"
    ".pypirc"
    ".mackup.cfg"
)

for file in "${dotfiles[@]}"; do
    create_symlink "$file"
done

# Create template files (these should be copied, not symlinked)
info "Creating template configuration files..."

# SSH config template
if [[ -f "$DOTFILES_DIR/.ssh_config" ]] && [[ ! -f "$HOME/.ssh/config" ]]; then
    mkdir -p "$HOME/.ssh"
    cp "$DOTFILES_DIR/.ssh_config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
    success "SSH config template created"
fi

# VS Code settings
if [[ -f "$DOTFILES_DIR/vscode-settings.json" ]]; then
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    if [[ ! -f "$VSCODE_USER_DIR/settings.json" ]]; then
        mkdir -p "$VSCODE_USER_DIR"
        cp "$DOTFILES_DIR/vscode-settings.json" "$VSCODE_USER_DIR/settings.json"
        success "VS Code settings template created"
    else
        info "VS Code settings already exist (not overwriting)"
    fi
fi

# Docker config template
if [[ -f "$DOTFILES_DIR/.docker-config.json" ]] && [[ ! -f "$HOME/.docker/config.json" ]]; then
    mkdir -p "$HOME/.docker"
    cp "$DOTFILES_DIR/.docker-config.json" "$HOME/.docker/config.json"
    success "Docker config template created"
fi

# Environment variables template
if [[ -f "$DOTFILES_DIR/.env.example" ]] && [[ ! -f "$HOME/.env.local" ]]; then
    cp "$DOTFILES_DIR/.env.example" "$HOME/.env.local"
    warning "Created .env.local template - please edit with your actual values"
fi

# Create symlinks for scripts
if [[ -f "$DOTFILES_DIR/aliases.sh" ]]; then
    backup_file "aliases.sh"
    ln -sf "$DOTFILES_DIR/aliases.sh" "$HOME/aliases.sh"
    success "Linked aliases.sh"
fi

if [[ -f "$DOTFILES_DIR/ssh.sh" ]]; then
    backup_file "ssh.sh"
    ln -sf "$DOTFILES_DIR/ssh.sh" "$HOME/ssh.sh"
    success "Linked ssh.sh"
fi

# Set Zsh as default shell if not already
if [[ "$SHELL" != "/bin/zsh" ]] && [[ "$SHELL" != "/opt/homebrew/bin/zsh" ]]; then
    info "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
    success "Zsh set as default shell"
fi

# Install Node.js via nvm if not present
if ! command -v nvm &> /dev/null; then
    info "Installing Node Version Manager (nvm)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    success "nvm and latest Node.js LTS installed"
fi

# Install Python via uv if not present
if ! command -v uv &> /dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | bash
    eval "$(uv init -)"
    success "uv installed"
fi

# Install Ruby via rbenv if not present
# if ! command -v rbenv &> /dev/null; then
#     info "Installing rbenv..."
#     git clone https://github.com/rbenv/rbenv.git ~/.rbenv
#     git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
#     success "rbenv installed"
# fi

# Configure Git
info "Configuring Git..."
read -p "Enter your Git name: " git_name
read -p "Enter your Git email: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
success "Git configured"

# Run macOS configuration script
if [[ -f "$DOTFILES_DIR/.macos" ]]; then
    read -p "Do you want to run the macOS configuration script? This will change system preferences. (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Running macOS configuration..."
        bash "$DOTFILES_DIR/.macos"
        success "macOS configuration applied"
    fi
fi

# Install Cargo
if ! command -v cargo &> /dev/null; then
    info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    success "Rust installed"
else
    info "Rust already installed"
fi

# Final instructions
echo
success "Dotfiles installation completed!"
echo
info "To complete the setup:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Install Vim plugins by running: vim +PluginInstall +qall"
echo "  3. Install Tmux plugins by pressing: Prefix + I (in tmux)"
echo "  4. Configure Powerlevel10k by running: p10k configure"
echo
if [[ -d "$BACKUP_DIR" ]]; then
    warning "Your original dotfiles have been backed up to: $BACKUP_DIR"
fi
echo
info "Enjoy your new development environment! 🚀"
