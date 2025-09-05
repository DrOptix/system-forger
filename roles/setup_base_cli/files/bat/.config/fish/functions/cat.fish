# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Description (detailed):
#   This function replaces the default 'cat' utility with the feature-rich 'bat'
#   or 'batcat' (on Debian/Ubuntu systems), when available.
#
#   It automatically detects which modern pager is available, providing syntax
#   highlighting, line numbers, and 'git' integration.
#
#   It falls back to the original 'cat' if neither 'bat' nor 'batcat' is found.
#
# Usage: cat [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: All arguments passed to the 'cat' command. These are directly
#          forwarded to 'bat', 'batcat', or 'command cat'.
#
# Examples:
#   cat myfile.txt              # Displays file with syntax highlighting (via 'bat').
#   cat -p raw.log              # Displays file without highlighting (via 'bat' plain output).
#   cat file1.txt file2.txt     # Concatenates multiple files (via 'bat').
#   cat <(command history)      # Pipes output to 'bat'.
#
# See also: 'bat (command)', 'batcat'
function cat --description "View file contents with modern enhancements ('bat'/'batcat')."
    if type -f -q batcat
        command batcat $argv
    else if type -f -q bat
        command bat $argv
    else
        command cat $argv
    end
end
