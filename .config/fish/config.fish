set HOMEBREW_DIR_A '/opt/homebrew'
set HOMEBREW_DIR_I '/usr/local'
set GOPATH $HOME/go/
function armbrew --wraps brew
    set PATH $HOMEBREW_DIR_A/bin /usr/bin /bin $HOMEBREW_DIR_A/sbin /usr/sbin /sbin
    $HOMEBREW_DIR_A/bin/brew $argv
end
function intelbrew --wraps brew
    set PATH $HOMEBREW_DIR_I/bin /usr/bin /bin $HOMEBREW_DIR_I/sbin /usr/sbin /sbin
    arch --x86_64 $HOMEBREW_DIR_I/bin/brew $argv
end
function e
    emacsclient -nw -a ""
end
function ekill
emacsclient -e "(kill-emacs)"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
