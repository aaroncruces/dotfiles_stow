# LOADED ONCE AT TTY
# priority 1: before .zprofile
# environment variables that are available to other programs in a Zsh session

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export TERM=xterm-256color
# si no, git no firma los commits
export GPG_TTY=$(tty)

