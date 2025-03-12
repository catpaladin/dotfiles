# Dotfiles

Just some simple dotfiles of settings that I use on a daily basis.

# Install & Setup
## Initial clone
```bash
git clone --recurse-submodules https://github.com/catpaladin/dotfiles.git
```

## Setup settings with `stow`
```bash
./setup.sh
```

## Updating submodules
```bash
git submodule update --recursive --remote
```

# Dependencies
This repo requires several dependencies. It requires Nerd Fonts patched and greater than v3.

> [!NOTE]
> For Linux, you can use the `install_font_linux.sh`.

## Dependencies Setup
### Go Development
```bash
./scripts/go-dev.sh
```

### Typescript Development
```bash
./scripts/typescript-dev.sh
```

### Rust Development
```bash
./scripts/rust-dev.sh
```

### Additional Stuff
```bash
./scripts/cloud-engineering.sh
```

# Additional Setup
## tmux

> [!IMPORTANT]
> Remember to install plugins with `<tmux-prefix> + I`
