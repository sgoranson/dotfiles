#!/usr/bin/env zsh
#
alias gh-curl-starred='curl -s "https://api.github.com/users/$USER/starred?per_page=1000"'
alias gh-curl-user-repos='curl -s "https://api.github.com/users/$USER/repos?per_page=1000"'

function gh-search-repo() {
    curl  'https://api.github.com/search/repositories?q=hashcat&sort=stars&order=desc' | 
        tee /tmp/x.json  | 
        jq -r   ' .items | .[] | [ .stargazers_count,.full_name,.description ]| @tsv' | 
        column -t --separator=$'\t' -T 3
}


# alias gh-starred='cat ~/backup/gh-starred.json| jq  -r '\''"\(.html_url),\(.description)"'\'' '
alias gh-starred='cat ~/backup/gh-starred.json| jq -s  -r '\'' .[] | .[] |  [  .html_url, .description ] | @tsv'\'' '



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
