# reset them all
# unalias -m '*'


# abbrev-alias -i
alias -g G=' | grep -i'
alias -g F=' | fzf'
alias -g H=' | head'
alias -g HL='--help |& less'
alias -g C=' | xclip -r -selection clipboard -i'
alias -g L=' | less'



alias vim=nvim
alias b=bat
alias p=print
alias c=cat
alias nvv="nvim +'cd ~/.dot' +':Denite file_mru/git'"
alias nva='nvim ~/.zsh/aliases.zsh'


alias ff="fd --hidden --exclude '.git' --search-path ."
alias lst='tree -a'

alias zsa='source ~/.zsh/aliases.zsh && print -P "%F{cyan}aliased reloaded" >&2'


# GLOBAL {{{1
alias r=ranger
alias RM=trash
alias CM='chmod a+x'
alias AX='chmod a+x'
alias chrome-lodpi='GDK_DPI_SCALE=0.5 google-chrome-stable'
alias chrome='google-chrome-stable --new-window'
alias web='google-chrome-stable --new-window'

alias ls="\ls --almost-all --group-directories-first --file-type --color=auto"
alias ll="\ls -l --almost-all --group-directories-first --file-type --color=auto"
alias lss="\ls -l --almost-all --group-directories-first --file-type --color=auto --human-readable --sort=size --reverse"
alias lst="\ls -l --almost-all --group-directories-first --file-type --color=auto --human-readable --sort=time --reverse"
if (( $+commands[colorls] )); then
    alias cls='colorls -Al --sd --sort=time --reverse'
fi
# if (( $+commands[ls_extended] )); then
#     alias ls='ls_extended -As'
#     alias ll='ls_extended -Alsh'
# fi

# alias ls="colorls --almost-all"
# alias lsg="colorls --almost-all --group-directories-first"
# alias ll="colorls -lAtr"
alias pu="pushd"
alias po="popd"
# alias ff="\rg --color=auto --hidden --files"
alias gs="git status"

alias ps-top-cpu='ps aux | head -1; ps aux | sort -rn +2 | head -10'
alias ps-top-mem='ps aux | head -1; ps aux | sort -rn +3 | head -10'

alias pss="ps -aef --sort=start_time | awk '\$3 != 2'"
alias psst='sudo ps axjf'
alias psl='ps wwaxo pid,ppid,stat,args --sort=start_time'

# cron dont like backupfiles
alias crontab="VIM_CRONTAB=true crontab"
alias cp="cp -i"
alias cp!="command rsync --progress"
alias rm="rm -i"
if (( $+commands[trash] )); then
    alias rm=trash
fi
alias ln="ln -i"
# alias tmux="TERM=xterm-256color \tmux"
alias grep='grep --color=auto'
# -b ignore blanks -B ignore newlines
# alias diff="diff -ybB"
alias diff='icdiff'

alias 16=xterm_16.sh
alias 256=xterm_256.sh

if command -v cdu >/dev/null 2>&1; then
    # -i smart colors, -s sort by size, -R recurse, -dh human readable
    alias cdu="cdu -i -sR -dh"
    alias du="cdu -i -sR -dh"
fi

if command -v dfc >/dev/null 2>&1; then
    alias df=dfc
fi

alias a1="awk '{ print \$1}'"
alias a2="awk '{ print \$2}'"
alias a3="awk '{ print \$3}'"
alias a4="awk '{ print \$4}'"
alias a5="awk '{ print \$5}'"


alias PI="pip install --user --upgrade"
alias PS="pip search"
alias PL="pip list"

# NI() {
#     sudo npm -g install  ${1:?}
#     if [ $? -eq 0 ]; then
#         if ! grep -Eq "^${1}$" "$HOME/dotfiles/install/pkg-lists/npm.txt" ; then
#             echo $1 >> "$HOME/dotfiles/install/pkg-lists/npm.txt"
#         fi
#     fi
# }
alias NI="npm -g install"
alias NR="npm -g uninstall"
alias NS="npm search -l"
alias NL="npm list -g --depth=0 2>/dev/null"

alias GI="gem install --user-install"
alias GLL="gem list --local"
alias GL="gem contents"

