# Fix Kartograph python library (GDAL requirement)
export PYTHONPATH=$PYTHONPATH:/Library/Frameworks/GDAL.framework/Versions/1.11/Python/2.7/site-packages


# Default to pip3 instead of pip
alias pip='pip3'

# Set vim mode
set -o vi

# Put rust stuff on the PATH
source $HOME/.cargo/env

# Use gmake as default version of make
#alias make=gmake

# Easy mysql startup
alias mysql='/usr/local/mysql/bin/mysql'

# Set default editor to vim (useful for svn propedit)
export EDITOR=vim

# On OS X, the trash utility moves files to the trash.
# This alias prevents me from accidentally deleting things
# that may be important.
#alias rm=trash

# Change bash prompt
export PS1="[\u@\h \W]\\$ "

# Improve ls with colors, etc
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

# Make grep use colors by default
export GREP_OPTIONS='--color=auto'

cdf() {
        target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
        if [ "$target" != "" ]; then
                cd "$target"; pwd
        else
                echo 'No Finder window found' >&2
        fi
}

# Set default console font to Terminus
# May be a different command on your system
#vidcontrol -f 8x16 ~/.config/ter-u16n.fnt
export PATH="/usr/local/sbin:$PATH"
