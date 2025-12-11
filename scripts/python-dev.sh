#!/usr/bin/env bash
# Python development environment setup using pyenv

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "Python Development Environment Setup"

# Install pyenv for Python version management
if [ ! -d "$HOME/.pyenv" ]; then
  print_status "🐍" "${YELLOW}Installing pyenv for Python version management...${NC}"

  # Install dependencies
  if [ "$IS_MACOS" = true ]; then
    print_status "🔧" "Installing pyenv dependencies for macOS..."
    brew install openssl readline sqlite3 xz zlib tcl-tk
  else
    print_status "🔧" "Installing pyenv dependencies for Linux..."
    sudo apt-get update
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl
  fi

  # Install pyenv
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

  # Add pyenv to shell profile
  add_to_profile 'export PYENV_ROOT="$HOME/.pyenv"' "PYENV_ROOT"
  add_to_profile 'export PATH="$PYENV_ROOT/bin:$PATH"'
  add_to_profile 'eval "$(pyenv init --path)"'
  add_to_profile 'eval "$(pyenv init -)"'

  print_status "✅" "${GREEN}pyenv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}pyenv is already installed.${NC}"
fi

# Initialize pyenv in current script session
print_status "🔄" "Initializing pyenv for current session..."
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Install latest Python version with pyenv
print_status "📥" "${YELLOW}Installing latest stable Python version...${NC}"
LATEST_PYTHON=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
if [ -n "$LATEST_PYTHON" ]; then
  pyenv install -s "$LATEST_PYTHON"
  pyenv global "$LATEST_PYTHON"
  print_status "✅" "${GREEN}Python $(pyenv exec python --version) installed!${NC}"
else
  print_status "⚠️" "${YELLOW}Could not determine latest Python version${NC}"
fi

# Install essential Python packages
print_header "Python Development Tools"
print_status "📦" "${YELLOW}Installing essential Python packages...${NC}"
pyenv exec pip install --upgrade pip
pyenv exec pip install \
  pyyaml \
  black \
  isort \
  mypy \
  ruff \
  pytest \
  ipython

print_status "✅" "${GREEN}Python development tools installed!${NC}"

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your Python development environment is ready!${NC}"
print_status "💡" "Python version: $(pyenv exec python --version)"
