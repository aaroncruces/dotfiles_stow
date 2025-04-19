#! /bin/bash
stow -v --no-folding --target=$HOME --dir=$HOME/gits/dotfiles_stow/common .
stow -vD --target=$HOME --dir=$HOME/gits/dotfiles_stow/common .  