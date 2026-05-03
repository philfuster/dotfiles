function _nim_prompt_wrapper
    set -l retc $argv[1]
    set -l field_name $argv[2]
    set -l field_value $argv[3]
    set -l bracket_color $argv[4]

    set_color normal
    set_color $retc
    echo -n '─'
    set_color -o $bracket_color
    echo -n '['
    set_color normal
    test -n "$field_name"
    and echo -n $field_name:
    set_color $retc
    echo -n $field_value
    set_color -o $bracket_color
    echo -n ']'
end

function fish_prompt
    # This prompt shows:
    # - green lines if the last return command is OK, red otherwise
    # - your user name, in red if root or yellow otherwise
    # - your hostname, in cyan if ssh or blue otherwise
    # - the current path (with prompt_pwd)
    # - date +%X
    # - the current virtual environment, if any
    # - the current git status, if any, with fish_git_prompt
    # - the current battery state, if any, and if your power cable is unplugged, and if you have "acpi"
    # - current background jobs, if any

    # It goes from:
    # ┬─[nim@Hattori:~]─[11:39:00]
    # ╰─>$ echo here

    # To:
    # ┬─[nim@Hattori:~/w/dashboard]─[11:37:14]─[V:django20]─[G:master↑1|●1✚1…1]─[B:85%, 05:41:42 remaining]
    # │ 2    15054    0%    arrêtée    sleep 100000
    # │ 1    15048    0%    arrêtée    sleep 100000
    # ╰─>$ echo there

    set -l last_status $status

    # Palette — switchable via $nim_theme universal var. Default = original (work).
    # Plain `set` (no -l) so vars are function-scoped, not block-scoped.
    if test "$nim_theme" = knicks
        # Knicks: Blue / Orange / Silver
        set c_ok 1E90FF
        set c_fail red
        set c_bracket BEC0C2
        set c_user F58426
        set c_user_root red
        set c_at BEC0C2
        set c_host_local 1E90FF
        set c_host_ssh cyan
        set c_path BEC0C2
        set c_mode_n red
        set c_mode_i 1E90FF
        set c_mode_r1 1E90FF
        set c_mode_r cyan
        set c_mode_v F58426
        set c_jobs F58426
        set c_dollar F58426
    else
        set c_ok green
        set c_fail red
        set c_bracket green
        set c_user yellow
        set c_user_root red
        set c_at white
        set c_host_local blue
        set c_host_ssh cyan
        set c_path white
        set c_mode_n red
        set c_mode_i green
        set c_mode_r1 green
        set c_mode_r cyan
        set c_mode_v magenta
        set c_jobs brown
        set c_dollar red
    end

    set -l retc $c_fail
    test $last_status = 0; and set retc $c_ok

    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto

    set_color $retc
    echo -n '┬─'
    set_color -o $c_bracket
    echo -n [

    if functions -q fish_is_root_user; and fish_is_root_user
        set_color -o $c_user_root
    else
        set_color -o $c_user
    end

    echo -n $USER
    set_color -o $c_at
    echo -n @

    if test -z "$SSH_CLIENT"
        set_color -o $c_host_local
    else
        set_color -o $c_host_ssh
    end

    echo -n (prompt_hostname)
    set_color -o $c_path
    echo -n :(prompt_pwd)
    set_color -o $c_bracket
    echo -n ']'

    # Date
    _nim_prompt_wrapper $retc '' (date +%X) $c_bracket

    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        set -l mode
        switch $fish_bind_mode
            case default
                set mode (set_color --bold $c_mode_n)N
            case insert
                set mode (set_color --bold $c_mode_i)I
            case replace_one
                set mode (set_color --bold $c_mode_r1)R
            case replace
                set mode (set_color --bold $c_mode_r)R
            case visual
                set mode (set_color --bold $c_mode_v)V
        end
        set mode $mode(set_color normal)
        _nim_prompt_wrapper $retc '' $mode $c_bracket
    end


    # Virtual Environment
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and _nim_prompt_wrapper $retc V (basename "$VIRTUAL_ENV") $c_bracket

    # git
    set -l prompt_git (fish_git_prompt '%s')
    test -n "$prompt_git"
    and _nim_prompt_wrapper $retc G $prompt_git $c_bracket

    # Battery status
    type -q acpi
    and test (acpi -a 2> /dev/null | string match -r off)
    and _nim_prompt_wrapper $retc B (acpi -b | cut -d' ' -f 4-) $c_bracket

    # New line
    echo

    # Background jobs
    set_color normal

    for job in (jobs)
        set_color $retc
        echo -n '│ '
        set_color $c_jobs
        echo $job
    end

    set_color normal
    set_color $retc
    echo -n '╰─>'
    set_color -o $c_dollar
    echo -n '$ '
    set_color normal
end
