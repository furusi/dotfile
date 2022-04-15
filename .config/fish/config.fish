set -gx HOMEBREW_DIR_A '/opt/homebrew'
set -gx HOMEBREW_DIR_I '/usr/local'
set -gx GOPATH $HOME/go/
set -gx EDITOR 'emacs'

set MY_ARCH (uname -m)
set MY_OS (uname -s)

#mac
if test $MY_OS = "Darwin"
    # arm mac
    if test $MY_ARCH = "arm64"
        set -gx BEERHALL $HOME/BeerHall
        # homebrew
        function armbrew --wraps brew
            set -lx PATH $HOMEBREW_DIR_A/bin /usr/bin /bin $HOMEBREW_DIR_A/sbin /usr/sbin /sbin
            $HOMEBREW_DIR_A/bin/brew $argv
        end
        function intelbrew --wraps brew
            set -lx PATH $HOMEBREW_DIR_I/bin /usr/bin /bin $HOMEBREW_DIR_I/sbin /usr/sbin /sbin
            arch --x86_64 $HOMEBREW_DIR_I/bin/brew $argv
        end
    end
end

if command -v starship > /dev/null
    starship init fish | source
end

# gpg-agent
if test -z "$INSIDE_EMACS"
    set -e SSH_AUTH_SOCK
    set -U -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    set -x GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
end

function e
    emacsclient -nw -a ""
end
function ekill
emacsclient -e "(kill-emacs)"
end
function cd-rootdir-git
    cd (git rev-parse --show-toplevel)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
