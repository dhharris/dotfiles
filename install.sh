#!/bin/bash

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
    if [[ -f $1 ]]; then
    	if [[ -f $2 ]]; then
	    file1sum=$(shasum -a 256 $1 | cut -d ' ' -f 1)
	    file2sum=$(shasum -a 256 $1 | cut -d ' ' -f 1)
	    if [ "x$file1sum" = "x$file2sum" ]; then
		return
	    else
	    	backup $2
	    fi
        fi
	ln -sf $1 $2 2>/dev/null
        echo "$2 is successfully linked."
    fi
}

brew_install_or_nag() {
    if ! command_exists brew; then
        echo "Homebrew not detected. Please install $1 manually."
    else
        brew update
        brew install "$1"
	((counter++))
    fi
}

##### Set helper vars #####
backup_dir="/tmp/dotfiles_$(date +%Y%m%d)"
dotfiles=$HOME/dotfiles
mpd=$HOME/.config/mpd
counter=0

##### Dependencies #####

## MacOS Specific ##

# Check if homebrew is installed, and update
if uname | grep -q Darwin; then
    if ! command_exists brew; then 
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        ((counter++)) 
    fi

    if ! command_exists reattach-to-user-namespace; then
        brew update
        brew install reattach-to-user-namespace
        ((counter++))
    fi
fi

# Check for ~/.config directory
if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi

if ! command_exists tmux; then
    echo "Installing tmux..."
    brew_install_or_nag tmux
fi

if ! command_exists python; then
    echo "Installing tmux..."
    brew_install_or_nag python
fi

if ! command_exists flake8; then
    echo "Installing flake8..."
    brew_install_or_nag flake8
    pip install flake8-bugbear
fi

if ! command_exists hg; then
    echo "Installing mercurial..."
    brew_install_or_nag mercurial
fi

# Must link vimrc before installing vim plugins
link $dotfiles/vim/vimrc $HOME/.vimrc

# Install Vundle & Plugins
if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
    echo "Installing Vundle..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "Installing Vundle plugins..."
    vim +PluginInstall +qall
    ((counter++))
fi

# Install hg-experimental package
if ! [[ -d $HOME/.hgext/hg-experimental || $(hostname -s) = dev* ]]; then
    echo "Installing hg extensions..."
    mkdir -p $HOME/.hgext
    cd $HOME/.hgext || return
    hg clone https://bitbucket.org/facebook/hg-experimental
    ((counter++))
fi

if (( counter == 0 )); then
    echo "No dependencies to install"
else
    echo "Installed $counter dependencies"
fi

##### Install symlinks #####
echo "Linking dotfiles..."
link $dotfiles/shell/bash_profile $HOME/.bash_profile
link $dotfiles/shell/bashrc $HOME/.bashrc
link $dotfiles/shell/inputrc $HOME/.inputrc

link $dotfiles/git/gitconfig $HOME/.gitconfig
link $dotfiles/hg/hgrc $HOME/.hgrc


link $dotfiles/py/flake8 $HOME/.config/flake8

link $dotfiles/tmux/tmux.conf $HOME/.tmux.conf

link $dotfiles/vim/clang-format $HOME/.clang-format

link $dotfiles/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

if [[ "$OSTYPE" == "darwin"* ]]; then
    link $dotfiles/mpd/mpd.conf $HOME/.mpdconf
else
    # Create mpd config directory if it doesn't exist
    if [ ! -d "$mpd" ]; then
        mkdir $mpd
    fi
    link $dotfiles/mpd/mpd.conf $mpd/mpd.conf
fi
