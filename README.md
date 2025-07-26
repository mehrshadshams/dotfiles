# 🚀 Dotfiles for macOS

A comprehensive collection of dotfiles and scripts to set up and maintain a macOS development environment.

## 📦 What's Included

### Core Configuration Files
- **`.zshrc`** - Zsh shell configuration with Oh My Zsh, Powerlevel10k, and useful plugins
- **`.gitconfig`** - Git configuration with aliases and helpful settings
- **`.gitignore_global`** - Global Git ignore patterns
- **`.gitattributes`** - Git attributes for consistent file handling and line endings
- **`.vimrc`** - Vim configuration with Vundle and essential plugins
- **`.tmux.conf`** - Tmux configuration with custom theme and plugins
- **`.functions`** - Custom shell functions for enhanced productivity
- **`.alias`** - Useful Docker and general aliases
- **`.macos`** - macOS system preferences and settings

### Development Tools Configuration
- **`.editorconfig`** - Consistent coding styles across editors
- **`.npmrc`** - npm package manager configuration
- **`.gemrc`** - Ruby gems configuration
- **`.pypirc`** - Python package index configuration
- **`.inputrc`** - GNU Readline configuration for better shell experience
- **`.wgetrc`** - wget download configuration
- **`.curlrc`** - curl configuration
- **`.hushlogin`** - Suppress login messages

### Application Settings Templates
- **`vscode-settings.json`** - VS Code editor settings template
- **`.ssh_config`** - SSH configuration template (for ~/.ssh/config)
- **`.docker-config.json`** - Docker configuration template
- **`.mackup.cfg`** - Mackup backup configuration for app settings sync

### Package Management
- **`Brewfile`** - Homebrew packages, casks, and VS Code extensions

### Automation Scripts
- **`install.sh`** - Comprehensive installation script
- **`backup.sh`** - Complete system backup with restore capabilities
- **`system-info.sh`** - System information capture and documentation
- **`capture-prefs.sh`** - macOS preferences and app settings capture
- **`bootstrap.sh`** - Initial setup script
- **`ssh.sh`** - SSH key generation script
- **`aliases.sh`** - Additional shell aliases

## 🛠 Quick Setup

### Prerequisites
- macOS (tested on latest versions)
- Internet connection
- Admin privileges

### One-Command Installation

```bash
git clone https://github.com/mehrshadshams/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mehrshadshams/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installation script:**
   ```bash
   ./install.sh
   ```

3. **Follow the prompts** to configure Git and decide on macOS settings

4. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## 📋 What Gets Installed

### Package Managers & Tools
- **Homebrew** - Package manager for macOS
- **Oh My Zsh** - Zsh framework with plugins
- **Powerlevel10k** - Zsh theme
- **Node Version Manager (nvm)** - Node.js version management
- **pyenv** - Python version management
- **rbenv** - Ruby version management

### Development Tools
- Git, Docker, kubectl, helm
- Programming languages: Go, Python, Node.js, Java
- Editors: Neovim, VS Code extensions
- Databases: PostgreSQL client, MySQL client
- Cloud tools: Azure CLI, Terraform, doctl

### Applications (via Homebrew Cask)
- Development: Warp terminal, Zed editor, PowerShell
- Utilities: Hot (menu bar), Ice (menu organization)
- .NET SDK versions

## 🎨 Features

### Zsh Configuration
- **Powerlevel10k theme** with custom prompt
- **Syntax highlighting** and **autosuggestions**
- **History optimization** with deduplication
- **Auto-completion** enhancements
- **Tool integrations**: Docker, Kubernetes, AWS, etc.

### Git Configuration
- Useful aliases (`git l`, `git s`, `git ca`, etc.)
- **Enhanced diff and log** formatting
- **Automatic cleanup** and optimization
- **Submodule support**

### Vim Configuration
- **Vundle plugin manager**
- **File management** (NERDTree, CtrlP)
- **Git integration** (Fugitive, GitGutter)
- **Code editing** enhancements
- **Dracula color scheme**

### Tmux Configuration
- **Custom key bindings** (Prefix: Ctrl-A)
- **Mouse support** enabled
- **Status bar** with system information
- **Plugin management** with TPM
- **Session and window** management tools

## 🔧 Customization

### Adding Your Own Configurations
1. Edit the relevant dotfiles in the repository
2. Create a `~/.zshrc.local` file for local-only settings
3. Run `./install.sh` again to update symlinks

### Backing Up Current Setup
The installation script automatically backs up existing dotfiles to `~/.dotfiles_backup_[timestamp]`

### Capturing System Information
Generate a comprehensive system report:
```bash
./system-info.sh
```

## 📚 Useful Commands

### Docker (from .alias)
- `dps` - Show running containers
- `dex <container>` - Execute bash in container
- `dip` - Show container IP addresses
- `drmc` - Remove all exited containers

### Custom Functions (from .functions)
- `mkd <dir>` - Create and enter directory
- `weather [location]` - Get weather information
- `extract <file>` - Extract any archive format
- `killport <port>` - Kill process on specific port

### Git Aliases
- `git l` - Pretty log with graph
- `git s` - Short status
- `git ca` - Commit all changes
- `git go <branch>` - Switch/create branch

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Capturing Current System Information
Generate a comprehensive system report:
```bash
./system-info.sh
```

### Capturing macOS Preferences
Save current system and app preferences:
```bash
./capture-prefs.sh
```

### Advanced Usage

#### Multiple Machine Setup
1. **Primary Machine**: Set up dotfiles and customize to your liking
2. **Capture State**: Use `./backup.sh` to create a complete backup
3. **Secondary Machines**: Clone repo and run `./install.sh`
4. **Sync Changes**: Commit changes to repo and pull on other machines

#### Selective Installation
You can install components individually:
```bash
# Just install Homebrew packages
brew bundle --file=./Brewfile

