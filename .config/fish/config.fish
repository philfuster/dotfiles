if status is-interactive; and test (uname) = Linux
    # set up alias for dealing with dotfile git repo
    function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
    end

    function gtw -d 'navigate to nextgen directory'
        pushd ~/code/projects/storis/nextgen/
    end

    function :ngcd -d 'clean install of nextgen dependencies'
        pushd ~/code/projects/storis/nextgen/
        pnpm install && pnpm dedupe && pnpm install
        popd
    end

    function :ngpnpm -d 'run pnpm commands in nextgen using nvm version'
        pushd ~/code/projects/storis/nextgen/
        nvm use >/dev/null
        ~/.local/share/nvm/v22.14.0/bin/pnpm $argv
        popd
    end

    # set up keychain so you don't have to enter passphrases all the time for ssh
    function fish_keychain -d "add ssh key to keychain"
        set SSH_PRIVATE_KEYS ~/.ssh/id_rsa
        if test (uname) = Linux
            SHELL=fish keychain --agents ssh --quiet --eval $SSH_PRIVATE_KEYS \
                | source
        end
    end

    # set -gx SSH_AUTH_SOCK=$(npiperelay.exe -ei -s //./pipe/openssh-ssh-agent)

    # pnpm standalone is never used
    set -gx PNPM_HOME "/home/paf/.local/share/pnpm/"
    function gpnpm -d "use the global pnpm install"
        set -fx PATH "$PNPM_HOME" $PATH
        pnpm $argv
    end

    # set user local bin paths
    set -U fish_user_paths ~/.local/bin /opt/nvim-linux-x86_64/bin $fish_user_paths

    # set up keychain for github ssh and prompt for passphrase
    # off right now because accepting input on start up doesn't work with warp
    # on windows right now
    # fish_keychain
end

set -g fish_greeting

# if not string match -q -- $PNPM_HOME $PATH
#   set -gx PATH "$PNPM_HOME" $PATH
# end
# pnpm end
