#!/usr/bin/bash 


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p "$HOME/.local/share/steve"

mkdir -p  "$HOME/.cache/dein/repos/github.com/"

ln -i -s --no-target-directory  "$HOME/.local/share/steve" "$HOME/data"

ln -i -s --no-target-directory  "$HOME/.cache/dein/repos/github.com/" "$HOME/plugs"

ln -i -s --no-target-directory "$DIR/util" "$HOME/util"

mkdir -p "$HOME/data/nvim/session"


stow -R ripgrep
stow -R npm
stow -R userdirs
stow -R alacritty
stow -R dunst
stow -R xkeysnail
stow -R terminfo
stow -R ranger
stow -R compton
stow -R dircolors
stow -R nvim
stow -R polybar
stow -R rofi
stow -R i3
stow -R sway
stow -R kitty
stow -R git
stow -R xorg
stow -R tmux
stow -R zsh
stow -R yay
stow -R mpv
stow -R colorls
stow -R termite