# Just install VS Code extensions
while read extension; do
  code --install-extension $extension
done < vscode-extensions.txt

# Just run macOS preferences
./.macos
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

Inspired by and based on various dotfiles repositories from the community, including:
- [driesvints/dotfiles](https://github.com/driesvints/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

> 💡 You can use a different location than `~/.dotfiles` if you want. Make sure you also update the references in the [`.zshrc`](./.zshrc#L2) and [`fresh.sh`](./fresh.sh#L20) files.

### Cleaning your old Mac (optionally)

After you've set up your new Mac you may want to wipe and clean install your old Mac. Follow [this article](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac) to do that. Remember to [backup your data](#backup-your-data) first!

## Your Own Dotfiles

**Please note that the instructions below assume you already have set up Oh My Zsh so make sure to first [install Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh#getting-started) before you continue.**

If you want to start with your own dotfiles from this setup, it's pretty easy to do so. First of all you'll need to fork this repo. After that you can tweak it the way you want.

Go through the [`.macos`](./.macos) file and adjust the settings to your liking. You can find much more settings at [the original script by Mathias Bynens](https://github.com/mathiasbynens/dotfiles/blob/master/.macos) and [Kevin Suttle's macOS Defaults project](https://github.com/kevinSuttle/MacOS-Defaults).

Check out the [`Brewfile`](./Brewfile) file and adjust the apps you want to install for your machine. Use [their search page](https://formulae.brew.sh/cask/) to check if the app you want to install is available.

Check out the [`aliases.zsh`](./aliases.zsh) file and add your own aliases. If you need to tweak your `$PATH` check out the [`path.zsh`](./path.zsh) file. These files get loaded in because the `$ZSH_CUSTOM` setting points to the `.dotfiles` directory. You can adjust the [`.zshrc`](./.zshrc) file to your liking to tweak your Oh My Zsh setup. More info about how to customize Oh My Zsh can be found [here](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization).

When installing these dotfiles for the first time you'll need to backup all of your settings with Mackup. Install Mackup and backup your settings with the commands below. Your settings will be synced to iCloud so you can use them to sync between computers and reinstall them when reinstalling your Mac. If you want to save your settings to a different directory or different storage than iCloud, [checkout the documentation](https://github.com/lra/mackup/blob/master/doc/README.md#storage). Also make sure your `.zshrc` file is symlinked from your dotfiles repo to your home directory.

```zsh
brew install mackup
mackup backup
```

You can tweak the shell theme, the Oh My Zsh settings and much more. Go through the files in this repo and tweak everything to your liking.

Enjoy your own Dotfiles!

## Thanks To...

I first got the idea for starting this project by visiting the [GitHub does dotfiles](https://dotfiles.github.io/) project. Both [Zach Holman](https://github.com/holman/dotfiles) and [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) were great sources of inspiration. [Sourabh Bajaj](https://twitter.com/sb2nov/)'s [Mac OS X Setup Guide](http://sourabhbajaj.com/mac-setup/) proved to be invaluable. Thanks to [@subnixr](https://github.com/subnixr) for [his awesome Zsh theme](https://github.com/subnixr/minimal)! Thanks to [Caneco](https://twitter.com/caneco) for the header in this readme. And lastly, I'd like to thank [Emma Fabre](https://twitter.com/anahkiasen) for [her excellent presentation on Homebrew](https://speakerdeck.com/anahkiasen/a-storm-homebrewin) which made me migrate a lot to a [`Brewfile`](./Brewfile) and [Mackup](https://github.com/lra/mackup).

In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.
