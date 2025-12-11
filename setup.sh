#!/usr/bin/env bash
# This script manages dotfiles using GNU stow

# Set color variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print status messages with emoji
print_status() {
  local emoji=$1
  local message=$2
  echo -e "${emoji} ${message}"
}

print_header() {
  local title=$1
  echo -e "\n${BLUE}================================${NC}"
  echo -e "${BLUE}    ${title}    ${NC}"
  echo -e "${BLUE}================================${NC}\n"
}

print_header "Dotfiles Setup"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  print_status "❌" "${RED}GNU stow is not installed. Please install it first.${NC}"
  print_status "💡" "On Debian/Ubuntu: ${YELLOW}sudo apt-get install stow${NC}"
  print_status "💡" "On macOS: ${YELLOW}brew install stow${NC}"
  exit 1
fi

print_status "🔄" "Updating git submodules..."
# make sure we have pulled in and updated any submodules
git submodule init
git submodule update

# default linux for os specific
if [ $(uname) = 'Darwin' ]; then
  ALACRITTY=alacritty-darwin
  print_status "🍎" "Detected macOS: using ${YELLOW}${ALACRITTY}${NC} configuration"
else
  ALACRITTY=alacritty-linux
  print_status "🐧" "Detected Linux: using ${YELLOW}${ALACRITTY}${NC} configuration"
fi

# what directories should be installable by all users including the root user
base=(
    nvim
    tmux
    bash
    $ALACRITTY
)

# Check if all directories exist
print_status "🔍" "Checking if all configuration directories exist..."
missing_dirs=()
for app in "${base[@]}"; do
  if [ ! -d "$app" ]; then
    missing_dirs+=("$app")
  fi
done

if [ ${#missing_dirs[@]} -ne 0 ]; then
  print_status "⚠️" "${YELLOW}Warning: The following directories are missing:${NC}"
  for dir in "${missing_dirs[@]}"; do
    echo "   - $dir"
  done

  print_status "❓" "Continue with available directories? (y/n)"
  read -r response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    print_status "🛑" "Setup cancelled."
    exit 0
  fi

  # Filter out missing directories
  available_dirs=()
  for app in "${base[@]}"; do
    if [ -d "$app" ]; then
      available_dirs+=("$app")
    fi
  done
  base=("${available_dirs[@]}")
fi

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_status "📦" "Backup directory created: ${YELLOW}$BACKUP_DIR${NC}"

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    usr=$1
    app=$2

    print_status "🔄" "Setting up ${YELLOW}$app${NC}..."

    # Check for potential conflicts
    conflicts=$(stow --no --verbose=2 -t ${usr} ${app} 2>&1 | grep "existing target is")
    if [ ! -z "$conflicts" ]; then
      print_status "⚠️" "${YELLOW}Potential conflicts detected for $app:${NC}"
      echo "$conflicts"

      print_status "🔄" "Backing up conflicting files to $BACKUP_DIR/$app..."
      mkdir -p "$BACKUP_DIR/$app"

      # Extract conflicting files and back them up
      echo "$conflicts" | while read -r line; do
        file=$(echo "$line" | awk -F ": " '{print $2}' | awk '{print $1}')
        if [ -e "$usr/$file" ]; then
          # Create directory structure in backup
          dir=$(dirname "$file")
          mkdir -p "$BACKUP_DIR/$app/$dir"
          # Copy the file to backup
          cp -a "$usr/$file" "$BACKUP_DIR/$app/$dir/"
        fi
      done
    fi

    # -v verbose
    # -R recursive
    # -t target
    # --adopt adopt conflicting files
    if stow -v -R -t ${usr} ${app} 2>/dev/null; then
      print_status "✅" "${GREEN}$app configured successfully!${NC}"
    else
      print_status "⚠️" "${YELLOW}Trying to adopt existing files for $app...${NC}"
      stow --adopt -v -R -t ${usr} ${app}
      # Re-stow to make sure everything is set up correctly
      stow -v -R -t ${usr} ${app}
      print_status "✅" "${GREEN}$app configured successfully (with adoption)!${NC}"
    fi
}

print_header "Installing Configuration Files"

print_status "👤" "Stowing apps for user: ${YELLOW}$(whoami)${NC}"

# install apps available to local users and root
for app in ${base[@]}; do
    stowit "${HOME}" $app
done

# Stow zsh separately (only .zsh.d directory, .zshrc is not tracked)
stowit "${HOME}" zsh

# Ensure .zshrc sources .zsh.d files
print_header "Configuring Zsh"
ZSHRC_SOURCE_BLOCK='# Source dotfiles zsh configurations
for config_file (~/.zsh.d/*.zsh(N)); do
  source $config_file
done'

if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "Source dotfiles zsh configurations" "$HOME/.zshrc"; then
    print_status "🔄" "Adding .zsh.d sourcing to existing .zshrc..."
    echo "" >> "$HOME/.zshrc"
    echo "$ZSHRC_SOURCE_BLOCK" >> "$HOME/.zshrc"
    print_status "✅" "${GREEN}Added .zsh.d sourcing to .zshrc${NC}"
  else
    print_status "✅" "${GREEN}.zshrc already sources .zsh.d files${NC}"
  fi
else
  print_status "🔄" "Creating minimal .zshrc..."
  echo "$ZSHRC_SOURCE_BLOCK" > "$HOME/.zshrc"
  print_status "✅" "${GREEN}Created .zshrc with .zsh.d sourcing${NC}"
fi

print_header "Setup Complete"
print_status "🎉" "${GREEN}All dotfiles have been configured successfully!${NC}"
print_status "📦" "Backups of your original files (if any) can be found in: ${YELLOW}$BACKUP_DIR${NC}"
print_status "💡" "You may need to restart your terminal or source configuration files for changes to take effect."
