# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export GOPATH=/Users/mehrshadshams/go
export GOROOT=/usr/local/go
export PATH="/opt/homebrew/bin:/Users/mehrshadshams/.dotnet/tools:$HOME/.cargo/bin:$HOME/bin/:=/opt/homebrew/Cellar/qemu/8.1.2/bin/:$GOPATH/bin:$GOROOT/bin:$PATH"
# Path to your oh-my-zsh installation.
export ZSH="/Users/mehrshadshams/.oh-my-zsh"

export SQL_PASSWORD="MyS3cr3tP@ss"

export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

export CLASSPATH=".:/usr/local/lib/antlr-4.13.0-complete.jar:$CLASSPATH"

alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.0-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.0-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

fpath+=$HOME/.zsh/pure
fpath+=/Users/mehrshadshams/.completion/conda-zsh-completion

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose brew kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

autoload -U promptinit; promptinit
autoload -U compinit; compinit -i

prompt pure

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mehrshadshams/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mehrshadshams/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mehrshadshams/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mehrshadshams/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

#[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

#if [ -f $(brew --prefix)/etc/bash_completion ]; then
# . $(brew --prefix)/etc/bash_completion
#fi

alias compose="docker-compose"
alias k="kubectl"

source ~/.alias

compinit
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mehrshadshams/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mehrshadshams/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mehrshadshams/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mehrshadshams/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

autoload bashcompinit && bashcompinit
#az_version=$(az version | jq '.["azure-cli"]' | tr -d '"')
az_version=$(ls /opt/homebrew/Cellar/azure-cli/ | head -n 1)
source /opt/homebrew/Cellar/azure-cli/$az_version/etc/bash_completion.d/az

# itermplot
export MPLBACKEND="module://itermplot"
export ITERMPLOT=rv

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/tofu tofu
export PATH="/opt/homebrew/sbin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.13/bin:$PATH"
alias python="/opt/homebrew/opt/python@3.13/bin/python3.13"
alias pip="/opt/homebrew/opt/python@3.13/bin/pip3.13"

. "$HOME/.local/bin/env"
