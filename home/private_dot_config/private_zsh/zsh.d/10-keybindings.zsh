# List of widgets: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets

# Useful for setting up keybindings -> shows terminal code for key combinations
#   showkey -a

# alt-x: insert last command result
zmodload -i zsh/parameter
insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey '^[x' insert-last-command-output

# ctrl+backspace: delete word before
bindkey '^H' backward-kill-word
# ctrl+delete: delete word after
bindkey "\e[3;5~" kill-word

# ctrl+k: delete line
bindkey '^K' backward-kill-line

# esc: break
bindkey '\e' send-break
