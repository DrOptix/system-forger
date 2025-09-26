# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [[ -z "$FISH_IS_RUNNING" ]] && command -v fish &>/dev/null; then
    # Prevent infinite loops if fish somehow fails and returns to bash
    export FISH_IS_RUNNING=1
    exec fish
fi
