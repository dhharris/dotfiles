# Use tmux by default
if command -v tmux>/dev/null; then
  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
fi

# Append to history file
shopt -s histappend

# Use one command per line
shopt -s cmdhist

# Allow a larger history file
HISTSIZE=130000
HISTFILESIZE=-1

# Don't store specific lines
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'

# Record timestamps
HISTTIMEFORMAT='%F %T '

# Store history immediately
PROMPT_COMMAND='history -a'

# Default to pip3 instead of pip
alias pip='pip3'

# Set vim mode
set -o vi

# Use gmake as default version of make
#alias make=gmake

# Configure pyenv if it exists
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Easy mysql startup
alias mysql='/usr/local/mysql/bin/mysql'

# Set default editor to vim (useful for svn propedit)
export EDITOR=vim

# Set default C compiler (Clang if available)
command -v clang >/dev/null 2>&1 && export CC=clang
    

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
export PATH="/usr/local/opt/llvm/bin:$PATH"
