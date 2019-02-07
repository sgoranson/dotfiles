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
# export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/rg.conf
export GHQ_ROOT=$HOME/kewl

export MANPATH=":$HOME/.local/share/man"
# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath



path=("$HOME/.local/bin" "$HOME/bin/" "$HOME/mvp/" "$HOME/.pyenv/bin" "$HOME/go/bin" "$HOME/.node/bin/" "$HOME/.rbenv/bin" "$HOME/.cargo/bin/" "$HOME/.npm-global/bin/" "/usr/bin/core_perl" $path )
path=("$HOME/bin/color"  "/usr/local/bin"  "/usr/bin"    "/usr/local/sbin" "/bin" "/sbin"  $path )

export PATH
# if command -v rbenv &>/dev/null; then
#     eval "$(rbenv init -)"
#     source $HOME/.rbenv/completions/rbenv.zsh
# fi
#
# git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm  
# source ~/.zsh-nvm/zsh-nvm.plugin.zsh
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


