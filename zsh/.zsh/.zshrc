#!env zsh

# . /usr/share/zsh/share/antigen.zsh
. ~/.zsh/share/antigen.zsh
# antigen use oh-my-zsh
# antigen bundle pip
# antigen theme miekg/lean
antigen bundle mafredri/zsh-async
# antigen bundle https://github.com/maximbaz/spaceship-prompt 
# antigen theme sinetoami/purien
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle b4b4r07/enhancd

antigen bundle momo-lab/zsh-abbrev-alias
antigen bundle davidparsson/zsh-pyenv-lazy

antigen apply


# ZOPTIONS {{{
HISTSIZE=99999999
SAVEHIST=99999999

export HISTFILE=$XDG_CACHE_HOME/.zsh_history



autoload -U colors
colors

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
# setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt no_hist_ignore_dups       # ignore duplicated commands history list
setopt no_hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
# setopt share_history          # share command history data



setopt autocontinue         # disowned shit will continue 


setopt globdots
setopt   NOBEEP
setopt   NOCORRECTALL
setopt NO_HUP

setopt   IGNORE_EOF
setopt   AUTOCD
setopt   AUTOPUSHD
setopt   PUSHD_IGNORE_DUPS
setopt   NOPUSHDMINUS
setopt   PUSHDSILENT
setopt   PUSHDTOHOME
setopt   CDABLEVARS
setopt   EXTENDEDGLOB
unsetopt NOMATCH
unsetopt PRINT_EXIT_VALUE

setopt   PROMPTSUBST       # Allow for functions in the prompt.
setopt   PROMPTPERCENT

setopt   LONG_LIST_JOBS
setopt   MARK_DIRS          # Add "/" if completes directory
setopt   MAGIC_EQUAL_SUBST  # Enable completion in "--option=arg"
setopt   NO_MENU_COMPLETE   # DO NOT AUTOSELECT THE FIRST COMPLETION ENTRY
setopt   NOFLOWCONTROL
setopt   AUTO_MENU          # SHOW COMPLETION MENU ON SUCCESIVE TAB PRESS
setopt   COMPLETE_IN_WORD
setopt   ALWAYS_TO_END
setopt   COMPLETEALIASES
setopt   AUTO_REMOVE_SLASH
# }}}

# LOAD RC's {{{
typeset -U fpath=("$ZDOTDIR/"{completion,themes} $fpath)





# nodejs
# export NVM_LAZY_LOAD=true
# source ~/.zsh-nvm/zsh-nvm.plugin.zsh


#Set some zsh completion Options
autoload -U compinit && compinit -D

autoload -U +X bashcompinit && bashcompinit
##Complete my dot files please

_comp_options+=(globdots)
#zmodload -i zsh/complist

source $ZDOTDIR/keys.zsh
source $ZDOTDIR/clipboard.zsh
source $ZDOTDIR/completion.zsh
# source $ZDOTDIR/i3_completion.sh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/arch.zsh
source $ZDOTDIR/github.zsh
source $ZDOTDIR/completion/googler_at
# source $ZDOTDIR/z.sh
source $ZDOTDIR/zsh-history-substring-search.zsh
source $ZDOTDIR/zsh-autosuggestions.zsh
source $ZDOTDIR/extract.plugin.zsh
source $ZDOTDIR/base16-oxide
source $ZDOTDIR/prompt.zsh
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh


# source $ZDOTDIR/anyenv.sh
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=4,fg=0'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=9,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=''
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=''
if [[ $TERM == linux ]]; then
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
else
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
fi

export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
	forward-char
	end-of-line
	vi-forward-char
	vi-end-of-line
	vi-add-eol
    magic-space
)

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

  # if (( $+commands[ls_extended] )); then
  #     ls_extended -As 
  # else
  #
  # fi
  command ls --almost-all --group-directories-first --file-type --color=auto 



}


if [[ -z "$ZSH_CDR_DIR" ]]; then
    ZSH_CDR_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-cdr
fi
mkdir -p $ZSH_CDR_DIR
autoload -Uz chpwd_recent_dirs cdr
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
add-zsh-hook -Uz zsh_directory_name zsh_directory_name_cdr
zstyle ':chpwd:*' recent-dirs-file $ZSH_CDR_DIR/recent-dirs
zstyle ':chpwd:*' recent-dirs-max 80
# zstyle ':chpwd:*' recent-dirs-prune parent
# fall through to cd
zstyle ':chpwd:*' recent-dirs-default yes

# }}}
#
# GPG {{{
# AGENT_SOCK=$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)

# if [[ ! -S $AGENT_SOCK ]]; then
#   gpg-agent --daemon --use-standard-socket &>/dev/null
# fi
# export GPG_TTY=$TTY
GPG_TTY=$(tty)
export GPG_TTY
# }}}
#
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




# if [ "$TERM" = "linux" ]; then
#   /bin/echo -e "
#   \e]P0000000
#   \e]P1ff5555
#   \e]P250fa7b
#   \e]P3f1fa8c
#   \e]P46790eb
#   \e]P5ff79c6
#   \e]P68be9fd
#   \e]P7bfbfbf
#   \e]P879a9ff
#   \e]P9ff6e67
#   \e]PA5af78e
#   \e]PBf4f99d
#   \e]PC79a9ff
#   \e]PDff92d0
#   \e]PE9aedfe
#   \e]PFe6e6e6
#   "
#   # get rid of artifacts
#   clear
# fi
 if [ "$TERM" = "linux" ]
then
    echo -en "\e]P0222222" #black
    echo -en "\e]P8272822" #darkgrey
    echo -en "\e]P1aa4450" #darkred
    echo -en "\e]P9ff6a6a" #red
    echo -en "\e]P2719611" #darkgreen
    echo -en "\e]PAb1d631" #green
    echo -en "\e]P3ff9800" #brown
    echo -en "\e]PB87875f" #yellow
    echo -en "\e]P46688aa" #darkblue
    echo -en "\e]PC90b0d1" #blue
    echo -en "\e]P58f6f8f" #darkmagenta
    echo -en "\e]PD8181a6" #magenta
    echo -en "\e]P6528b8b" #darkcyan
    echo -en "\e]PE87ceeb" #cyan
    echo -en "\e]P7d3d3d3" #lightgrey
    echo -en "\e]PFc1cdc1" #white
    clear #for background artifacting
fi


# export DISPLAY=:0

# BANNER {{{

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#         eval "$("$BASE16_SHELL/profile_helper.sh")"

if command -v vivid &>/dev/null; then
    export LS_COLORS="$(vivid generate ayu)"
else
    eval "$(dircolors "$HOME"/.dircolors)"
fi
LS_COLORS+=":ow=0;38;2;27;125;196"


# cat ~/bin/ansi/esc.txt
cat ~/bin/ansi/cat.txt

#sgbanner

# }}}


# Autostart if not already in tmux and enabled.
# if [[ -z "$TMUX" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" ]]; then
#     tmux new-session
# fi
# vim:fdm=marker:
