#!/usr/bin/env bash
# Python development environment setup using uv

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "Python Development Environment Setup"

# Install uv for Python version and package management
if ! command_exists uv; then
  print_status "🐍" "${YELLOW}Installing uv package manager...${NC}"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  print_status "✅" "${GREEN}uv installed successfully!${NC}"
else
  print_status "✅" "${GREEN}uv is already installed.${NC}"
fi

# Ensure uv is on PATH for current session
export PATH="$HOME/.local/bin:$PATH"

# Install latest stable Python version with uv
# Uses uv python list (not --only-downloads) so already-installed Pythons
# (e.g. via Homebrew) are detected and not reinstalled.
print_status "📥" "${YELLOW}Finding latest stable Python version...${NC}"
LATEST_PYTHON=$(uv python list 2>/dev/null \
  | sed 's/^[[:space:]]*//' \
  | grep 'cpython-' \
  | grep -vE 'freethreaded|debug|pypy|[0-9]rc[0-9]' \
  | cut -d'-' -f2 \
  | sort -V \
  | tail -1)
if [ -n "$LATEST_PYTHON" ]; then
  # Check if this version is already available to uv
  INSTALLED_PYTHON=$(uv python find "$LATEST_PYTHON" 2>/dev/null)
  if [ -n "$INSTALLED_PYTHON" ]; then
    print_status "✅" "${GREEN}Python $($INSTALLED_PYTHON --version 2>&1) already available${NC}"
  else
    print_status "🔧" "${YELLOW}Installing Python $LATEST_PYTHON via uv...${NC}"
    uv python install "$LATEST_PYTHON"
    INSTALLED_PYTHON=$(uv python find "$LATEST_PYTHON" 2>/dev/null)
    print_status "✅" "${GREEN}Python $($INSTALLED_PYTHON --version 2>&1) installed!${NC}"
  fi
else
  print_status "⚠️" "${YELLOW}Could not determine latest Python version${NC}"
fi

# Install essential Python development tools as isolated uv tools
# These are installed to ~/.local/bin (already on PATH via paths.zsh)
# --force overwrites existing executables from other sources (e.g. pyenv shims)
print_header "Python Development Tools"
print_status "📦" "${YELLOW}Installing essential Python tools...${NC}"

for tool in ruff black isort mypy pytest ipython; do
  print_status "🔧" "${YELLOW}Installing ${tool}...${NC}"
  uv tool install --force "$tool" 2>/dev/null && \
    print_status "✅" "${GREEN}${tool} installed${NC}" || \
    print_status "⚠️" "${YELLOW}${tool} installation failed (may already be available)${NC}"
done

print_status "✅" "${GREEN}Python development tools installed!${NC}"

print_header "Installation Complete"
print_status "🚀" "${GREEN}Your Python development environment is ready!${NC}"
print_status "💡" "Python: $($INSTALLED_PYTHON --version 2>&1)"
print_status "💡" "${YELLOW}Tools installed to ~/.local/bin via 'uv tool install'${NC}"
print_status "💡" "${YELLOW}Project dependencies: use 'uv pip install' in a virtualenv (uv venv)${NC}"