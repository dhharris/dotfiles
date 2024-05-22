#!/bin/bash
packages=("coreutils" "tmux" "vim" "MisterTea/et/et")

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Not macOS. Exiting."
    exit
fi

if ! [ -x "$(command -v brew)" ]; then
    echo "MANUAL STEP REQUIRED: You need to install homebew."
    exit
fi

for pkg in ${packages[@]}; do
    if ! [ -x "$(command -v $pkg)" ]; then
        echo "Installing $pkg..."
        brew install $pkg
    fi
done
