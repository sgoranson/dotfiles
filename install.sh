mkdir -p "$HOME/.local/share/steve"

mkdir -p  "$HOME/.cache/dein/repos/github.com/"

ln -i -s -f --backup=numbered "$HOME/.local/share/steve" "$HOME/data"
ln -i -s -f --backup=numbered "$HOME/dotfiles" "$HOME/dot"
ln -i -s -f --backup=numbered "$HOME/.config" "$HOME/cfg"

ln -i -s -f --backup=numbered "$HOME/.cache/dein/repos/github.com/" "$HOME/plugs"


