# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Description (detailed):
#   This function provides a consistent entry point for the 'bat' binary,
#   automatically resolving to 'batcat' on Debian/Ubuntu systems where the
#   executable is renamed, or to 'bat' on other systems.
#
# Usage: bat [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: All arguments passed to the 'bat' command. These are directly
#          forwarded to 'batcat' or 'command bat'.
#
# Examples:
#   bat main.rs                 # Displays with syntax highlighting.
#   bat --paging=never log.txt  # Views log without automatically piping to a
#                               # pager.
#
# See also: 'batcat'
function bat --description "Invoke the modern 'bat' file viewer (resolves 'batcat' if needed)."
    if type -f -q batcat
        command batcat $argv
    else if type -f -q bat
        command bat $argv
    else
        command cat $argv
    end
end
