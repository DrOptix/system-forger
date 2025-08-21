# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST
#
# Custom fish greeting showing:
#   - the current kernel version
#   - the current up time
#   - the current hostname

function fish_greeting
    echo

    # Print kernel version
    set_color normal
    set_color -o
    echo -n "Kernel: "
    set_color normal

    set_color green
    echo (uname -ro)
    set_color normal

    # Print uptime
    set_color normal
    set_color -o
    echo -n "Uptime: "
    set_color normal

    set_color green
    echo (uptime -p | sed "s/^up //")
    set_color normal

    # Print hostname
    set_color normal
    set_color -o
    echo -n "Hostname: "
    set_color normal

    set_color green
    echo (hostname)
    set_color normal
    echo
end
