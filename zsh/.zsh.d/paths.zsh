export PATH="$PATH:/usr/local/bin"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  export PATH="$PATH:$HOME/bin"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# Rust
if [ -d "$HOME/.cargo/bin" ] ; then
  export PATH="$PATH:$HOME/.cargo/bin"
  # for setting up python tools
  . "$HOME/.rye/env"
  . "$HOME/.cargo/env"
fi

# Python (pyenv)
if [ -d "$HOME/.pyenv" ] ; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PATH:$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
fi

# Go (goenv)
if [ -d "$HOME/.goenv" ] ; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$PATH:$GOENV_ROOT/bin"
  eval "$(goenv init -)"
  export PATH="$PATH:$GOROOT/bin"
  export PATH="$PATH:$GOPATH/bin"
fi

# Terraform (tfenv)
if [ -d "$HOME/.tfenv/bin" ] ; then
  export PATH="$PATH:$HOME/.tfenv/bin"
fi

# brew (linux)
if [ -d "/home/linuxbrew/.linuxbrew/bin" ] ; then
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi

# brew (macOS)
if [ -d "/opt/homebrew/bin" ] ; then
  export PATH="$PATH:/opt/homebrew/bin"
fi

# bun
if [ -d "$HOME/.bun" ] ; then
  # bun completions
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

  # bun
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$PATH:$BUN_INSTALL/bin"
fi

# nvm
if [ -d "$HOME/.nvm" ] ; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Keep this function as last, to avoid super long PATH
dedupe_path
