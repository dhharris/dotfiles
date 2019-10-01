#!/bin/bash

##### Helper functions #####

command_exists () {
    type "$1" &> /dev/null ;
}

backup() {
    if [ ! -d "$backup_dir" ]; then
        mkdir "$backup_dir"
        echo "Backup directory $backup_dir created."
    fi

    if [ -f "$1" ]; then
        echo "$1"
        mv "$1" "$backup_dir"
        echo "$1 is backed up in $backup_dir"
    fi
}

link() {
    # @params src, dst
    if [[ -f $1 ]]; then
        if [[ -f $2 ]]; then
            file1sum=$(shasum -a 256 "$1" | cut -d ' ' -f 1)
            file2sum=$(shasum -a 256 "$1" | cut -d ' ' -f 1)
            if [ "x$file1sum" = "x$file2sum" ]; then
                return
            else
                backup "$2"
            fi
        fi
        # Make the directory if it does not exist
        mkdir -p "$(dirname "$2")"
        ln -sf "$1" "$2" 2>/dev/null
        echo "$2 is successfully linked."
        ((link_counter++))
    fi
}

brew_install_or_nag() {
    # @params pkg
    if ! command_exists brew; then
        echo "Homebrew not detected. Please install $1 manually."
    else
        brew update
        brew install "$1"
        ((deps_counter++))
    fi
}

clone_or_pull() {
    # @params repo, dir_name
    if [ ! -d "$2" ]; then
        echo "Installing $1..."
        git clone "$1" "$2"
    elif [ -d "$2/.git" ]; then
        git -C "$2" pull "$1"
    elif [ -d "$2/.hg" ]; then
        hg pull --cwd "$2" -u
    fi
}

install_hg_plugin() {
    if [[ $(hostname -s) = dev* ]]; then
        return
    fi
    if ! [[ -d $HOME/.hgext/ ]]; then
        mkdir -p "$HOME"/.hgext
    fi
    plugin_name=$(echo "$1" | rev | cut -d '/' -f 1 | rev)
    if ! [[ -d $HOME/.hgext/$plugin_name ]]; then
        cd "$HOME"/.hgext || return
        echo "Installing $plugin_name..."
        hg clone "$1"
        ((deps_counter++))
    fi

}

##### Set helper vars #####
backup_dir="/tmp/dotfiles_$(date +%Y%m%d)"
dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mpd=$HOME/.config/mpd
sshh=$HOME/.sshh
scripts=$HOME/scripts
vundle=$HOME/.vim/bundle/Vundle.vim
tridactyl=$HOME/.tridactyl
deps_counter=0
link_counter=0

##### Check for updates in remote #####
clone_or_pull https://github.com/dhharris/dotfiles.git "$dotfiles"

##### Dependencies #####
## MacOS Specific ##

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Check if homebrew is installed, and update
    if ! command_exists brew; then 
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        ((deps_counter++)) 
    fi

    if ! command_exists reattach-to-user-namespace; then
        brew update
        brew install reattach-to-user-namespace
        ((deps_counter++))
    fi
    # Install tridactyl native
    clone_or_pull https://github.com/tridactyl/tridactyl.git "$tridactyl"
    bash "$tridactyl"/native/install.sh > /dev/null
    link "$dotfiles"/vim/tridactylrc "$HOME"/.tridactylrc
fi

## All other deps ##

# Clone or update git repo deps
clone_or_pull https://github.com/VundleVim/Vundle.vim.git "$vundle"
clone_or_pull https://github.com/yudai/sshh.git "$sshh"
clone_or_pull https://github.com/dhharris/scripts.git "$scripts"

if ! command_exists tmux; then
    echo "Installing tmux..."
    brew_install_or_nag tmux
fi

if [ ! -x "$sshh"/sshh ]; then
    echo "Installing sshh..."
    chmod a+x "$sshh"/sshh
    ((deps_counter++))
fi

# Make scripts executable
for i in "$scripts"/*
do
    if [ ! -x "$i" ]; then
        echo "Installing $i"
        chmod a+x "$i"
        ((deps_counter++))
    fi
done

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

# Install hg packages
if command_exists hg; then
    install_hg_plugin https://bitbucket.org/facebook/hg-experimental
    install_hg_plugin https://bitbucket.org/durin42/hg-git
fi

##### Install symlinks #####
echo "Linking dotfiles..."
link "$dotfiles"/shell/bash_profile "$HOME"/.bash_profile
link "$dotfiles"/shell/bashrc "$HOME"/.bashrc
link "$dotfiles"/shell/inputrc "$HOME"/.inputrc

link "$dotfiles"/git/gitconfig "$HOME"/.gitconfig
link "$dotfiles"/hg/hgrc "$HOME"/.hgrc

link "$dotfiles"/mysql/myclirc "$HOME"/.myclirc

link "$dotfiles"/py/flake8 "$HOME"/.config/flake8

link "$dotfiles"/tmux/tmux.conf "$HOME"/.tmux.conf

link "$dotfiles"/vim/clang-format "$HOME"/.clang-format

link "$dotfiles"/gnupg/gpg-agent.conf "$HOME"/.gnupg/gpg-agent.conf

link "$dotfiles"/beets/config.yaml "$HOME"/.config/beets/config.yaml
link "$dotfiles"/vim/vimrc "$HOME"/.vimrc

# mpd config is stored in different directories depending on the system
if [[ "$OSTYPE" == "darwin"* ]]; then
    link "$dotfiles"/mpd/mpd.conf "$HOME"/.mpdconf
else
    link "$dotfiles"/mpd/mpd.conf "$mpd"/mpd.conf
fi

# Make controlmaster directory used by ssh_config
# FIXME: I think there is a better place to put this...
mkdir -p "$HOME"/.ssh/controlmaster
link "$dotfiles"/ssh/ssh_config "$HOME"/.ssh/config

# Install or update Vundle Plugins
# Must be done *after* vimrc is linked
if [ ! -d "$HOME"/.vim/bundle/Vundle.vim ]; then
    echo "Installing Vundle plugins..."
    vim --not-a-term +PluginInstall +qall > /dev/null
    ((deps_counter++))
else
    last_updated=$(cat "$vundle"/.last.updated 2>/dev/null)
    delta=$(($(date +%s) - ${last_updated:=0}))
    if [[ $delta -ge 86400 ]]; then
        echo "Updating Vundle plugins..."
        vim --not-a-term +PluginUpdate +PluginClean +qall > /dev/null
        date +%s > "$vundle"/.last.updated
    fi
fi

if (( link_counter == 0 )); then
    echo "Nothing to link"
else
    echo "Linked $link_counter file(s)"
fi

if (( deps_counter == 0 )); then
    echo "No dependencies to install"
else
    echo "Installed $deps_counter dependencies"
fi
