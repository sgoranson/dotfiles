tmux set-option -g status-style fg=colour8,bg=colour0                                                                                                                        
tmux set-option -g status-right-style fg=colour8,bg=colour0                                                                                                                  
tmux set-option -g status-left-style fg=colour12,bg=colour0                                                                                                                  

tmux set-window-option -g window-status-current-style fg=colour3,bg=colour0                                                                                                  
tmux set-window-option -g window-status-style fg=colour8,bg=colour0                                                                                                          
                                                                                                                                                                         
tmux set-option -g pane-border-style fg=colour2,bg=colour1                                                                                                                   
tmux set-option -g message-style fg=colour9,bg=colour1                                                                                                                       

tmux set-option -g message-bg black #base02                                                                                                                                  
tmux set-option -g message-fg brightred #orange                                                                                                                              

tmux set-option -g display-panes-active-colour colour4                                                                                                                       
tmux set-option -g display-panes-colour colour2                                                                                                                              

tmux set -g status-right "#[fg=colour8,bg=colour0]#h#[fg=colour12,bg=colour0] λ "                                                                                            
tmux set -g status-left ' '                      
