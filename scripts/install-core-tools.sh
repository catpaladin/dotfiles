#!/usr/bin/env bash
# Core shell CLI tools setup
#
# Installs the cross-cutting CLI tools that the zsh aliases and modules depend
# on but that aren't covered by the per-language dev scripts:
#   eza      -> ls / ll / la / tree aliases
#   ripgrep  -> grep alias (rg)
#   bat      -> suffix aliases for source & config files
#   fd       -> file finder used by fzf
#   fzf      -> fuzzy finder (Ctrl-R / Ctrl-T / Alt-C)
#   starship -> cross-shell prompt
#   jless    -> .json suffix alias
#
# Idempotent — safe to re-run. Missing tools are installed; present ones are
# skipped. macOS uses Homebrew; Linux uses apt (with a couple of platform
# specific fallbacks noted inline).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

detect_os

print_header "Core CLI Tools Setup"

# Ensure the per-user local bin exists; used for the fdfind -> fd symlink on
# Debian/Ubuntu and as a fallback PATH target.
mkdir -p "$HOME/.local/bin"

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------

# Install a single tool via Homebrew (macOS) or apt (Linux), skipping if the
# command is already on PATH. Uses the same install command name on both
# platforms by default; pass distinct names via the optional 2nd/3rd args.
install_pkg() {
  local cmd="$1"        # command name used to check for the tool
  local brew_pkg="${2:-$1}"
  local apt_pkg="${3:-$1}"

  if command_exists "$cmd"; then
    print_status "✅" "${GREEN}$cmd is already installed.${NC}"
    return 0
  fi

  if [ "$IS_MACOS" = true ]; then
    print_status "🔧" "${YELLOW}Installing $cmd via Homebrew ($brew_pkg)...${NC}"
    brew install "$brew_pkg"
  else
    print_status "🔧" "${YELLOW}Installing $cmd via apt ($apt_pkg)...${NC}"
    sudo apt-get update -qq && sudo apt-get install -y "$apt_pkg"
  fi

  if command_exists "$cmd"; then
    print_status "✅" "${GREEN}$cmd installed successfully.${NC}"
  else
    print_status "⚠️" "${YELLOW}$cmd may not be on PATH yet — restart your shell or add ~/.local/bin to PATH.${NC}"
  fi
}

# ----------------------------------------------------------------------------
# eza — modern ls replacement (ls / ll / la / tree aliases)
# ----------------------------------------------------------------------------
if command_exists eza; then
  print_status "✅" "${GREEN}eza is already installed.${NC}"
elif [ "$IS_MACOS" = true ]; then
  print_status "🔧" "${YELLOW}Installing eza via Homebrew...${NC}"
  brew install eza
  command_exists eza && print_status "✅" "${GREEN}eza installed successfully.${NC}" \
    || print_status "❌" "${RED}eza installation failed.${NC}"
else
  # eza ships in Ubuntu 24.04+ as `eza`; on older Debian/Ubuntu it lives in the
  # eza-community apt repo. Try the distro package first, then set up the repo.
  print_status "🔧" "${YELLOW}Installing eza via apt...${NC}"
  if ! sudo apt-get install -y eza 2>/dev/null; then
    print_status "📦" "${YELLOW}eza not in the distro repo — adding the eza-community apt repo...${NC}"
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --dearmor -o /etc/apt/keyrings/eza.gpg
    echo "deb [signed-by=/etc/apt/keyrings/eza.gpg] http://deb.felix-crux.com stable main" \
      | sudo tee /etc/apt/sources.list.d/eza.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y eza
  fi
  command_exists eza && print_status "✅" "${GREEN}eza installed successfully.${NC}" \
    || print_status "❌" "${RED}eza installation failed.${NC}"
fi

# ----------------------------------------------------------------------------
# ripgrep — grep alias (rg)
# ----------------------------------------------------------------------------
install_pkg rg ripgrep ripgrep

# ----------------------------------------------------------------------------
# bat — suffix aliases for source/config files
# ----------------------------------------------------------------------------
# Debian/Ubuntu ships bat as `batcat`, not `bat`. Install it and symlink to
# ~/.local/bin/bat so the suffix aliases resolve.
if command_exists bat; then
  print_status "✅" "${GREEN}bat is already installed.${NC}"
elif [ "$IS_MACOS" = true ]; then
  print_status "🔧" "${YELLOW}Installing bat via Homebrew...${NC}"
  brew install bat
  command_exists bat && print_status "✅" "${GREEN}bat installed successfully.${NC}" \
    || print_status "❌" "${RED}bat installation failed.${NC}"
else
  print_status "🔧" "${YELLOW}Installing bat via apt...${NC}"
  sudo apt-get update -qq && sudo apt-get install -y bat
  if command_exists batcat && ! command_exists bat; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    print_status "🔗" "${GREEN}Symlinked batcat -> ~/.local/bin/bat${NC}"
  fi
  command_exists bat && print_status "✅" "${GREEN}bat installed successfully.${NC}" \
    || print_status "⚠️" "${YELLOW}bat may not be on PATH yet — ensure ~/.local/bin is in PATH.${NC}"
fi

# ----------------------------------------------------------------------------
# fd — file finder used by fzf
# ----------------------------------------------------------------------------
if command_exists fd; then
  print_status "✅" "${GREEN}fd is already installed.${NC}"
elif [ "$IS_MACOS" = true ]; then
  print_status "🔧" "${YELLOW}Installing fd via Homebrew...${NC}"
  brew install fd
  command_exists fd && print_status "✅" "${GREEN}fd installed successfully.${NC}" \
    || print_status "❌" "${RED}fd installation failed.${NC}"
else
  # Debian/Ubuntu ships fd as `fdfind`; symlink it to ~/.local/bin/fd.
  print_status "🔧" "${YELLOW}Installing fd via apt...${NC}"
  sudo apt-get update -qq && sudo apt-get install -y fd-find
  if command_exists fdfind && ! command_exists fd; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    print_status "🔗" "${GREEN}Symlinked fdfind -> ~/.local/bin/fd${NC}"
  fi
  command_exists fd && print_status "✅" "${GREEN}fd installed successfully.${NC}" \
    || print_status "⚠️" "${YELLOW}fd may not be on PATH yet — ensure ~/.local/bin is in PATH.${NC}"
fi

# ----------------------------------------------------------------------------
# fzf — fuzzy finder
# ----------------------------------------------------------------------------
install_pkg fzf fzf fzf

# ----------------------------------------------------------------------------
# starship — cross-shell prompt
# ----------------------------------------------------------------------------
if command_exists starship; then
  print_status "✅" "${GREEN}starship is already installed.${NC}"
else
  print_status "🔧" "${YELLOW}Installing starship...${NC}"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  command_exists starship && print_status "✅" "${GREEN}starship installed successfully.${NC}" \
    || print_status "❌" "${RED}starship installation failed.${NC}"
fi

# ----------------------------------------------------------------------------
# jless — .json suffix alias
# ----------------------------------------------------------------------------
install_pkg jless jless jless

# ----------------------------------------------------------------------------
print_header "Core CLI Tools Setup Complete"
print_status "🚀" "${GREEN}Core CLI tools are ready.${NC}"
print_status "💡" "Restart your shell to pick up the new tools: ${YELLOW}exec zsh${NC}"