# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# This function implements a custom fish greeter that's shown for every new
# instance of fish.
#
# The following information is shown:
#
# - kernel version
# - uptime
# - hostname
function fish_greeting
    set -l bold_on "\\e[1m"
    set -l bold_off "\\e[0m"

    echo

    # Print Kernel
    set -l kernel_version (uname -ro)
    echo -en $bold_on"Kernel:"$bold_off
    echo (set_color green) $kernel_version (set_color normal)

    # Print uptime
    set -l uptime (uptime -p | sed "s/^up //")
    echo -en $bold_on"Uptime:"$bold_off
    echo (set_color green) $uptime (set_color normal)


    # Print hostname
    echo -en $bold_on"Hostname:"$bold_off
    echo (set_color green) $hostname (set_color normal)

    echo
end

