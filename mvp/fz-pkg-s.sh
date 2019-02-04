#!env zsh

function fzf-pkg() {
    if [[ -n $@ ]]  
    then
        result=$(yay -Ssq $@ | fzf --preview 'yay -Si {}')
    else
        result=$( \
            (
        curl https://aur.archlinux.org/packages.gz -o - 2> /dev/null | zcat;
        pacman -Slq;
            ) | sort | fzf --preview 'yay -Si {}')
    fi

    yay -Si $result
}

fzf-pkg $@

