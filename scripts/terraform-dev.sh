#!/usr/bin/env bash
# Terraform development environment setup using tfenv

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "Terraform Development Environment Setup"

# Install tfenv for Terraform version management
if [ ! -d "$HOME/.tfenv" ]; then
  print_status "🏗️" "${YELLOW}Installing tfenv for Terraform version management...${NC}"

  git clone https://github.com/tfutils/tfenv.git ~/.tfenv

  # Add tfenv to shell profile
  add_to_profile 'export PATH="$HOME/.tfenv/bin:$PATH"' "tfenv"

  print_status "✅" "${GREEN}tfenv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}tfenv is already installed.${NC}"
fi

# Initialize tfenv in current script session
print_status "🔄" "Initializing tfenv for current session..."
export PATH="$HOME/.tfenv/bin:$PATH"

# Install latest Terraform version with tfenv
print_status "📥" "${YELLOW}Installing latest stable Terraform version...${NC}"
tfenv install latest
tfenv use latest
print_status "✅" "${GREEN}Terraform $(terraform --version | head -n 1) installed!${NC}"

# Install additional Terraform tools
print_header "Terraform Development Tools"

# Install tflint
if ! command_exists tflint; then
  print_status "🔧" "${YELLOW}Installing tflint (Terraform linter)...${NC}"
  # tflint's Homebrew tap is deprecated; use the official install script for both platforms.
  # Install to ~/.local/bin (already in PATH via paths.zsh) to avoid needing sudo.
  mkdir -p "$HOME/.local/bin"
  TFLINT_VERSION=$(curl -sSfL -o /dev/null -w '%{url_effective}' https://github.com/terraform-linters/tflint/releases/latest | grep -o '[^/]*$')
  ARCH=$(uname -m)
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "$ARCH" in
    x86_64)  ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
  esac
  curl -sSfL -o /tmp/tflint.zip "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_${OS}_${ARCH}.zip"
  unzip -o -d /tmp/tflint-extract /tmp/tflint.zip
  cp /tmp/tflint-extract/tflint "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/tflint"
  rm -rf /tmp/tflint.zip /tmp/tflint-extract
  print_status "✅" "${GREEN}tflint installed!${NC}"
else
  print_status "✅" "${GREEN}tflint is already installed.${NC}"
fi

# Install terraform-docs
if ! command_exists terraform-docs; then
  print_status "🔧" "${YELLOW}Installing terraform-docs...${NC}"
  if [ "$IS_MACOS" = true ]; then
    brew install terraform-docs
  else
    curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.17.0/terraform-docs-v0.17.0-linux-amd64.tar.gz
    tar -xzf terraform-docs.tar.gz
    chmod +x terraform-docs
    mv terraform-docs /usr/local/bin/
    rm terraform-docs.tar.gz
  fi
  print_status "✅" "${GREEN}terraform-docs installed!${NC}"
else
  print_status "✅" "${GREEN}terraform-docs is already installed.${NC}"
fi

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your Terraform development environment is ready!${NC}"
print_status "💡" "Terraform version: $(terraform --version | head -n 1)"
