ZDOTDIR="$HOME/.zsh"

export EDITOR=nvim
export MYOS="ARCH"
export PAGER=less
export VISUAL=nvim
export MANPAGER=less
export TERMINAL=kitty
export BROWSER=chromium

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export CLICOLOR=1
export LESS="--ignore-case --RAW-CONTROL-CHARS --LONG-PROMPT --QUIET --jump-target=50 --status-column"
export PYENV_ROOT="$HOME/.pyenv"
# export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/rg.conf
export GHQ_ROOT=$HOME/kewl

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# PATH="$HOME/bin/:$HOME/go/bin:$HOME/.node/bin/:$HOME/.rbenv/bin:$HOME/.cargo/bin/:$HOME/.npm-global/bin/:/usr/bin/core_perl:$PATH"
# PATH="$HOME/bin/color:/usr/bin:/usr/local/sbin:/usr/local/bin:/bin:/sbin:$PATH"


path=("$HOME/bin/" "$HOME/.pyenv/bin" "$HOME/go/bin" "$HOME/.node/bin/" "$HOME/.rbenv/bin" "$HOME/.cargo/bin/" "$HOME/.npm-global/bin/" "/usr/bin/core_perl" )
path+=("$HOME/bin/color"  "/usr/bin"  "/usr/local/bin"    "/usr/local/sbin" "/bin" "/sbin" )


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
FZF_DEFAULT_OPTS+=' --bind "ctrl-y:execute(echo -n {} | xclip -selection clipboard)"  '
export FZF_DEFAULT_OPTS

export FZF_DEFAULT_COMMAND="locate --regex '.*'"
#
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
# --color=dark
# --color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
# --color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
# '


export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[7;49;93m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")



# mmm easy python versioning
#if command -v pyenv 1>/dev/null 2>&1; then
  # eval "$(pyenv init -)"
  # following line is sllllowwww
  #eval "$(pyenv virtualenv-init -)"
#fi

# if command -v nvim >/dev/null 2>&1; then
#     export MANPAGER=vless
#     export VISUAL=nvim
#     export PAGER=vless
#     export EDITOR=$VISUAL
# else
#     export MANPAGER=less
#     export VISUAL=vim
#     export EDITOR=$VISUAL
# fi
#### HIDPI stuff ####
# NOTE: it seems that xrdb dpi settings obviates the below
# fonts + screen
#export QT_SCALE_FACTOR=2
# just fonts
#export QT_SCREEN_SCALE_FACTORS=2

#export GDK_SCALE=2

# needed if you're gonna use qt5ct
# export QT_QPA_PLATFORMTHEME=qt5ct

# ~/.config/qt5ct/qt5ct.conf      for Qt5
# ~/.config/Trolltech.conf        for Qt4
# ~/.config/gtk-3.0/settings.ini  for Gtk3
# ~/.gtkrc-2.0                    for Gtk2
####

