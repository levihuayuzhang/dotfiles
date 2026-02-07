set -U fish_greeting ""

set -Ux GPG_TTY (tty)

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
abbr -a ct 'cargo t'

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

set PATH $PATH ~/.local/bin

set -Ux fish_color_command green --bold

