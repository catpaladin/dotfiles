#!/usr/bin/env bash
# Install Nerd Fonts (Hack, Noto) for Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

print_header "Nerd Font Installation"

fonts_dir="${HOME}/.local/share/fonts"
if [ ! -d "${fonts_dir}" ]; then
    print_status "🔄" "Creating fonts directory: ${YELLOW}${fonts_dir}${NC}"
    mkdir -p "${fonts_dir}"
else
    print_status "✅" "Found fonts dir ${YELLOW}${fonts_dir}${NC}"
fi

version=v3.2.1

install_font() {
  font=$1
  print_status "📥" "Installing ${YELLOW}${font}${NC}..."
  zip=${font}.zip
  curl --fail --location --show-error https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${zip} --output ${zip}
  unzip -o -q -d ${fonts_dir} ${zip}
  rm ${zip}
  print_status "✅" "${GREEN}${font} installed${NC}"
}

install_font Hack
install_font Noto

print_status "🔄" "Refreshing font cache..."
fc-cache -f
print_status "🎉" "${GREEN}Nerd Fonts installed successfully!${NC}"
