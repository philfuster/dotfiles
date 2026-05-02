function theme --description "Switch fish theme between work (Dracula) and knicks (Blue/Orange/Silver)"
    switch "$argv[1]"
        case knicks
            set -U nim_theme knicks

            set -U fish_color_command 1E90FF
            set -U fish_color_keyword 1E90FF
            set -U fish_color_param BEC0C2
            set -U fish_color_quote F58426
            set -U fish_color_redirection F58426
            set -U fish_color_operator F58426
            set -U fish_color_error ff5555
            set -U fish_color_escape F58426
            set -U fish_color_comment 7a7d80
            set -U fish_color_autosuggestion 4a4d50
            set -U fish_color_normal BEC0C2
            set -U fish_color_user F58426
            set -U fish_color_host 1E90FF
            set -U fish_color_host_remote cyan
            set -U fish_color_cwd BEC0C2
            set -U fish_color_cwd_root red
            set -U fish_color_end F58426
            set -U fish_color_status red
            set -U fish_color_cancel ff5555 --reverse
            set -U fish_color_match --background=006BB6
            set -U fish_color_search_match --background=003a66
            set -U fish_color_selection --background=003a66
            set -U fish_color_valid_path --underline
            set -U fish_color_history_current --bold

            set -U fish_pager_color_prefix F58426
            set -U fish_pager_color_completion BEC0C2
            set -U fish_pager_color_description 7a7d80
            set -U fish_pager_color_progress F58426
            set -U fish_pager_color_selected_background --background=003a66
            set -U fish_pager_color_selected_completion BEC0C2
            set -U fish_pager_color_selected_description 7a7d80
            set -U fish_pager_color_selected_prefix F58426

            echo "Theme: Knicks (Blue / Orange / Silver). Open a new shell to see frame colors."

        case work default dracula
            set -e nim_theme

            set -U fish_color_command 8be9fd
            set -U fish_color_keyword
            set -U fish_color_param bd93f9
            set -U fish_color_quote f1fa8c
            set -U fish_color_redirection f8f8f2
            set -U fish_color_operator 50fa7b
            set -U fish_color_error ff5555
            set -U fish_color_escape ff79c6
            set -U fish_color_comment 6272a4
            set -U fish_color_autosuggestion 6272a4
            set -U fish_color_normal f8f8f2
            set -U fish_color_user 8be9fd
            set -U fish_color_host bd93f9
            set -U fish_color_host_remote
            set -U fish_color_cwd 50fa7b
            set -U fish_color_cwd_root red
            set -U fish_color_end ffb86c
            set -U fish_color_status red
            set -U fish_color_cancel ff5555 --reverse
            set -U fish_color_match --background=brblue
            set -U fish_color_search_match --background=44475a
            set -U fish_color_selection --background=44475a
            set -U fish_color_valid_path --underline
            set -U fish_color_history_current --bold

            set -U fish_pager_color_prefix 8be9fd
            set -U fish_pager_color_completion f8f8f2
            set -U fish_pager_color_description 6272a4
            set -U fish_pager_color_progress 6272a4
            set -U fish_pager_color_selected_background --background=44475a
            set -U fish_pager_color_selected_completion f8f8f2
            set -U fish_pager_color_selected_description 6272a4
            set -U fish_pager_color_selected_prefix 8be9fd

            echo "Theme: Default (Dracula). Open a new shell to see frame colors."

        case '' '*'
            set -l current default
            set -q nim_theme; and set current $nim_theme
            echo "Usage: theme <knicks|work>"
            echo "Current: $current"
    end
end
