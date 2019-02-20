#!env zsh

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
export  ENHANCD_FILTER=fzy 
export ENHANCD_COMMAND=cd

# Zplug init
#------------------------------------i
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update 
fi
source ~/.zplug/init.zsh
# zplug "b4b4r07/enhancd", use:init.sh, defer:3
# zplug "mollifier/anyframe"
zplug "plugins/extract",   from:oh-my-zsh, lazy:true
zplug "plugins/spectrum",   from:oh-my-zsh, lazy:true
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions', lazy:true
zplug "zsh-users/zsh-history-substring-search"
# zplug "jhawthorn/fzy", \
#     as:command, \
#     rename-to:fzy, \
#     hook-build:"make && sudo make install"

# zplug 'mafredri/zsh-async', from:github
# zplug 'sindresorhus/pure', use:pure.zsh, from:github, as:theme
# zplug "themes/robbyrussell", from:oh-my-zsh

if (( 1 )); then
zplug check || zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load 




# ZOPTIONS {{{
HISTSIZE=99999999
SAVEHIST=99999999

export HISTFILE=$XDG_CACHE_HOME/.zsh_history







autoload -U colors
colors
zmodload zsh/zpty

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data



setopt autocontinue         # disowned shit will continue 


setopt globdots
setopt   NOBEEP
setopt   NOCORRECTALL
setopt NO_HUP

setopt   IGNORE_EOF
setopt   AUTOCD
setopt   AUTOPUSHD
setopt   PUSHD_IGNORE_DUPS
setopt   PUSHDMINUS
setopt   PUSHDSILENT
setopt   PUSHDTOHOME
setopt   CDABLEVARS
setopt   EXTENDEDGLOB
unsetopt NOMATCH
unsetopt PRINT_EXIT_VALUE

setopt   PROMPTSUBST       # Allow for functions in the prompt.
setopt   PROMPTPERCENT

setopt   LONG_LIST_JOBS
setopt   MARK_DIRS         # Add "/" if completes directory
setopt   MAGIC_EQUAL_SUBST # Enable completion in "--option=arg"
setopt   NO_MENU_COMPLETE   # DO NOT AUTOSELECT THE FIRST COMPLETION ENTRY
setopt   NOFLOWCONTROL
setopt   AUTO_MENU         # SHOW COMPLETION MENU ON SUCCESIVE TAB PRESS
setopt   COMPLETE_IN_WORD
setopt   ALWAYS_TO_END
setopt   COMPLETEALIASES
setopt   AUTO_REMOVE_SLASH
# }}}

# LOAD RC's {{{
typeset -U fpath=("$ZDOTDIR/"{completion,themes} $fpath)


autoload -U promptinit && promptinit



# eval "$(fasd --init auto)"
# eval "$(cat "$ZDOTDIR/vividrc")"
#
if command -v vivid &>/dev/null; then
    export LS_COLORS="$(vivid generate ayu)"
else
    eval "$(dircolors "$HOME"/.dircolors)"
fi


# nodejs
# export NVM_LAZY_LOAD=true
# source ~/.zsh-nvm/zsh-nvm.plugin.zsh







#Set some zsh completion Options
#autoload -U compinit
#compinit -C
##Complete my dot files please
_comp_options+=(globdots)
#zmodload -i zsh/complist

source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/keys.zsh
source $ZDOTDIR/clipboard.zsh
source $ZDOTDIR/completion.zsh
# source $ZDOTDIR/i3_completion.sh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/completion/googler_at
source $ZDOTDIR/z.sh
# source $ZDOTDIR/anyenv.sh


# }}}




# DIRECTORY HISTORY {{{

DIRSTACKSIZE=20
DIRSTACKFILE=$XDG_CACHE_HOME/.zdirs
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
  ls --color=auto
}


if [[ -z "$ZSH_CDR_DIR" ]]; then
    ZSH_CDR_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-cdr
fi
mkdir -p $ZSH_CDR_DIR
autoload -Uz chpwd_recent_dirs cdr
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file $ZSH_CDR_DIR/recent-dirs
zstyle ':chpwd:*' recent-dirs-max 90
# fall through to cd
zstyle ':chpwd:*' recent-dirs-default yes



# }}}

# ETC {{{
umask 022

# get a prompt if ppl be loggin

# watch=all                       # watch all logins
# logcheck=30                     # every 30 seconds
# WATCHFMT="%n from %M has %a tty%l at %T %W"


if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# silly bash.org msg
# ruby -e 'require "open-uri"; puts open("http://bash.org/?random").read.match(/"qt">(.*?)<\/p/m)[1].gsub(/(&.*?;|<.*?\/>)/, "")'

#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable flow control (ctrl+s, ctrl+q) to enable saving with ctrl+s in Vim
stty -ixon -ixoff
# }}}



# if [ -f "$HOME/.zshmine" ]; then
#     . "$HOME/.zshmine"
# fi

if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0000000
  \e]P1ff5555
  \e]P250fa7b
  \e]P3f1fa8c
  \e]P46790eb
  \e]P5ff79c6
  \e]P68be9fd
  \e]P7bfbfbf
  \e]P879a9ff
  \e]P9ff6e67
  \e]PA5af78e
  \e]PBf4f99d
  \e]PC79a9ff
  \e]PDff92d0
  \e]PE9aedfe
  \e]PFe6e6e6
  "
  # get rid of artifacts
  clear
fi


# export DISPLAY=:0

# BANNER {{{

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#         eval "$("$BASE16_SHELL/profile_helper.sh")"


# cat ~/bin/ansi/esc.txt
cat ~/bin/ansi/cat.txt

#sgbanner

# }}}

prompt simpl

# Autostart if not already in tmux and enabled.
# if [[ -z "$TMUX" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" ]]; then
#     tmux new-session
# fi
# vim:fdm=marker:
