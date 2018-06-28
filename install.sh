#!/bin/sh
counter=0

command_exists () {
    type "$1" &> /dev/null ;
}

# Check if homebrew is installed, and update
if ! command_exists brew; then 
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ((counter++)) 
fi

if ! command_exists reattach-to-user-namespace; then
    brew update
    brew install reattach-to-user-namespace
    ((counter++))
fi

if ! command_exists tmux; then
    echo "Installing tmux..."
    brew update
    brew install tmux
    ((counter++))
fi

if ! command_exists hg; then
    echo "Installing mercurial..."
    brew update
    brew install mercurial
    ((counter++))
fi

# Install Vundle
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo "Installing Vundle..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "Installing Vundle plugins..."
    vim +PluginInstall +qall
    ((counter++))
fi

# Install hg-experimental package
if [ ! -d ~/.hgext/hg-experimental ]; then
    echo "Installing hg extensions..."
    mkdir -p ~/.hgext
    cd ~/.hgext
    hg clone https://bitbucket.org/facebook/hg-experimental
    ((counter++))
fi

if (( $counter == 0 )); then
    echo "Nothing to do"
else
    echo "Done!\nRestart Terminal for changes to take effect."
fi
