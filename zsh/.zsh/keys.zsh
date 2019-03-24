#!env zsh

bindkey -e
# zle -C most-accessed-file menu-complete _generic
if [[ "$TERM" == 'dumb' ]]; then
  return 1
fi

#
# Options
#

setopt BEEP                     # Beep on error in line editor.

#
# Variables
#

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Use human-friendly identifiers.
zmodload zsh/terminfo
typeset -gA key_info
key_info=(
  'Control'         '\C-'
  'ControlLeft'     '\e[1;5D \e[5D \e\e[D \eOd'
  'ControlRight'    '\e[1;5C \e[5C \e\e[C \eOc'
  'ControlPageUp'   '\e[5;5~'
  'ControlPageDown' '\e[6;5~'
  'Escape'       '\e'
  'Meta'         '\M-'
  'Backspace'    "^?"
  'Delete'       "^[[3~"
  'F1'           "$terminfo[kf1]"
  'F2'           "$terminfo[kf2]"
  'F3'           "$terminfo[kf3]"
  'F4'           "$terminfo[kf4]"
  'F5'           "$terminfo[kf5]"
  'F6'           "$terminfo[kf6]"
  'F7'           "$terminfo[kf7]"
  'F8'           "$terminfo[kf8]"
  'F9'           "$terminfo[kf9]"
  'F10'          "$terminfo[kf10]"
  'F11'          "$terminfo[kf11]"
  'F12'          "$terminfo[kf12]"
  'Insert'       "$terminfo[kich1]"
  'Home'         "$terminfo[khome]"
  'PageUp'       "$terminfo[kpp]"
  'End'          "$terminfo[kend]"
  'PageDown'     "$terminfo[knp]"
  'Up'           "$terminfo[kcuu1]"
  'Left'         "$terminfo[kcub1]"
  'Down'         "$terminfo[kcud1]"
  'Right'        "$terminfo[kcuf1]"
  'BackTab'      "$terminfo[kcbt]"
)

# copy the active line from the command line buffer 
# onto the system clipboard (requires clipcopy plugin)

copybuffer () {
    if which xclip &>/dev/null; then
        echo $BUFFER | xclip -selection clipboard
    else
        echo "get xclip son" >&2
    fi
}

zle -N copybuffer




# # Set empty $key_info values to an invalid UTF-8 sequence to induce silent
# # bindkey failure.
# for key in "${(k)key_info[@]}"; do
#   if [[ -z "$key_info[$key]" ]]; then
#     key_info[$key]='�'
#   fi
# done

#
# Functions
#
# Runs bindkey but for all of the keymaps. Running it with no arguments will
# print out the mappings for all of the keymaps.
function bindkey-all {
  local keymap=''
  for keymap in $(bindkey -l); do
    [[ "$#" -eq 0 ]] && printf "#### %s\n" "${keymap}" 1>&2
    bindkey -M "${keymap}" "$@"
  done
}

autoload -Uz edit-command-line
autoload -Uz copy-earlier-word
autoload -Uz smart-insert-last-word
autoload -Uz smart-insert-last-word
autoload -Uz insert-unicode-char
autoload -Uz run-help

zle -N run-help
zle -N edit-command-line
zle -N copy-earlier-word
zle -N insert-unicode-char
zle -N insert-last-word smart-insert-last-word


