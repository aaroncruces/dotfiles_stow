if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    PROMPT='%F{cyan}%n@%m%f %F{green}%~%f %F{white}$%f '
else
    eval "$(oh-my-posh init zsh)"
fi