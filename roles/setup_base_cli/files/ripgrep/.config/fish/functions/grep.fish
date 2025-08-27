# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Description:
#   This function replaces the default `grep` utility with the feature-rich
#   `rg`.
#
#   It falls back to the original `grep` if `rg` is not found.
#
# Usage: grep [OPTION...] PATTERNS [FILE...]
#
# Arguments:
#   $argv: All arguments passed to the 'rg' command. These are directly
#          forwarded to 'rg' or 'command grep'.
#
# See also: `grep`
function grep --description "Grep with modern enhancements"
    if type -q rg
        rg $argv
    else
        command grep $argv
    end
end

