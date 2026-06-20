#!/usr/bin/env bash
# Go development environment setup using goenv

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "Go Development Environment Setup"

# Install goenv for Go version management
if [ ! -f ~/.goenv/bin/goenv ]; then
  print_status "🔄" "${YELLOW}Installing goenv for Go version management...${NC}"
  git clone https://github.com/go-nv/goenv.git ~/.goenv

  # Add goenv to shell profile
  add_to_profile 'export GOENV_ROOT="$HOME/.goenv"' "GOENV_ROOT"
  add_to_profile 'export PATH="$GOENV_ROOT/bin:$PATH"'
  add_to_profile 'eval "$(goenv init -)"'

  print_status "✅" "${GREEN}goenv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}goenv is already installed.${NC}"
fi

# Initialize goenv for current session
print_status "🔄" "Initializing goenv for current session..."
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# Install latest stable Go version with goenv
print_status "📥" "${YELLOW}Installing latest stable Go version...${NC}"
LATEST_GO=$(goenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
if [ -n "$LATEST_GO" ]; then
  goenv install -s "$LATEST_GO"
  goenv global "$LATEST_GO"
  print_status "✅" "${GREEN}Go $(go version) installed!${NC}"
else
  print_status "⚠️" "${YELLOW}Could not determine latest Go version${NC}"
fi

# Check if Go is available now
if ! command -v go &> /dev/null; then
  print_status "⚠️" "${YELLOW}Go is not in your PATH. Run: source ${SHELL_PROFILE}${NC}"
else
  print_status "🎉" "${GREEN}Go is installed:${NC} $(go version)"

  print_header "Go Development Tools"

  # Install golangci-lint
  print_status "🔧" "${YELLOW}Installing golangci-lint...${NC}"
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.60.1
  print_status "✅" "${GREEN}golangci-lint installed!${NC}"

  # Install Go formatting and code quality tools
  print_status "🔧" "${YELLOW}Installing code formatting tools...${NC}"
  go install github.com/segmentio/golines@latest
  go install mvdan.cc/gofumpt@latest
  go install github.com/incu6us/goimports-reviser/v3@latest
  go install github.com/cweill/gotests/gotests@latest
  go install golang.org/x/tools/cmd/godoc@latest
  print_status "✅" "${GREEN}Code formatting tools installed!${NC}"

  print_header "Go Framework & CLI Tools"

  # Install CLI and development tools
  print_status "🔧" "${YELLOW}Installing Cobra CLI...${NC}"
  go install github.com/spf13/cobra-cli@latest

  print_status "🔧" "${YELLOW}Installing air (live reload)...${NC}"
  go install github.com/air-verse/air@latest

  print_status "🔧" "${YELLOW}Installing Swag for API documentation...${NC}"
  go install github.com/swaggo/swag/cmd/swag@latest

  print_status "✅" "${GREEN}All tools installed successfully!${NC}"
fi

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your Go development environment is set up!${NC}"
print_status "💡" "${YELLOW}Remember to run 'source ${SHELL_PROFILE}' to apply changes to your current shell.${NC}"

