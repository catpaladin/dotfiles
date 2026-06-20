#!/usr/bin/env bash
# Rust development environment setup
# Installs rustup, Rust toolchain, ripgrep, and Python tools (uv, ruff, rye)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "Rust Setup Script"

if command -v rustc &> /dev/null; then
  print_status "🎉" "${GREEN}Rust is already installed!${NC}"
  rustc --version
else
  print_status "🔍" "${YELLOW}Rust not found. Installing Rust...${NC}"

  # Install Rust using rustup (the official installer)
  print_status "📥" "Downloading rustup installer..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Add Rust to the current shell session
  print_status "🔄" "Configuring environment..."
  source "$HOME/.cargo/env"

  # Verify installation
  if command -v rustc &> /dev/null; then
    print_status "✅" "${GREEN}Rust installed successfully!${NC}"
    rustc --version
  else
    print_status "❌" "${RED}Rust installation failed.${NC}"
    exit 1
  fi
fi

print_status "🦀" "${GREEN}Rust environment is ready.${NC}"

# Install Python tools (requires Rust Cargo path)
print_header "Python Development Tools"

if [ ! -f ~/.cargo/bin/uv ]; then
  print_status "🔧" "${YELLOW}Installing uv package manager...${NC}"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  print_status "✅" "${GREEN}uv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}uv is already installed.${NC}"
fi

if [ ! -f ~/.cargo/bin/ruff ]; then
  print_status "🔧" "${YELLOW}Installing ruff linter...${NC}"
  curl -LsSf https://astral.sh/ruff/install.sh | sh
  print_status "✅" "${GREEN}ruff installed successfully!${NC}"
else
  print_status "✅" "${GREEN}ruff is already installed.${NC}"
fi

if [ ! -f ~/.rye/shims/rye ]; then
  print_status "🔧" "${YELLOW}Installing rye package manager...${NC}"
  curl -sSf https://rye.astral.sh/get | bash
  print_status "✅" "${GREEN}rye installed successfully!${NC}"
else
  print_status "✅" "${GREEN}rye is already installed.${NC}"
fi

# Rust tools
print_header "Rust Development Tools"

if ! command -v rg &> /dev/null; then
  print_status "🔧" "${YELLOW}Installing ripgrep...${NC}"
  cargo install ripgrep
  print_status "✅" "${GREEN}ripgrep installed successfully!${NC}"
else
  print_status "✅" "${GREEN}ripgrep is already installed.${NC}"
fi

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your development environment is ready to use!${NC}"
print_status "💡" "To use these tools in this terminal session, you may need to run: ${YELLOW}source ~/.cargo/env${NC}"