alias SGG='echo tert.havkwhaxvr@arg | tr a-z@. n-za-m.@'

# dir shortcuts
alias ddot="pu ~/dotfiles"

a() { awk "{ print \$${1:-0} }" } # shortcut for awk '/ print $1/'
    hh() { $1 --help | vless }
    hex2dec() { perl -e "print hex $1" }
    dec2hex() { printf "%x\n" $1 }

# no file --no-heading, search --hidden, -uu ignore nvc ignores, follow syms -f, smartcase -S
if command -v rg >/dev/null 2>&1; then
    alias rgg="\rg  --no-filename --no-line-number"
    # alias rg="\rg --no-heading --hidden"
    alias rgf="\rg --files"
fi

# cheat sheets
alias cheatsh='curl cheat.sh'


alias pkg-config="pkg-config  --keep-system-libs  --keep-system-cflags"

# no file --noheading, search --hidden, -U ignore nvc ignores, follow syms -f, smartcase -S
#alias ag='ag --noheading --hidden -U -f -S'

# handy tag command. makes rg sourcecode searching easy
if (( $+commands[tag] )); then
    tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
    alias ag=tag
fi


alias AS="yay --color=auto -Ss"
alias ASS="pacman -Ss --color=auto"
alias AL="yay --color=auto -Ql --noconfirm"
alias AR="yay --color=auto -R"
alias AF="pkgfile"
alias AU="yay --needed --color=auto -Syu"
alias AI="yay --noconfirm --needed --color=auto -S"
alias AD="yay  --color=auto -Si"

# AD() { yaourt -Qi ${1:?} | grep Depends | cut -d: -f2 }
 compdef _pacman_completions_all_packages AI=yay
 compdef _pacman_completions_all_packages AL=yay
 compdef _pacman_completions_all_packages AS=yay
 _yay &>/dev/null

alias netstat-listening='sudo ss -lptu'
alias calc=pcalc

alias svc='sudo systemctl'
alias svcj='sudo journalctl -xe'
compdef _systemctl svc=systemctl
compdef _systemctl svcj=journalctl

alias svst='sudo systemctl status'
alias sv0='sudo systemctl stop'
alias sv1='sudo systemctl start'
compdef _systemctl svst=systemctl
compdef _systemctl sv1=systemctl
compdef _systemctl sv0=systemctl


alias svc-u='systemctl --user'
alias svc-u-reload='systemctl --user daemon-reload'


    # -i interfaces. shows packets/sec
    alias netstat-bps="netstat -i"
    # -l listen -p PID -t TCP -u UDP -W wide
    alias netstat-listen='sudo netstat -l -p -t -u -W'

    alias route-print='route'



    alias rpi-gpu='/opt/vc/bin/vcgencmd  get_mem gpu'
    alias rpi-temp='/opt/vc/bin/vcgencmd  measure_temp'

# }}}
#
# ALIAS ARG HELPERS {{{1
alias adb-ls-pkgs='adb shell pm list packages'
alias adb-shell-two='adb -s firetv:5555 shell'
alias adb-log-warn='adb logcat *:W'

alias arp-subnet='arp -a'

alias cP='rsync --progress'

alias column='column -t --separator=$'\t' -T 3'
alias curl-moz="curl -L -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'"

# -d draw title -S sort files
alias feh-sort='feh --cache-size 2048  --auto-zoom --full-screen  --draw-filename --sort  filename .'

# 0: CCW + vflip 1: 90C 2: 90CCW 3: 90CW + vflip   2,2: 180deg
alias ffmpeg-rotate='ffmpeg -i in.mov -vf "transpose=1" out.mov'
alias ffmpeg-quality='ffmpeg -i in.avi -c:a copy -c:v libx264 out.avi'
alias ffmpeg-resize='ffmpeg -i in.mp4 -vf scale=320:-1 out.mp4'

alias find-recent-mod='find -cmin -5'
alias find-images="find ~+ -type f -exec file -i '{}' \; | tee /tmp/findx | grep image | cut -d: -f1"
# %p is the relpath, %T@ is unixtime. so very sortable. %t is simple ctime
alias find-print-tlm='find . -type f -printf "%T@ %p\n"'
alias find-most-files="du --inodes -S | sort -h"
alias fc-list-sort='fc-list | cut -d: -f2,3 | sort'
alias fc-cache='fc-cache -f -v'

