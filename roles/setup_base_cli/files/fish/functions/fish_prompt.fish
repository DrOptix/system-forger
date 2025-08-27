# THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST
#
# Custom fish prompt following this pattern:
#
# ```
# [HH:MM] user@host:cwd (git branch) |
# ```
#
# `cwd` is the actual name of the CWD, not its path
# `git branch` will appear only when inside a git repository

function fish_prompt
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    set_color yellow
    echo -n (whoami)
    set_color normal
    echo -n "@"
    set_color blue
    echo -n (hostname)
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ":"
        set_color yellow
        echo -n (basename $PWD)
    end

    set_color green
    printf "%s " (__fish_git_prompt)
    set_color red
    echo -n "| "
    set_color normal
end
