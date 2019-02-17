#!/usr/bin/bash 


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
exit

mkdir -p "$HOME/.local/share/steve"

mkdir -p  "$HOME/.cache/dein/repos/github.com/"

ln -i -s --no-target-directory  "$HOME/.local/share/steve" "$HOME/data"
ln -i -s --no-target-directory  "$HOME/dotfiles" "$HOME/dot"
ln -i -s --no-target-directory  "$HOME/.config" "$HOME/cfg"

ln -i -s --no-target-directory  "$HOME/.cache/dein/repos/github.com/" "$HOME/plugs"

mkdir -p "$HOME/data/nvim/session"

./stow-it.sh 

