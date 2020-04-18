# alias gh-starred='cat ~/backup/gh-starred.json| jq  -r '\''"\(.html_url),\(.description)"'\'' '

function gh-starred-fresh() {

    STARS=$(curl -sI https://api.github.com/users/sgoranson/starred?per_page=1 | 
        grep -Pi '^Link'| grep -Po 'page=[0-9]+' | tail -1 |cut -c6-)
    PAGES=$(($STARS/100+1))

    echo "You have ${STARS?curl api fucked up} starred repositories."
    echo

    for PAGE in $(seq $PAGES); do
        command curl -sH "Accept: application/vnd.github.v3.star+json" "https://api.github.com/users/sgoranson/starred?per_page=100&page=$PAGE" | 
            command jq -r '.[]|[.starred_at,.repo.full_name,.repo.description]|@tsv' |
            command column -t -s $'\t' -c 120 
    done | tee ~/backup/gh-starred.txt

}


function gh-starred-cached() { 
    cat ~/backup/gh-starred.txt
}



# Set up hub wrapper for git, if it is available; https://github.com/github/hub

    if (( $+commands[hub] )); then
        alias git=hub
    fi


    gh-init-and-push() { # [DIRECTORY]
    emulate -L zsh
    local repo="${1?gimme a repo name}"

    git init || return

    echo "$1 new repo" > readme.md || return
    git add . || return
    git commit -m 'Initial commit.' || return
    hub create -p || return

    git push -u origin master || return
}


export GH_STARS="$HOME/data/gh-starred.json"
export GH_REPOS="$HOME/data/gh-repos.json"
