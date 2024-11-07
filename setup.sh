#!/usr/bin/env bash
# This script requires you have stow installed

# make sure we have pulled in and updated any submodules
git submodule init
git submodule update

# default linux for os specific
if [ $(uname) = 'Darwin' ]; then
  ALACRITTY=alacritty-darwin
else
  ALACRITTY=alacritty-linux
fi

# what directories should be installable by all users including the root user
base=(
    nvim
    tmux
    bash
    zsh
    $ALACRITTY
    backgrounds
    wezterm
)

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    usr=$1
    app=$2
    # -v verbose
    # -R recursive
    # -t target
    stow -v -R -t ${usr} ${app}
}

echo ""
echo "Stowing apps for user: ${whoami}"

# install apps available to local users and root
for app in ${base[@]}; do
    stowit "${HOME}" $app
done

echo ""
echo "##### ALL DONE"
