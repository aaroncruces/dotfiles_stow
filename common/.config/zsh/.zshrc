# LOADED ALWAYS
# priority 3: after .zprofile, before .zlogin

for zshrc_module in ~/.config/zsh/modules_first/*; do
    source "$zshrc_module"
done

for zshrc_module in ~/.config/zsh/modules/*; do
    source "$zshrc_module"
done

for zshrc_module in ~/.config/zsh/modules_last/*; do
    source "$zshrc_module"
done


