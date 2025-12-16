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
        set -l ENV_FILE ~/.config/fish/.env

        # Check .env file exists
        if not test -f $ENV_FILE
            echo "Error: $ENV_FILE not found. Copy .env.template and configure it."
            return 1
        end

        # Check dependencies
        if not command -q expect
            echo "Error: 'expect' command not found. Install with: sudo apt install expect"
            return 1
        end

        if not command -q keychain
            echo "Error: 'keychain' command not found. Install with: sudo apt install keychain"
            return 1
        end

        # Source .env file to load SSH_PRIVATE_KEYS and SSH_KEY_PASSPHRASE
        source $ENV_FILE

        # Validate required variables
        if not set -q SSH_PRIVATE_KEYS; or test -z "$SSH_PRIVATE_KEYS"
            echo "Error: SSH_PRIVATE_KEYS not set in $ENV_FILE"
            return 1
        end

        if not set -q SSH_KEY_PASSPHRASE; or test -z "$SSH_KEY_PASSPHRASE"
            echo "Error: SSH_KEY_PASSPHRASE not set in $ENV_FILE"
            return 1
        end

        # Expand tilde and validate key file exists
        set -l expanded_keys (string replace '~' $HOME $SSH_PRIVATE_KEYS)
        if not test -f $expanded_keys
            echo "Error: SSH key file not found: $expanded_keys"
            return 1
        end

        if test (uname) = Linux
            # Export passphrase for expect to access via $env()
            set -x SSH_KEY_PASSPHRASE $SSH_KEY_PASSPHRASE

            # Use expect to automate passphrase entry
            expect -c "
                set timeout 30
                log_user 0
                spawn env SHELL=fish keychain --agents ssh $expanded_keys
                expect {
                    -re {Enter passphrase.*:} {
                        send -- \"\$env(SSH_KEY_PASSPHRASE)\n\"
                        exp_continue
                    }
                    -re {Bad passphrase} {
                        exit 1
                    }
                    timeout {
                        exit 1
                    }
                    eof
                }
            " >/dev/null 2>&1

            # Check expect exit status
            if test $status -ne 0
                echo "Error: Failed to unlock SSH keys"
                return 1
            end

            # Source keychain environment variables
            eval (keychain --eval --agents ssh $expanded_keys 2>/dev/null)
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
    set -U fish_user_paths ~/.local/bin /opt/nvim-linux-x86_64/bin $fish_user_paths /usr/local/go/bin

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
