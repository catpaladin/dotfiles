#!/usr/bin/env bash

# Set color variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
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

# Determine the shell profile
if [ $(uname) = 'Darwin' ]; then
  SHELL_PROFILE=~/.zshrc
  print_status "🍎" "Detected macOS: using ${YELLOW}${SHELL_PROFILE}${NC}"
else
  SHELL_PROFILE=~/.bashrc
  print_status "🐧" "Detected Linux: using ${YELLOW}${SHELL_PROFILE}${NC}"
fi

print_header "Cloud & ML Setup"

# Install pyenv for Python version management
if [ ! -d "$HOME/.pyenv" ]; then
  print_status "🐍" "${YELLOW}Installing pyenv for Python version management...${NC}"

  # Install dependencies
  if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "🔧" "Installing pyenv dependencies for macOS..."
    brew install openssl readline sqlite3 xz zlib tcl-tk
  else
    print_status "🔧" "Installing pyenv dependencies for Linux..."
    sudo apt-get update
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl
  fi

  # Install pyenv
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

  # Add pyenv to shell profile
  if ! grep -q "pyenv" ${SHELL_PROFILE}; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ${SHELL_PROFILE}
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ${SHELL_PROFILE}
    echo 'eval "$(pyenv init --path)"' >> ${SHELL_PROFILE}
    echo 'eval "$(pyenv init -)"' >> ${SHELL_PROFILE}
  fi

  print_status "✅" "${GREEN}pyenv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}pyenv is already installed.${NC}"
fi

# Install tfenv for Terraform version management
if [ ! -d "$HOME/.tfenv" ]; then
  print_status "🏗️" "${YELLOW}Installing tfenv for Terraform version management...${NC}"

  git clone https://github.com/tfutils/tfenv.git ~/.tfenv

  # Add tfenv to shell profile
  if ! grep -q "tfenv" ${SHELL_PROFILE}; then
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ${SHELL_PROFILE}
  fi

  print_status "✅" "${GREEN}tfenv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}tfenv is already installed.${NC}"
fi

# Source profile to use pyenv and tfenv in current session
print_status "🔄" "Sourcing ${SHELL_PROFILE} to update current shell..."
source ${SHELL_PROFILE}

# Install latest Python version with pyenv
print_status "📥" "${YELLOW}Installing latest stable Python version...${NC}"
pyenv install $(pyenv install --list | grep -v - | grep -v a | grep -v b | grep -v rc | tail -1)
pyenv global $(pyenv install --list | grep -v - | grep -v a | grep -v b | grep -v rc | tail -1)
print_status "✅" "${GREEN}Python $(python --version) installed!${NC}"

# Install latest Terraform version with tfenv
print_status "📥" "${YELLOW}Installing latest stable Terraform version...${NC}"
tfenv install latest
tfenv use latest
print_status "✅" "${GREEN}Terraform $(terraform --version | head -n 1) installed!${NC}"

# Install essential Python packages for ML/Cloud engineering
print_status "📦" "${YELLOW}Installing essential Python packages...${NC}"
pip install --upgrade pip
pip install pyyaml \
  black \
  isort \
  mypy \
  numpy \
  pandas \
  scikit-learn \
  boto3 \
  jupyter \
  click \
  fastapi \
  uvicorn \
  streamlit

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your Cloud & ML Engineering environment is ready!${NC}"
print_status "💡" "Python version: $(python --version)"
print_status "💡" "Terraform version: $(terraform --version | head -n 1)"

