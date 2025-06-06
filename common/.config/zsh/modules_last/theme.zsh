if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    unset PROMPT
    PROMPT='%F{cyan}%n@%m%f %F{green}%~%f %F{white}$%f '
else
    unset PROMPT
    eval "$(oh-my-posh init zsh)"
fi