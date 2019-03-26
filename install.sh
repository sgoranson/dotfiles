#!/usr/bin/env zsh 


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p "$HOME/.local/share/steve"
mkdir -p "$HOME/.local/share/barrier"

mkdir -p  "$HOME/.cache/dein/repos/github.com/"

ln -i -s --no-target-directory  "$HOME/.local/share/steve" "$HOME/data"

ln -i -s --no-target-directory  "$HOME/.cache/dein/repos/github.com/" "$HOME/plugs"

ln -i -s --no-target-directory "$DIR/util" "$HOME/util"

mkdir -p "$HOME/data/nvim/session"
mkdir -p "$HOME/data/nvim/session"

git clone git@github.com:sgoranson/backup.git ~/backup

pkgs=(
        ripgrep npm userdirs alacritty dunst xkeysnail terminfo ranger compton dircolors 
        nvim polybar rofi i3 sway kitty git xorg tmux zsh yay mpv colorls termite geeqie xorg 
        )

pip install --user --upgrade 'python-language-server[all]'

sudo systemctl enable xlogin@steve  
