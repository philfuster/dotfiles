if status is-interactive
    # Commands to run in interactive sessions can go here
    function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
    end
end
set -U fish_user_paths ~/.local/bin $fish_user_paths

# set up ssh agent
function __ssh_agent_is_started -d "check if ssh agent is already started"
    if begin
            test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"
        end
        source $SSH_ENV >/dev/null
    end

    if test -z "$SSH_AGENT_PID"
        return 1
    end

    # if no pgrep
    #ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent

    pgrep ssh-agent
    return $status
end

function __ssh_agent_start -d "start a new ssh agent"
    ssh-agent -c | sed 's/^echo/#echo/' >$SSH_ENV
    chmod 600 $SSH_ENV
    source $SSH_ENV >/dev/null
    true # suppress errors from setenv, i.e. set -gx
end

function fish_ssh_agent -d "Start ssh-agent if not started yet, or uses already started ssh-agent."
    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end

    if not __ssh_agent_is_started
        __ssh_agent_start
    end
end

fish_ssh_agent
