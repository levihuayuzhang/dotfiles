set -U fish_greeting ""
set -Ux fish_color_command green --bold

set -gx GPG_TTY (tty)
set -Ux EDITOR "nvim"
set -Ux SUDO_EDITOR "$EDITOR"

set -Ux QT_SCALE_FACTOR 1.5
set -Ux GDK_SCALE 1.5
set -Ux GDK_DPI_SCALE 1.0
set -Ux BAT_THEME "gruvbox-dark"
set -Ux DELTA_FEATURES "+side-by-side"

set PATH $PATH $HOME/bin
set PATH $PATH $HOME/.local/bin

# proxy
set -Ux http_proxy "http://127.0.0.1:7890"
set -Ux https_proxy "http://127.0.0.1:7890"
set -Ux all_proxy "socks5://127.0.0.1:7891"
set -eg no_proxy
set -Ux no_proxy "127.0.0.1,::1,localhost,*.local,*.lan"

abbr -a c cargo
abbr -a e nvim
abbr -a m make
abbr -a o xdg-open
abbr -a g git
abbr -a gc 'git checkout'
abbr -a ga 'git add -p'
abbr -a gaa 'git add --all'
abbr -a gdca 'git diff --cached'
abbr -a gcss 'git commit --gpg-sign --signoff'
abbr -a gp 'git push'
abbr -a vimdiff 'nvim -d'

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if command -v paru > /dev/null
	abbr -a p 'paru'
	abbr -a up 'paru -Syu'
else if command -v aurman > /dev/null
	abbr -a p 'aurman'
	abbr -a up 'aurman -Syu'
else
	abbr -a p 'sudo pacman'
	abbr -a up 'sudo pacman -Syu'
end

if command -v eza > /dev/null
	abbr -a l 'eza -la'
	abbr -a ls 'eza'
	abbr -a ll 'eza -l'
else
	abbr -a l 'ls -la'
	abbr -a ll 'ls -l'
end

starship init fish | source

direnv hook fish | source

# homebrew
set PATH $PATH /home/linuxbrew/.linuxbrew/bin
set -Ux HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
set -Ux HOMEBREW_CORE_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
set -Ux HOMEBREW_INSTALL_FROM_API 1
set -Ux HOMEBREW_API_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
set -Ux HOMEBREW_BOTTLE_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
set -Ux HOMEBREW_PIP_INDEX_URL "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
brew shellenv | source
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end
if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# cuda
fish_add_path /usr/local/cuda/bin
set -Ux LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH 
set -Ux CUDA_TOOLKIT_PATH /usr/local/cuda

# rust
set -Ux RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
set -Ux RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
abbr -a ct 'cargo t'

