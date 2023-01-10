set -gx HOMEBREW_DIR_A '/opt/homebrew'
set -gx HOMEBREW_DIR_I '/usr/local'
set -gx GOPATH $HOME/go/
set -gx EDITOR 'emacs'

set MY_ARCH (uname -m)
set MY_OS (uname -s)

#mac
if test $MY_OS = "Darwin"
    eval (/usr/local/bin/brew shellenv)
    eval (/opt/homebrew/bin/brew shellenv)
    set -gx INFOPATH "/opt/homebrew/share/info/emacs" $INFOPATH "/usr/share/info"
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
function cd-git-rootdir
    cd (git rev-parse --show-toplevel)
end
# https://fishshell.com/docs/current/relnotes.html#fish-3-6-0-released-january-7-2023
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

abbr --add dotdot --regex '^\.\.+$' --function multicd

# opam
if [ -f $HOME/.opam/opam-init/init.fish ]
    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
end

# emacs
set -gx LSP_USE_PLISTS true

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH # ghcup-env

# starship(prompt)
set -gx STARSHIP_CONFIG $HOME/.config/starship/config.toml

