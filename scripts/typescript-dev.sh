#!/usr/bin/env bash
# TypeScript/Node.js development environment setup using NVM

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "TypeScript Development Environment Setup"

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
  print_status "🔄" "${YELLOW}Installing NVM (Node Version Manager)...${NC}"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  # Load NVM in the current shell
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  print_status "✅" "${GREEN}NVM installed successfully!${NC}"
else
  print_status "✅" "${GREEN}NVM is already installed.${NC}"

  # Load NVM in the current shell
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install latest LTS version of Node.js
print_status "🔧" "${YELLOW}Installing the latest LTS version of Node.js...${NC}"
nvm install --lts
nvm use --lts
print_status "✅" "${GREEN}Node.js $(node -v) installed!${NC}"

# Install Yarn
if ! command -v yarn &> /dev/null; then
  print_status "🔧" "${YELLOW}Installing Yarn package manager...${NC}"
  npm install -g yarn
  print_status "✅" "${GREEN}Yarn $(yarn --version) installed!${NC}"
else
  print_status "✅" "${GREEN}Yarn $(yarn --version) is already installed.${NC}"
fi

# Install Bun
if [ ! -d "$HOME/.bun" ]; then
  print_status "🔧" "${YELLOW}Installing Bun runtime...${NC}"
  curl -fsSL https://bun.sh/install | bash
  print_status "✅" "${GREEN}Bun installed successfully!${NC}"
else
  print_status "✅" "${GREEN}Bun is already installed.${NC}"
fi

# Load Bun in the current shell
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

print_status "✅" "${GREEN}Bun $(bun --version) ready!${NC}"

# Install TypeScript
print_status "🔧" "${YELLOW}Installing TypeScript globally...${NC}"
npm install -g typescript
print_status "✅" "${GREEN}TypeScript $(tsc --version) installed!${NC}"

# Install useful TypeScript development tools
print_header "TypeScript Development Tools"

print_status "🔧" "${YELLOW}Installing ts-node (TypeScript execution)...${NC}"
npm install -g ts-node

print_status "🔧" "${YELLOW}Installing TypeScript ESLint...${NC}"
npm install -g eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

print_status "🔧" "${YELLOW}Installing Prettier (code formatter)...${NC}"
npm install -g prettier

print_status "🔧" "${YELLOW}Installing TypeDoc (documentation generator)...${NC}"
npm install -g typedoc

print_status "🔧" "${YELLOW}Installing tsx (TypeScript executor)...${NC}"
npm install -g tsx

print_status "✅" "${GREEN}All development tools installed!${NC}"

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your TypeScript development environment is ready!${NC}"
print_status "📚" "To start a new TypeScript project:"
echo -e "   ${YELLOW}mkdir my-project && cd my-project${NC}"
echo -e "   ${YELLOW}yarn init -y${NC}"
echo -e "   ${YELLOW}yarn add -D typescript @types/node${NC}"
echo -e "   ${YELLOW}mkdir src && touch src/index.ts${NC}"
print_status "🎮" "Or use Bun to create a new project:"
echo -e "   ${YELLOW}bun create typescript my-bun-project${NC}"
