mkdir -p "$HOME/.local/share/steve"

ln -i -s -f --backup=numbered "$HOME/.local/share/steve" "$HOME/data"
ln -i -s -f --backup=numbered "$HOME/dotfiles" "$HOME/dot"
ln -i -s -f --backup=numbered "$HOME/.config" "$HOME/cfg"

