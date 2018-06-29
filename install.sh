#!/bin/sh
counter=0

##### Helper functions #####

command_exists () {
    type "$1" &> /dev/null ;
}

backup() {
    if [ ! -d $backup_dir ]; then
        mkdir "$backup_dir"
        echo "Backup directory $backup_dir created."
    fi

    if [ -f $1 ]; then
        echo $1
        mv $1 $backup_dir
        echo "$1 is backed up in $backup_dir"
    fi
}

link() {
  if ! diff $1 $2 &>/dev/null; then
    backup $2; ln -sf $1 $2 2>/dev/null

    echo "$2 is successfully linked."

    if [ "$2" == "zshrc" ]; then restart_required=true; fi
  fi
}

##### Backup currently used dotfiles #####
backup_dir="/tmp/dotfiles_$(date +%Y%m%d)"
bin=/usr/local/bin
dotfiles=$HOME/dotfiles
restart_required=false

##### Dependencies #####

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
    echo "No dependencies to install"
else
    echo "Installed $counter dependencies"
fi

##### Install symlinks #####
#link $dotfiles/bash_profile $HOME/.bash_profile
