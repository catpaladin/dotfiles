# fzf — fuzzy finder shell integration
# Loaded automatically by ~/.zshrc via the ~/.zsh.d/*.zsh loop.
# Provides:
#   Ctrl-R  fuzzy reverse history search   (the main ask)
#   Ctrl-T  fuzzy file picker (pastes paths into the command line)
#   Alt-C   fuzzy directory cd
# Tab completion is also wired up (e.g. `vim **<Tab>`).
# Theme matches the Tokyo Night palette used by pi/tmux.

# Bail quietly if fzf isn't installed (e.g. a fresh machine).
(( $+commands[fzf] )) || return 0

# --- fzf binary & shell integration (portable) ---
# Locates fzf's shell dir across macOS Homebrew, Linux Homebrew, and system packages.
_fzf_shell=""
for _d in /opt/homebrew/opt/fzf/shell /home/linuxbrew/.linuxbrew/opt/fzf/shell /usr/share/doc/fzf/examples /usr/share/fzf; do
  if [ -d "$_d" ]; then _fzf_shell="$_d"; break; fi
done
if [ -n "$_fzf_shell" ]; then
  # Add fzf bin to PATH (Homebrew keeps it under opt/fzf/bin)
  _fzf_bin="${_fzf_shell%/shell}/bin"
  [ -d "$_fzf_bin" ] && export PATH="$_fzf_bin:$PATH"
fi

# --- commands: prefer fd (respects .gitignore, much faster than find) ---
# fd is hidden by default unless --hidden; fzf wants hidden files visible.
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}' --preview-window 'right:60%:wrap'"
  export FZF_ALT_C_OPTS="--preview 'ls -la --color=always {} 2>/dev/null' --preview-window 'right:60%'"
else
  export FZF_DEFAULT_COMMAND='find -L . -type f -not -path "*/.git/*" 2>/dev/null'
fi

# --- Tokyo Night theme + layout (matches ~/.pi/agent/themes/tokyo-night-storm.json) ---
export FZF_DEFAULT_OPTS="
  --height 40% --layout=reverse --border --info=inline
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#f7768e
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
  --color=border:#3b4261,separator:#3b4261,scrollbar:#3b4261,gutter:#1a1b26
  --bind='ctrl-/:toggle-preview'
"

# Ctrl-R: fuzzy history with a peek at the full command below.
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window 'down:3:wrap:hidden'
  --header 'ctrl-r: history  ctrl-/: preview  enter: use'
"

# --- completion (Tab) needs compinit; none of the other .zsh.d files run it ---
autoload -Uz compinit
# Regenerate the dump at most once a day; otherwise fast-load from cache.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# shell integration
if [ -n "$_fzf_shell" ]; then
  source "$_fzf_shell/completion.zsh" 2>/dev/null
  source "$_fzf_shell/key-bindings.zsh" 2>/dev/null
fi
unset _fzf_shell _fzf_bin _d