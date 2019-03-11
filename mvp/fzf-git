#!env zsh
# fshow - git commit browser (enter for show, ctrl-d for diff, ` toggles sort)
# fshow() {
#   local out shas sha q k
#   while out=$(
#       git log --graph --color=always \
#           --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
#       fzf --ansi --multi --no-sort --reverse --query="$q" \
#           --print-query --expect=ctrl-d --toggle-sort=\`); do
#     q=$(head -1 <<< "$out")
#     k=$(head -2 <<< "$out" | tail -1)
#     shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
#     [ -z "$shas" ] && continue
#     if [ "$k" = ctrl-d ]; then
#       git diff --color=always $shas | less -R
#     else
#       for sha in $shas; do
#         git show --color=always $sha | less -R
#       done
#     fi
#   done
# }

fshow() {
    local commit_hash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    local view_commit="$commit_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
    git log --color=always \
        --format="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" "$@" | \
    fzf --no-sort --tiebreak=index --no-multi --reverse --ansi \
        --header="enter to view, alt-y to copy hash" --preview="$view_commit" \
        --bind="enter:execute:$view_commit | less -R" \
        --bind="alt-y:execute:$commit_hash | xclip -selection clipboard"
}

fshow $@
