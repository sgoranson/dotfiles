#!env zsh

function fzf-ghq() {
    # local file="$(ghq list | fzf --preview 'tree -C {} | head -200')"
    local file="$(print -rl --  ${GHQ_ROOT}/github.com/*/*(om)   | fzf --no-sort --preview-window=right:50% --preview "\rg --iglob='readme*'  --files  {}/   | xargs bat --color=always ")"
    # file="$GHQ_ROOT/$file"
    if [[ -n $file ]]
    then
        if [[ -d $file ]]
        then
            cd -- "$file"
        else
            # cd -- "${file:h}"
            print -P -- "%F{9}%K{0}$file doesnt exist %f"
        fi
    fi
}

fzf-ghq $@
