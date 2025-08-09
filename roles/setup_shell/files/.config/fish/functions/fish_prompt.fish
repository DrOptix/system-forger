# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

# This function customized the prompt used by fish shell
function fish_prompt
    # Print time
    set_color brblack
    echo -n "["(date "+%H:%M")"] "

    # Print user
    set_color yellow
    echo -n (whoami)

    # Print user / hostname separator
    set_color normal
    echo -n "@"

    # Print hostname
    set_color blue
    echo -n (uname -n)

    # Print host / PWD separator
    set_color brblack
    echo -n ":"

    # Print short PWD
    set_color yellow
    echo -n (prompt_pwd)

    # Git branch information
    set_color green
    printf "%s " (__fish_git_prompt)

    # Print prompt indicator
    set_color red
    echo -n "▶ "

    # Ensure the color is reset for the user's input
    set_color normal
end
