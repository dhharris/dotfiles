#!/bin/bash
packages=("reattach-to-user-namespace" "shellcheck" "tmux" "vim")

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Not macOS. Exiting."
    exit
fi

if ! [ -x "$(command -v brew)" ]; then
    echo "Installing homebrew..."
    curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
fi

for pkg in ${packages[@]}; do
    if ! [ -x "$(command -v $pkg)" ]; then
        echo "Installing $pkg..."
        brew install $pkg
    fi
done
