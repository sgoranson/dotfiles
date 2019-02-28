# Require
# ghq: https://github.com/motemen/ghq
# ghs: https://github.com/sona-tar/ghs

# ghq get + ghq look(cd repo)
# Usage: gcd git://example.com/repo.git
function gcd {
  if [ ! -n "$1" ]; then
    echo "Usage: gcd git://example.com/repo.git"
    return;
  fi
  local url=$1;
  ghq-get-look "${url}"
}

function ghq-get-look() {
  local url=$1
  local url=$(echo ${url} | sed -e 's/.git$//')
  local repo=$(echo ${url} | awk -F/ '{print $(NF-1)"/"$NF}');
  local removeGitURL=$(echo ${repo} | awk -F: '{print $NF}');
  echo "Repo:${removeGitURL}"
  ghq get "${url}.git" --update
  ghq look "${removeGitURL}"
}

# like autojump and z.sh in ghq
function peco-ghq-src () {
  local prompt="cd >"
  local selected_dir=$(ghq list -p | peco --prompt=${prompt} --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq-src
bindkey '^x@' peco-ghq-src


function ghs-pull-own() {
  local selected_repo=$(ghs --sort=updated -u="`git config user.name`" "$1" | peco --query "$LBUFFER" | awk '{print $1}')
  if [ -n "$selected_repo" ]; then
    ghq-get-look ${selected_repo}
  fi
}
# GitHubの自分のリポジトリを選んで、ghq get + ghq look
function peco-ghs-own (){
  echo "Getting from Github..."
  local selected_repo=$(ghs --sort=updated -u="`git config user.name`" "$1" | peco --query "$LBUFFER" | awk '{print $1}')
  if [ -n "$selected_repo" ]; then
    BUFFER="gcd ${selected_repo}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-ghs-own
bindkey '^x]' peco-ghs-own


# 現在のディレクトリのプロジェクトをghqでgetし直して移動する
function ghq-convert() {
  gcd "$(git config --get remote.origin.url)"
}
# プロジェクトを選んで削除する
function ghq-remove() {
  ghq list --full-path | peco | xargs rm -r
}
# ghqにディレクトリを作って移動
function mkdev(){
  if [ ! -n "$1" ]; then
    echo "Usage: mkdev dir-name"
    return;
  fi
  local dirName=$1
  local rootDir=$(ghq root)
  local githubUser="github.com/$(git config user.name)"
  local devPath="${rootDir}/${githubUser}/${dirName}"
  mkdir -p ${devPath}
  cd ${devPath}
}
