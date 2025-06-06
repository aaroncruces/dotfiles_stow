# if in tty (including tmux)
# -z is "not set", -n is "set"
if [ -z "${DISPLAY}" ] && [ -n "${XDG_VTNR}" ]; then
    unset PROMPT
    PROMPT='%F{cyan}%n@%m%f %F{green}%~%f %F{white}$%f '
else
# if in ssh or gui (including tmux)
    unset PROMPT
    eval "$(oh-my-posh init zsh)"
fi