if status is-interactive; and test (uname) = Linux
    # set up alias for dealing with dotfile git repo
    function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
    end

    # set up keychain so you don't have to enter passphrases all the time for ssh
    function fish_keychain -d "add ssh key to keychain"
        set SSH_PRIVATE_KEYS ~/.ssh/id_rsa
        if test (uname) = Linux
            SHELL=fish keychain --agents ssh --quiet --eval $SSH_PRIVATE_KEYS \
                | source
        end
    end

    # set user local bin paths
    set -U fish_user_paths ~/.local/bin $fish_user_paths

    # wait for /run/user/1000 (tmp directory for usr processes) before launching tmux so environment has all context needed
    while test ! -d /run/user/1000/
        sleep 1 &
        wait
    end
    if [ (ps aux | grep tmux | grep -v grep | count) -le 0 ]
        tmux
    end

    # set up keychain for github ssh
    fish_keychain
end

# pnpm
set -gx PNPM_HOME "/home/paf/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -g fish_greeting
