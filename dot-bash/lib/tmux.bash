# In ~/.bashrc: Give every tmux pane its own persistent bash history file
if [ -n "$TMUX_PANE" ]; then
    mkdir -p ~/.bash_history_tmux
    export HISTFILE="$HOME/.bash_history_tmux/pane_${TMUX_PANE#%}"
    PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
fi

