# Function to sign in to 1Password and update the tmux environment

function op-signin --description "Sign in to 1Password and export session to tmux"
    # 1. Perform the standard sign-in and get the session token
    # Fish doesn't use eval $() syntax, we need to use 'source'
    op signin | source

    # 2. Check if we are inside a tmux session
    if set -q TMUX
        # 3. Extract the session variable name and value
        set -l op_session_var (env | grep OP_SESSION)

        if test -n "$op_session_var"
            # 4. Tell tmux to set this variable for all future panes/windows
            tmux set-environment -g $op_session_var
            echo "1Password session token exported to tmux environment."
        end
    end
end
