# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# History settings
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt HIST_IGNORE_DUPS       # Don't save duplicate commands
setopt HIST_IGNORE_SPACE      # Don't save commands starting with space
setopt SHARE_HISTORY          # Share history between all sessions

# Install custom plugins if not exist
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] ; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] ; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# zsh files
for config_file (~/.zsh.d/*.zsh(N)); do
  source $config_file
done

