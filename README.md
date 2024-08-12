# Dotfiles

Just some simple dotfiles of settings that I use on a daily basis.

# Setup
## Initial clone
```bash
git clone --recurse-submodules https://github.com/catpaladin/dotfiles.git
```

## Updating submodules
```bash
git submodule update --recursive --remote
```

# Dependencies
This repo requires several dependencies. It requires Nerd Fonts patched and greater than v3.
For Linux, you can use the `install_font_linux.sh`.

## Dependencies Setup
```
./install_dependencies.sh
```

# Install
## Setup settings with `stow`
```bash
./setup.sh
```

# Additional Setup
## tmux
Remember to install plugins with `<tmux-prefix> + I`
