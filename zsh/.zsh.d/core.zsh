# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# History settings
HISTSIZE=100000
SAVEHIST=100000

# History options
setopt HIST_IGNORE_DUPS       # Don't save duplicate commands
setopt HIST_IGNORE_SPACE      # Don't save commands starting with space
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY          # Share history between all sessions

setopt AUTOCD
setopt NOBEEP

# Install custom plugins if not exist
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] ; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi
source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] ; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# NOTE: oh-my-zsh's plugin loader (source $ZSH/oh-my-zsh.sh) is intentionally
# not called. The custom plugins above are sourced manually for faster startup
# and finer control. The plugins array is unused.
