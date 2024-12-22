if status is-interactive
    # Commands to run in interactive sessions can go here
    function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
    end
    set -U fish_user_paths ~/.local/bin $fish_user_paths
end
