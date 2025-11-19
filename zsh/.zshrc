export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# dconf dump / | less
# gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
# gsettings set org.gnome.desktop.interface accent-color 'teal'
# gsettings set org.gnome.desktop.interface icon-theme 'Tela-green-dark' # (form git) or 'Tela-circle-green-dark' (from arch linux)

# export GTK_THEME=Adwaita:dark
# export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
# export QT_STYLE_OVERRIDE=Adwaita-Dark

# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export SDL_IM_MODULE=fcitx
# export GLFW_IM_MODULE=fcitx
# export IMSETTINGS_MODULE=fcitx
# export XMODIFIERS=@im=fcitx
# export INPUT_METHOD=fcitx

export MOZ_ENABLE_WAYLAND=1
export DISPLAY=:0
export BAT_THEME="gruvbox-dark"

. "$HOME/.cargo/env"
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static # 用于更新 toolchain
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup # 用于更新 rustup
# export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
# export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup

export RUSTC_WRAPPER=$(which sccache)
export RUSTC_BOOTSTRAP=1
export RUST_BACKTRACE=full
export CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true

export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
export all_proxy="socks5://127.0.0.1:7891"
export no_proxy=127.0.0.1,::1,localhost,*.local,*.lan

# path=(~/.local/bin $path)
# export PATH
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


export CPM_SOURCE_CACHE=$HOME/.cache/CPM

# llvm from source
export PATH="$HOME/builds/llvm-build/llvm-build-install/bin:$PATH"
export CPPFLAGS="$CPPFLAGS -I$HOME/builds/llvm-build/llvm-build-install/include"
export LDFLAGS="$LDFLAGS -L$HOME/builds/llvm-build/llvm-build-install/lib -L$HOME/builds/llvm-build/llvm-build-install/lib/x86_64-pc-linux-gnu -Wl,-rpath,$HOME/builds/llvm-build/llvm-build-install/lib  -Wl,-rpath,$HOME/builds/llvm-build/llvm-build-install/lib/x86_64-pc-linux-gnu"
# -L only for compile time
# -Wl,-rpath will record in the ELF binary (for shared libs)
# LD_RUN_PATH will in binary if -rpath was not explicitly set
# LD_LIBRARY_PATH not record in the binary, but has higher search priority at runtime
# /etc/ld.so.cache controled by config file like /etc/ld.so.conf
# finally search for system default /lib /usr/lib ...

# for rust-cuda
export PATH=/opt/cuda/nvvm/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/nvvm/lib64:${LD_LIBRARY_PATH}
export LLVM_CONFIG=$HOME/builds/llvm-build/llvm-7-build-install/bin/llvm-config
export OPTIX_ROOT=/opt/NVIDIA-OptiX-SDK-9.0.0-linux64-x86_64
export OPTIX_ROOT_DIR=/opt/NVIDIA-OptiX-SDK-9.0.0-linux64-x86_64
export LLVM_LINK_STATIC=1
# export RUST_LOG=info

# kdb
# export QHOME=~/q
# export PATH=$QHOME/l64/:$PATH
export PATH=~/.kx/bin:$PATH # kdb-x
alias q="rlwrap -r q"

# # MVAPICH
# export PATH=/opt/mvapich/bin:$PATH
# export LD_LIBRARY_PATH=/opt/mvapich/lib:$LD_LIBRARY_PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
plugins=(
    # archlinux
    # brew
    # bun
    # conda
    # conda-env
    # cp
    # debian
    # dnf
    # docker
    # docker-compose
    # emoji
    # emoji-clock
    eza
    # fzf
    git
    # git-auto-fetch
    # git-commit
    # git-lfs
    # github
    # gitignore
    # gnu-utils
    # golang
    # gpg-agent
    # history
    # history-substring-search
    # macos
    # man
    # npm
    # pip
    # pipenv
    # pyenv
    # pylint
    # python
    # rsync
    # rust
    # ssh
    # ssh-agent
    # starship
    sudo
    # systemd
    # themes
    # tmux
    # ubuntu
    uv
    # yarn
    # yum
    # vi-mode
    # vim-interaction
    # virtualenv
    # virtualenvwrapper
    # vscode
    # zsh-interactive-cd
    # zsh-navigation-tools
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -U compinit && compinit
eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(register-python-argcomplete pipx)"

# source /opt/nvidia/hpc_sdk/activate

# pnpm
export PNPM_HOME="~/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/zhy/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/zhy/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/zhy/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/zhy/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/zhy/.opam/opam-init/init.zsh' ]] || source '/home/zhy/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

