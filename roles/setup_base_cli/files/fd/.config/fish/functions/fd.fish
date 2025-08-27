# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# Description:
#   This function provides a consistent entry point for the 'fd' binary,
#   automatically resolving to 'fdfind' on Ubuntu systems where the executable
#   is renamed, or to 'fd' on other systems.
#
# Usage: fd [OPTIONS] [FILE...]
#
# Arguments:
#   $argv: All arguments passed to the `fd` command. These are directly
#          forwarded to 'fdfind' or 'command fd'.
#
# See also: `fdfind`
function fd --description "Invoke the modern `fd` (resolves `fdfind` if needed)."
    if type -q fdfind
        fdfind $argv
    else if type -q fd
        command fd $argv
    end
end
