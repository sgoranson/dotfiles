#!/usr/bin/zsh

function fz_i3() { grep -P '^bindsym' ~/.config/i3/config | grep -Pv '^#' | sort }  


fz_i3 | fzf
