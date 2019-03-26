#!/usr/bin/env zsh
#
alias gh-curl-starred='curl -s "https://api.github.com/users/$USER/starred?per_page=1000"'
alias gh-curl-repos='curl -s "https://api.github.com/users/$USER/repos?per_page=1000"'

# alias gh-starred='cat ~/backup/gh-starred.json| jq  -r '\''"\(.html_url),\(.description)"'\'' '
alias gh-starred='cat ~/backup/gh-starred.json| jq -s  -r '\'' .[] | .[] |  [  .html_url, .description ] | @tsv'\'' '


function gh-search-repo() {
    curl 'https://api.github.com/search/repositories?q=iotop&sort=stars&order=desc' | jq  -c '.items[] |  .html_url,.description,.stargazers_count,.language ' 
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