alias ghs='ghs --sort=votes'
alias gpg-fingerprint='gpg --verbose --fingerprint'
alias gpg-ls='gpg --list-keys'
alias gpg-export='gpg --armor --export'
alias gpg-encrypt='gpg --recipient PUBLIC-KEY-O-RECIPIANT --armor --output out.asc --encrypt file.txt'
alias gpg-decrypt='gpg --decrypt'
alias gpg-verify='gpg --verify file.sig'
alias gpg-sign='gpg --sign --default-key MY_PRIVATE_KEY_EMAIL --armor'
alias gpg-clearsign='gpg --clearsign --default-key MY_PRIVATE_KEY_EMAIL --armor'
alias gpg-detachsign='gpg --detach-sign --default-key MY_PRIVATE_KEY_EMAIL --armor'
alias gpg-editkey='gpg --edit-key'

alias grep-url="perl -ne '/(https?:\/\/.*?\/.*?\/.*?\/)/ && print \"\$1\n\"'"
alias grep-unicode="ag --nocolor \"[\x80-\xFF]\""

alias httrack-moz='httrack --display -F '\''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'\'

alias im=i3-msg

alias ip-external='curl ipinfo.io/ip'
alias iptables-ls='sudo iptables-save'

alias ip-up='sudo ip link set up dev'
alias ip-add='sudo ip a add 192.168.1.2/24 dev wlp3s0'
alias ip-flush='sudo ip addr flush dev enp0s25'
alias ip-route-add='sudo ip route add 172.16.5.0/24 via 10.0.0.101 dev eth0'
alias ip-stats='ip -h -s addr'

alias json-pp='python -mjson.tool'

alias locate-filename='locate -r "\/'
alias locate-all="locate --regex '.*'"

alias ls-uuid='ls -al /dev/disk/by-uuid'

alias lsof-pid='sudo lsof -p'
# -P no port names
alias lsof-listen='sudo lsof -iudp -itcp -stcp:listen -P'

alias ngrep-http="sudo ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"

# open ports on subnet. defaults to quick arp
alias nmap-subnet-quick='nmap 192.168.3.0/24'
# -A  = -O OS detection -sV version scanning -sC script scanning --traceroute
alias nmap-host-heavy='nmap -A 192.168.3.2'
# -s scantype -T tcp connect. better netstat
alias nmap-listen='sudo nmap -sT  localhost'
alias nmap-all-ports='sudo nmap -p- localhost'
# -sV version detection -sC default scripts
alias nmap-versions='sudo nmap -sV -sC localhost'

alias pandoc-epub2pdf="pandoc -f epub -t latex  --latex-engine=xelatex blah.epub -o"
alias od="od --format=x1caz"


alias python-dbg='python -m trace --trace'
alias python-webserver='python3 -m http.server'

alias rand-sh='echo $(( $(head -c 2 /dev/random | od -i  -An) % 10 ))'

alias xclipc='xclip -selection clipboard'
alias xclipp='xclip -selection clipboard -o'


# -r recurse -v verbose -a archive mode (checks TLM) -h human readable -z compression
alias rsync-basic='rsync -rvahz --progress'

alias reflector='sudo Reflector.py --verbose --country 'United States' -l 200 -p http -p https --sort rate --save /etc/pacman.d/mirrorlist'
alias smb-ls-local='sudo smbclient -L eth0 -I localhost'
alias smb-ls-host='sudo smbclient -L hostx -I 192.168.3.3'
alias smb-ls-net='nmblookup -S WORKGROUP'
alias smb-mount='sudo mount -t cifs -o username=steve //stinkpc/complete ./stinkpc'

alias sed-strip-ansi='sed "s/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g"'

alias sshfs-umount='fusermount3 -u'
alias sshfs-basic='sshfs alarm@alarmpi:  ~/mnt/alarm'

alias ss-listening='sudo ss -lptu'
alias term-set-title='echo -ne "\e]0;$(hostname)\a"'

