# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Fish function for `la` alias.
#
# Description:
#   Provides an `la` shortcut for listing, including hidden files, using
#   `eza -a`.
#   Falls back to `ls -a` if `eza` is not found.
#
# Usage: la [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: Arguments passed to `la`, forwarded to `eza -a` or `ls -a`.
#
#
# See also: `eza`, `ls (function)`, `la (function)`, `ll (function)`,
#           `lla (function)`
function la --description "List directory contents, including hidden files."
    if type -q eza
        eza -a $argv
    else
        command ls -a $argv
    end
end
