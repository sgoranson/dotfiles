ZDOTDIR="$HOME/.zsh"

export EDITOR=nvim
export MYOS="ARCH"
export PAGER=bat
export VISUAL=nvim
export MANPAGER="nvim -c 'set ft=man' -"   
export TERMINAL=kitty
export BROWSER='google-chrome-stable --new-window'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export CLICOLOR=1
export LESS="--ignore-case --RAW-CONTROL-CHARS --LONG-PROMPT --QUIET --jump-target=50 --status-column"
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config
export GHQ_ROOT=$HOME/kewl
export TODO_DIR=$HOME/Dropbox/todo
export TODOTXT_CFG_FILE=$HOME/Dropbox/todo/config

export MANPATH=":$HOME/.local/share/man"
# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath



path=("$HOME/.local/bin" "$HOME/bin/" "$HOME/mvp/"  "$HOME/go/bin" "$HOME/.node/bin/" "$HOME/.rbenv/bin" "$HOME/.cargo/bin/" "$HOME/.npm-global/bin/" "/usr/bin/core_perl" $path )
path+=("$HOME/bin/color"  "/usr/local/bin"  "/usr/bin"    "/usr/local/sbin" "/bin" "/sbin"   )

# Lazy load rbenv {{{
#  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
#


if [[ ! -d $HOME/.rbenv ]]; then
    printf '\e[30;44minstalling rbenv...'
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash 
fi

if type rbenv &> /dev/null; then
  local RBENV_SHIMS="${RBENV_ROOT:-${HOME}/.rbenv}/shims"
  export PATH="${RBENV_SHIMS}:${PATH}"
  source $HOME/.rbenv/completions/rbenv.zsh
  function rbenv() {
    unset -f rbenv > /dev/null 2>&1
    eval "$(command rbenv init -)"
    rbenv "$@"
  }
fi

# }}}

# lazy pyenv {{{
# curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# Try to find pyenv, if it's not on the path
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
export PYROOT="/home/steve/.pyenv/versions/miniconda3-latest/"
if ! type pyenv > /dev/null && [ -f "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

# Lazy load pyenv
if type pyenv > /dev/null; then
    export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
    function pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        pyenv $@
    }
fi
# function pyroot() { $(pyenv prefix) }

# }}}

export PATH
#
# curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
#
#  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
# curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash 

# if which ruby >/dev/null && which gem >/dev/null; then
#     PATH="$PATH:$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:"
# fi
#export PATH


export HISTIGNORE="ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."

# export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export GIT_PROMPT_EXECUTABLE=${GIT_PROMPT_EXECUTABLE:-"python"}
export TMUX_TMPDIR="$XDG_CACHE_HOME"

FZF_DEFAULT_OPTS=' --multi --cycle --ansi   --exact --no-mouse '
FZF_DEFAULT_OPTS+=' --color=bg+:#263238,fg:246,fg+:#C678DD '
FZF_DEFAULT_OPTS+=' --bind="ctrl-y:execute-silent:echo -n {} | xclip -selection clipboard"  '
export FZF_DEFAULT_OPTS

export FZF_DEFAULT_COMMAND="locate --regex '.*'"


export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[7;49;93m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")


