alias gh-starred='curl -s "https://api.github.com/users/$USER/starred?per_page=1000"'
alias gh-repos='curl -s "https://api.github.com/users/$USER/repos?per_page=1000"'

export GH_STARS="$HOME/data/gh-starred.json"
export GH_REPOS="$HOME/data/gh-repos.json"
