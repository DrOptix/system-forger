# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Fish function to override 'ls' with 'eza'.
#
# Description:
#   Overrides the default `ls` command with `eza`, a modern listing utility.
#   Provides syntax highlighting, `git` integration, and icons.
#   Falls back to `ls` if `eza` is not found.
#
# Usage: ls [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: Arguments passed to `ls`, forwarded to `eza` or `ls`.
#
# Examples:
#   ls                      # Lists current directory contents.
#   ls /tmp                 # Lists `/tmp` directory contents.
#
# See also: `eza`, `ls (function)`, `la (function)`, `ll (function)`,
#           `lla (function)`
function ls --description "List directory contents."
    if type -q eza
        eza $argv
    else
        command ls $argv
    end
end
