if status is-interactive
    # Commands to run in interactive sessions can go here

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

    set -U fish_user_paths ~/.local/bin $fish_user_paths
    fish_keychain
end
