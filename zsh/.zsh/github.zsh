alias gh-starred='curl -s "https://api.github.com/users/$USER/starred?per_page=1000"'
alias gh-repos='curl -s "https://api.github.com/users/$USER/repos?per_page=1000"'



# Set up hub wrapper for git, if it is available; https://github.com/github/hub
if (( $+commands[hub] )); then
  alias git=hub
fi

# Functions #################################################################

# Based on https://github.com/dbb/githome/blob/master/.config/zsh/functions

# empty_gh <NAME_OF_REPO>
#
# Use this when creating a new repo from scratch.
# Creates a new repo with a blank README.md in it and pushes it up to GitHub.
gh-init-repo() { # [NAME_OF_REPO]
  emulate -L zsh
  local repo=$1

  mkdir "$repo"
  touch "$repo/README.md"
  new_gh "$repo"
}

# new_gh [DIRECTORY]
#
# Use this when you have a directory that is not yet set up for git.
# This function will add all non-hidden files to git.
gh-init-add-create() { # [DIRECTORY]
  emulate -L zsh
  local repo="$1"
  cd "$repo" \
    || return

  git init \
    || return
  # add all non-dot files
  print '.*'"\n"'*~' >> .gitignore
  git add [^.]* \
    || return
  git add -f .gitignore \
    || return
  git commit -m 'Initial commit.' \
    || return
  hub create -p \
    || return
  git push -u origin master \
    || return
}

# exist_gh [DIRECTORY]
#
# Use this when you have a git repo that's ready to go and you want to add it
# to your GitHub.
gh-hub-create() { # [DIRECTORY]
    emulate -L zsh
    local repo=$1
    cd "$repo"

  hub create \
    || return
  git push -u origin master
}


export GH_STARS="$HOME/data/gh-starred.json"
export GH_REPOS="$HOME/data/gh-repos.json"
