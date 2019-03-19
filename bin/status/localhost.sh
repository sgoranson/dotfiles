#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

parse_ssh_port() {
    # If there is a port get it
    local port=$(echo $1 | grep -Eo '\-p ([0-9]+)' | sed 's/-p //')

    if [ -z $port ]; then
        local port=22
    fi

    echo $port
}

get_remote_info() {
    local command=$1

    # First get the current pane command pid to get the full command with arguments
    local cmd=$({
        pgrep -flaP $(tmux display-message -p "#{pane_pid}")
        ps -o command -p $(tmux display-message -p "#{pane_pid}")
    } | xargs -I{} echo {} | grep ssh | sed -E 's/^[0-9]*[[:blank:]]*ssh //')

    local port=$(parse_ssh_port "$cmd")

    local cmd=$(echo $cmd | sed 's/\-p '"$port"'//g')

    local user=$(echo $cmd | awk '{print $NF}' | cut -f1 -d@)
    local host=$(echo $cmd | awk '{print $NF}' | cut -f2 -d@)

    case "$1" in
    "whoami")
        echo $user
        ;;
    "hostname")
        echo $host
        ;;
    *)
        echo "$user@$host:$port"
        ;;
    esac
}

cmdx=$(tmux display-message -p "#{pane_current_command}")
# orighost=$(tmux show -vg @myhost)

if [[ $cmdx == "ssh" ]] || [[ $cmdx == "sshpass" ]]; then

    echo $(get_remote_info "hostname")
else
    # echo $("hostname")
    echo ""
fi
