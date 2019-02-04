#!env bash

set +o pipefail
function zsh_color_list() { # 256 colors available on zsh, not used in production since these are not common
	for code in {0..255}; do
		echo -e "\e[38;5;${code}m"'\\e[38;5;'"$code"m"\e[0m"
	done
}

ret="$(zsh_color_list | fzf)"

if [[ ! -z $ret ]]; then
    echo "$ret" | xclip -selection clipboard
fi
