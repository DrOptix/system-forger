# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Fish function for `ll` alias.
#
# Description:
#   Provides an `ll` shortcut for detailed listing using `eza -lb`.
#   Falls back to `ls -lh` if `eza` is not found.
#
# Usage: ll [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: Arguments passed to `ll`, forwarded to `eza -lb` or `ls -lh`.
#
#
# See also: `eza`, `ls (function)`, `la (function)`, `ll (function)`,
#           `lla (function)`
function ll --description "List detailed directory contents."
    if type -q eza
        eza -lb $argv
    else
        command ls -lh $argv
    end
end

