# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Fish function for `lla` alias.
#
# Description:
#   Provides an `lla` shortcut for detailed listing using `eza -lab`.
#   Falls back to `ls -lah` if `eza` is not found.
#
# Usage: lla [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: Arguments passed to `lla`, forwarded to `eza -lab` or `ls -lah`.
#
#
# See also: `eza`, `ls (function)`, `la (function)`, `ll (function)`,
#           `lla (function)`
function lla --description "List detailed directory contents, including hidden files."
    if type -q eza
        eza -lab $argv
    else
        command ls -lah $argv
    end
end