alias thumbnail-gen='mogrify -verbose -path thumbs/256  -thumbnail 256x256^ *(.)'

alias tmux-ls-keys='tmux list-keys'
alias tmux-window-hostname='tmux rename-window "$(hostname -s)"'

alias ttycast="ttyd -p 8888 bash -c 'tmux new-session -d -s cast \; split-window -d \; attach -t cast'"

alias url-decode='python -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));"'
alias url-encode='python -c "import sys; from urllib.parse import quote; print(quote(sys.stdin.read()));"'

alias useradd='sudo command useradd -m -s /bin/zsh -G adm,systemd-journal,wheel,rfkill,games,network,video,audio,optical,floppy,storage,scanner,power'

alias virt-install-arch='virt-install --name arch-linux_testing4 --memory 2024 --vcpus=2,maxvcpus=4 --cpu host --cdrom /home/steve/Downloads/archlinux-2019.02.01-x86_64.iso --disk size=10,format=qcow2 --network user --virt-type kvm'
alias vnc-x11="sudo x11vnc -rfbauth /home/steve/.vnc/passwd  -auth guess  -geometry 1920x1080  -display :0"
alias vnc-kill="vncserver -kill :1"
alias vnc-nopasswd="vncserver :6 -SecurityTypes None  -geometry 2000x950"

alias wifi-scan='sudo iwlist wlan0 scan'

alias xmodmap-load='xmodmap /home/steve/.xmodmaprc > /tmp/blah 2>&1'
alias xorg-resolution='xdpyinfo | grep -B 1 -i resolution'

alias youtube-dl-best="youtube-dl -f bestvideo+bestaudio"
alias youtube-dl-mp3="youtube-dl -f bestaudio --extract-audio --audio-format mp3"
# -i ignore download errors like files no exist
alias youtube-dl-mp3-pl="youtube-dl -f bestaudio --extract-audio --yes-playlist --audio-format mp3 -i"

fullpath() { echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")" }

# }}}

# FUNCTIONS {{{1

web-history() {
local cols sep google_history o
cols=$(( COLUMNS / 2 ))
sep='{::}'

google_history="$HOME/.config/google-chrome/Default/History"

\cp -f "$google_history" /tmp/h
sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
        from urls order by last_visit_time desc" |
            awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}'
        }

    web-history-open() {
    web-history | fzf -e --no-sort --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs xdg-open > /dev/null 2> /dev/null

}

K() {
    [ $# -ne 1 ] && echo 'gimme a search string' && return

    ps wwaxo pid,ppid,stat,args | grep -i $1 | grep -v grep | while read -r procx; do
        echo $procx
        echo
        read -q "yn?want to kill? "
        pid="$( echo "$procx" | awk '{ print $1 }')"
        echo

        case $yn in
            [Yy]* ) sudo kill -9 $pid;;
        esac
    done
}


man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[7;49;93m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
    }

