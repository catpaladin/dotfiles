# Dotfiles

Personal dotfiles for development environments, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Directory | Description |
|-----------|-------------|
| `nvim/` | Neovim configuration |
| `tmux/` | tmux configuration |
| `zsh/` | Zsh configuration (`.zsh.d/` modules) |
| `bash/` | Bash configuration |
| `alacritty-darwin/` | Alacritty terminal config (macOS) |
| `alacritty-linux/` | Alacritty terminal config (Linux) |
| `scripts/` | Development environment setup scripts |

## Installation

### 1. Clone the repository
```bash
git clone --recurse-submodules https://github.com/catpaladin/dotfiles.git
cd dotfiles
```

### 2. Run setup
```bash
./setup.sh
```

This will:
- Symlink all configuration files to your home directory using `stow`
- Back up any existing conflicting files
- Configure your `.zshrc` to source the `.zsh.d/` modules

### 3. Update submodules (if needed)
```bash
git submodule update --recursive --remote
```

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) - Install via `brew install stow` (macOS) or `apt install stow` (Linux)
- [Nerd Fonts](https://www.nerdfonts.com/) v3+ - Required for icons in terminal

> [!NOTE]
> For Linux, you can use `./scripts/install-font-linux.sh` to install Nerd Fonts.

## Development Environment Scripts

Setup scripts for various development environments. Each script installs version managers and essential tools.

### Python Development
```bash
./scripts/python-dev.sh
```
Installs: `pyenv`, latest Python, `black`, `isort`, `mypy`, `ruff`, `pytest`, `ipython`

### Terraform Development
```bash
./scripts/terraform-dev.sh
```
Installs: `tfenv`, latest Terraform, `tflint`, `terraform-docs`

### Go Development
```bash
./scripts/go-dev.sh
```
Installs: `goenv`, `golangci-lint`, `golines`, `gofumpt`, `cobra-cli`, `air`, `swag`

### TypeScript/Node.js Development
```bash
./scripts/typescript-dev.sh
```
Installs: `nvm`, Node.js LTS, `yarn`, `bun`, `typescript`, `ts-node`, `eslint`, `prettier`

### Rust Development
```bash
./scripts/rust-dev.sh
```

## Post-Installation

### tmux

> [!IMPORTANT]
> After setup, open tmux and install plugins with `<prefix> + I`

### Zsh

Your custom zsh configurations live in `~/.zsh.d/`. The setup script ensures your `.zshrc` sources all `*.zsh` files from this directory, so install scripts can modify `.zshrc` without affecting your tracked configurations.