switch-to-dir () {
	setopt localoptions nopushdminus
	[[ ${#dirstack} -eq 0 ]] && return 1

	while ! builtin pushd -q $1 &>/dev/null; do
		# We found a missing directory: pop it out of the dir stack
		builtin popd -q $1

		# Stop trying if there are no more directories in the dir stack
		[[ ${#dirstack} -eq 0 ]] && return 1
	done
}

insert-cycledleft () {
	switch-to-dir +1 || return

	local fn
	for fn (chpwd $chpwd_functions precmd $precmd_functions); do
		(( $+functions[$fn] )) && $fn
	done
	zle reset-prompt
}
zle -N insert-cycledleft

insert-cycledright () {
	switch-to-dir -0 || return

	local fn
	for fn (chpwd $chpwd_functions precmd $precmd_functions); do
		(( $+functions[$fn] )) && $fn
	done
	zle reset-prompt
}
zle -N insert-cycledright











function where-widget() {
    zle kill-buffer
    local name=$(
    (
    print -l ${(ok)commands};
    print -l ${(ok)builtins};
    print -l ${(ok)functions};
    print -l ${(ok)aliases}
    ) | fzf --preview="whatis {} 2> /dev/null && echo; where {} 2> /dev/null")
    if [[ -n $name ]]
    then
        zle redisplay
        where $name && whatis $name 2> /dev/null && pacman -Qo $(whereis -b $name|cut -d' ' -f2)
        zle accept-line
    else
        zle reset-prompt
    fi
}
zle -N where-widget

## complete word from currently visible Screen or Tmux buffer.
function _complete_screen_display () {
    if ! [[ "$TERM" =~ "screen" ]]; then
        echo 'cant complete, bad $TERM'
        return 1
    fi

    local TMPFILE=$(mktemp)
    local -U -a _screen_display_wordlist
    trap "rm -f $TMPFILE" EXIT

    # fill array with contents from screen hardcopy
    if ((${+TMUX})); then
        tmux -V &>/dev/null || return
        # tmux -q capture-pane -e -b zshtmux  -S -50 \; save-buffer -b zshtmux $TMPFILE \; delete-buffer -b zshtmux
        tmux -q capture-pane -b zshtmux  \; save-buffer -b zshtmux $TMPFILE \; delete-buffer -b zshtmux
    else
        echo 'err. get tmux'
        return 1
    fi
    _screen_display_wordlist=( ${(QQ)$(<$TMPFILE)} )
    # remove PREFIX to be completed from that array
    _screen_display_wordlist[${_screen_display_wordlist[(i)$PREFIX]}]=""
    compadd -a _screen_display_wordlist
}

# CTRL-T - Paste the selected file path(s) into the command line
function  __fsel() {
    local FZF_CTRL_T_COMMAND='fd --hidden --exclude \*.git\* --search-path .'
    local cmd="${FZF_CTRL_T_COMMAND:-"command find -L / -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type f -print \
        -o -type d -print \
        -o -type l -print 2> /dev/null | cut -b3-"}"
            setopt localoptions pipefail 2> /dev/null
            eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
                echo -n "${(q)item} "
            done
            local ret=$?
            echo
            return $ret
        }

    __fzf_use_tmux__() {
        [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
    }

function  __fzfcmd() {
    __fzf_use_tmux__ &&
        echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
    }

function  fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fsel)"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}
zle     -N   fzf-file-widget



# CTRL-R - Paste the selected command from history into the command line
function  fzf-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
    selected=( $(fc -rl 1 | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-70%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
    local ret=$?
    if [ -n "$selected" ]; then
        num=$selected[1]
        if [ -n "$num" ]; then
            zle vi-fetch-history -n $num
        fi
    fi
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}
zle     -N   fzf-history-widget

function fzf-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf)
    if [ -n "$selected_dir" ]; then
        LBUFFER+="${selected_dir}"
    fi
}
zle -N fzf-cdr

function fzf-cdr2() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N fzf-cdr2



function  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
}

zle -N expand-or-complete-with-dots

function  rationalise-dot() {
    local MATCH # keep the regex match from leaking to the environment
    if [[ $LBUFFER =~ '(^|/| |      |'$'\n''|\||;|&)\.\.$' && ! $LBUFFER = p4* ]]; then
        #if [[ ! $LBUFFER = p4* && $LBUFFER = *.. ]]; then
            LBUFFER+=/..
        else
            zle self-insert
        fi
    }
zle -N rationalise-dot

function expand-function() {
    local func=${LBUFFER// /}
    if (( ${+functions[$func]} )); then
        LBUFFER="${functions[$func]}"
        zle redisplay
    fi
}
zle -N expand-function

function  insert-widget() {
    local target="$(locate -Ai -0 / | grep -z -vE '~$' | fzf --read0 -0 -1 --preview 'tree -C {} | head -200')"
    if [[ -n $target ]]
    then
        LBUFFER+="$target "
        zle redisplay
    else
        zle redisplay
    fi
}
zle -N insert-widget


function grml-zsh-fg () {
    if (( ${#jobstates} )); then
        zle .push-input
        [[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
        BUFFER="${BUFFER}fg"
        zle .accept-line
    else
        zle -M 'No background jobs. Doing nothing.'
    fi
}
zle -N grml-zsh-fg


typeset -a ealiases
ealiases=()

function ealias()
{
    alias $1
    ealiases+=(${1%%\=*})
}

function expand-ealias()
{
    if [[ $LBUFFER =~ "\<(${(j:|:)ealiases})\$" ]]; then
        zle _expand_alias
        zle expand-word
    fi
    zle magic-space
}

zle -N expand-ealias

bindkey -M emacs ' '        expand-ealias
bindkey -M emacs '^ '       magic-space     # control-space to bypass completion
bindkey -M isearch " "      magic-space     # normal space during searches

ealias gc='git commit'
ealias gp='git push'



# Duplicate the previous word.
bindkey  "$key_info[BackTab]" reverse-menu-complete
bindkey "$key_info[Control]g" undo
bindkey "$key_info[Control]_" redo

# bindkey '^Xh' _complete_help
# bindkey '^A'   beginning-of-line
# bindkey '^E'   end-of-line
bindkey "^[h" insert-cycledleft
bindkey "^[l" insert-cycledright

bindkey '^H'   backward-char
bindkey '^I'   expand-or-complete-with-dots
bindkey '^L'   forward-char
bindkey '^M'   accept-line
bindkey '^N'   history-substring-search-down
bindkey "^O"   copybuffer
bindkey '^P'   history-substring-search-up
bindkey '^R'   fzf-history-widget
bindkey '^Z'   grml-zsh-fg
bindkey '^[,'  copy-earlier-word
bindkey "^[c" copy-prev-shell-word  
bindkey '^[.'  insert-last-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^j'   backward-word
bindkey '^k'   forward-word
bindkey '^tg'  fzf-qhq
bindkey '^tl'  insert-widget
bindkey '^tw'  where-widget
bindkey '^d' fzf-cdr2
bindkey '^xd' fzf-cdr
bindkey '^xe'  edit-command-line
bindkey '^xf'  expand-function
bindkey '^xh'  run-help
bindkey '^xr'  history-incremental-search-backward
bindkey '^xu'  insert-unicode-char
# bindkey -s     '^xg' ' 2>&1 '
bindkey .      rationalise-dot
bindkey -M     isearch . self-insert

compdef -k     _complete_screen_display complete-word '^xs'
