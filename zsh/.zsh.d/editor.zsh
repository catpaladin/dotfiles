# Editor integration
# Sets $EDITOR for tools that respect it (git, edit-command-line, etc.)
export EDITOR="nvim"
export VISUAL="nvim"

# Ctrl-X Ctrl-E: edit the current command line in Neovim, then execute it.
#
# How it works:
#   1. The current command-line buffer is written to a temp file
#   2. Neovim opens with that file — edit freely (multi-line, splits, etc.)
#   3. On :wq, the file contents replace the buffer
#   4. If non-empty, the command executes immediately
#
# To just edit without executing, quit with :q! (buffer is unchanged).
autoload -Uz edit-command-line
zle -N edit-command-line

_edit-and-execute() {
  edit-command-line
  # Only execute if the user didn't clear the buffer
  if [[ -n $BUFFER ]]; then
    zle .accept-line
  fi
}
zle -N _edit-and-execute
bindkey '^X^E' _edit-and-execute
