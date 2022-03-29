# List of widgets: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets

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

# zsh selection doesn't automatically map to the system clipboard
# https://unix.stackexchange.com/a/51938
# clipcopy is defined in oh-my-zsh and might require xclip to be installed on linux.
x-copy-region-as-kill() {
  zle copy-region-as-kill
  printf %s "$CUTBUFFER" | clipcopy 2>/dev/null || true
}

# This binding is only needed doing shift-selection and doesn't work in GNOME terminal,
# but VS Code works great.
zle -N x-copy-region-as-kill
bindkey -M shift-select '^C' x-copy-region-as-kill
