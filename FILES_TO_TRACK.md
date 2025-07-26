# Files to track in dotfiles repository

## Core Configuration Files
- .zshrc               # Zsh shell configuration
- .gitconfig           # Git configuration and aliases
- .gitignore_global    # Global Git ignore patterns
- .gitattributes       # Git attributes for file handling
- .vimrc               # Vim editor configuration
- .tmux.conf          # Tmux terminal multiplexer config
- .functions          # Custom shell functions
- .alias              # Shell aliases (Docker, general)
- .macos              # macOS system preferences script

## Development Tools Configuration
- .editorconfig       # Consistent coding styles across editors
- .npmrc              # npm package manager configuration
- .gemrc              # Ruby gems configuration
- .pypirc             # Python package index configuration
- .inputrc            # GNU Readline configuration
- .wgetrc             # wget download configuration
- .curlrc             # curl configuration
- .hushlogin          # Suppress login messages

## Application Settings Templates
- vscode-settings.json  # VS Code editor settings
- .ssh_config          # SSH configuration template
- .docker-config.json  # Docker configuration template
- .mackup.cfg          # Mackup backup configuration

## Environment & Secrets
- .env.example         # Environment variables template

## Package Management
- Brewfile             # Homebrew packages, casks, and VS Code extensions

## Scripts
- install.sh           # Main installation script
- backup.sh            # Comprehensive backup script
- system-info.sh       # System information capture
- capture-prefs.sh     # macOS preferences capture
- bootstrap.sh         # Initial setup script
- ssh.sh               # SSH key generation script
- aliases.sh           # Additional shell aliases

## Documentation
- README.md            # Complete setup and usage documentation

## Optional/Legacy
- LICENSE              # Project license
- aliases.sh           # Additional aliases (consider merging with .alias)

## Notes

### Files NOT to track in public repo:
- .env.local           # Local environment variables with secrets
- .ssh/config          # Actual SSH configuration (use .ssh_config template)
- .docker/config.json  # Actual Docker config (use template)
- .aws/credentials     # AWS credentials
- .npmrc with tokens   # npm configuration with authentication tokens
- .pypirc with tokens  # PyPI configuration with authentication tokens

### Files that should be in .gitignore:
```
.env.local
.DS_Store
*.log
.ssh/id_*
.ssh/known_hosts
.aws/credentials
node_modules/
.vscode/settings.json
```

### Symlinked vs Copied files:
Most configuration files should be symlinked from the dotfiles repo to the home directory.
Exception: Files containing secrets should be copied and customized locally.
