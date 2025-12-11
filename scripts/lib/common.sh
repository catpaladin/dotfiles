#!/usr/bin/env bash
# Common functions and variables for dotfiles scripts

# Color variables
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color

# Print status message with emoji
print_status() {
  local emoji=$1
  local message=$2
  echo -e "${emoji} ${message}"
}

# Print section header
print_header() {
  local title=$1
  echo -e "\n${BLUE}================================${NC}"
  echo -e "${BLUE}    ${title}    ${NC}"
  echo -e "${BLUE}================================${NC}\n"
}

# Detect OS and set shell profile
detect_os() {
  if [ "$(uname)" = 'Darwin' ]; then
    export IS_MACOS=true
    export IS_LINUX=false
    export SHELL_PROFILE=~/.zshrc
    print_status "🍎" "Detected macOS: using ${YELLOW}${SHELL_PROFILE}${NC}"
  else
    export IS_MACOS=false
    export IS_LINUX=true
    export SHELL_PROFILE=~/.bashrc
    print_status "🐧" "Detected Linux: using ${YELLOW}${SHELL_PROFILE}${NC}"
  fi
}

# Add line to shell profile if not already present
add_to_profile() {
  local line="$1"
  local marker="${2:-$line}"  # Optional marker to check for, defaults to the line itself
  if ! grep -q "$marker" "${SHELL_PROFILE}"; then
    echo "$line" >> "${SHELL_PROFILE}"
    return 0  # Line was added
  fi
  return 1  # Line already exists
}

# Check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}