pastebin() { curl -F "c=@${1:--}" https://ptpb.pw/ }

# ssh() {
#     if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
#         tmux rename-window "$*"
#         command ssh "$@"
#         tmux set-window-option automatic-rename "on" 1>/dev/null
#     else
#         command ssh "$@"
#     fi
# }


# homegrown lazy extractor
xx() {
    if [ $# -lt 1 -o  ! -f "$1" ]; then
        echo "gimme a filename to extract"
        return
    fi

    if echo "$1" | grep -q 'tar.gz$'; then
        7z x "$1" -so | 7z x -aoa -si -ttar -o"${1%.tar.gz}"
    else
        dirx="${1%.*}"
        ggg="7z x \"$1\" -o$dirx"
        echo $ggg
        7z x "$1" -o"${dirx}"
    fi
}

# reload zshrc
function zs()
{
    source "$ZDOTDIR/.zshrc"
    # if autoload -U compinit -d "$XDG_CACHE_HOME/.zcompdump"; then
    #     compinit -d "$XDG_CACHE_HOME/.zcompdump"
    # else
    #     echo 'compinit fudged up' >&2
    # fi

    # exec zsh
}

zsh-list-completions() {
for command completion in ${(kv)_comps:#-*(-|-,*)}
do
    printf "%-32s %s\n" $command $completion
done | sort
}
alias zsh-doc='info -f zsh  --vi-keys -n  Modifiers'


# SUFFIX HANDLERS {{{
alias -s txt=nvim
alias -s md=nvim
alias -s mp4='mpv --loop'
alias -s webm='mpv --loop'
alias -s gif='mpv --loop'
alias -s jpg='mpv --loop'
alias -s jpeg='mpv --loop'
alias -s png='mpv --loop'
alias -s vim='nvim'
# }}}

# }}}




#f5# Create Directory and \kbd{cd} to it
function mkdir! () {
    if [[ "$1" == "-p" ]]; then
        shift
    fi
    if (( ARGC != 1 )); then
        printf 'usage: mkdir <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    fi
    builtin cd "$1"
}

#f5# Create temporary directory and \kbd{cd} to it
function mkdir!! () {
    builtin cd "$(mktemp -d)"
    builtin pwd
}

#f5# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
alias accessed='print -l -- *(a-${1:-1})'

#f5# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
alias changed='print -l -- *(c-${1:-1})'

#f5# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
alias modified='print -l -- *(m-${2:-1})'


#f5# List aliases
_ali() {
    local cmd=$(grep -e '^alias' $ZDOTDIR/aliases.zsh | fzf --no-sort --cycle --tac |cut -d\= -f2)
    if [[ -n $cmd ]]
    then
        echo $cmd
        eval $cmd
    fi
}
alias ali=_ali


#f1# Provides useful information on globbing
function _hglob () {
    echo -e "
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

    print *(m-1)          # Files modified up to a day ago
    print *(a1)           # Files accessed a day ago
    print *(@)            # Just symlinks
    print *(Lk+50)        # Files bigger than 50 kilobytes
    print *(Lk-50)        # Files smaller than 50 kilobytes
    print **/*.c          # All *.c files recursively starting in \$PWD
    print **/*.c~file.c   # Same as above, but excluding 'file.c'
    print (foo|bar).*     # Files starting with 'foo' or 'bar'
    print *~*.*           # All Files that do not contain a dot
        chmod 644 *(.^x)      # make all plain non-executable files publically readable
        print -l *(.c|.h)     # Lists *.c and *.h
        print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
        echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
    }
alias help-zshglob=_hglob



_viw() {
    vim $(which "$1")
}
alias viw=_viw

function fzf-ghq() {
    # local file="$(ghq list | fzf --preview 'tree -C {} | head -200')"
    local file="$(print -rl --  ${GHQ_ROOT}/github.com/*/*(om)   | fzf --no-sort --preview-window=right:50% --preview "\rg --iglob='readme*'  --files  {}/   | xargs bat --color=always ")"
    # file="$GHQ_ROOT/$file"
    if [[ -n $file ]]
    then
        if [[ -d $file ]]
        then
            builtin cd -- "$file"
        else
            # cd -- "${file:h}"
            print -P -- "%F{9}%K{0}$file doesnt exist %f"
        fi
    fi
}

function _gh_get() {
    if [[ $ARGC == 0 ]]; then
        fzf-ghq
        return  
    fi
    
    local repo="${1:t}"
    local user="${1:h:t}"
    local root="$(ghq root)/github.com/"
    # local user=$(echo $@ | tr "/" " " | awk '{print $1}')
    # local repo=$(echo $@ | tr "/" " " | awk '{print $2}')

    if [[ ! -d $root ]]; then
        print -P "%F{magenta}root doesn't exist: $root"
        return -1
    else
        if [[ -d "$root/$user/$repo" ]]; then
            pushd  "$root/$user/$repo"
            print -P "%F{blue}we there, all is good.%f"
            return 0
        else
            print -P "%F{yellow}getting....%f"
            ghq get $user/$repo
            pushd  "$root/$user/$repo"
            print -P "%F{blue}we there, all is good.%f"
        fi
    fi
}
alias ghg=_gh_get

function _set24bgcolor() {
    #printf '\x1bPtmux;\x1b\x1b[48;2;%s;%s;%sm' $1 $2 $3
    printf '\x1b[48;2;%s;%s;%sm' $1 $2 $3
}
alias bg24=_set24bgcolor
