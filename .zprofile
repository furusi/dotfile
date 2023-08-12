#macOSのバージョン番号
MACVER=`/usr/bin/sw_vers -productVersion | awk -F. '{ print $1 "." $2 }'`
HOMEBREW_DIR_A="/opt/homebrew"
HOMEBREW_DIR_I="/usr/local"
MACPORTS_DIR_A="/opt/local"

if [ -d $HOME/.composer/vendor/bin ];then
    export PATH=$HOME/.composer/vendor/bin:$PATH
fi

# rust
case ${MACVER} in
    11* )
        # export RUST_SRC_PATH=$HOME/.rustup/toolchains/beta-aarch64-apple-darwin/lib/rustlib/src/rust/src/
        if [ -f $HOME/.cargo/env ];then
            source $HOME/.cargo/env
        fi
        ;;
    * )
        if [ -f $HOME/.cargo/env ];then
            source $HOME/.cargo/env
        fi

        if [ -d $HOME/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src/ ];then
            case ${OSTYPE} in
                darwin*)
                    export RUST_SRC_PATH=$HOME/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src/
                    ;;
            esac
        fi
        ;;
esac

if [ -d ~/.roswell ]
then
    export PATH=~/.roswell/bin:$PATH
fi
if [ -d $HOME/go ]; then
    export GOPATH=$HOME/go
    PATH=$PATH:$GOPATH/bin
fi
#pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# pipenv
export PIPENV_VENV_IN_PROJECT=1

# poetry
# https://github.com/python-poetry/poetry
# curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
if [ -f $HOME/.poetry/env ];then
    source $HOME/.poetry/env
fi

# for wsl
if [ -f  /mnt/c/Windows/System32/wsl.exe ]; then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
    export GDK_SCALE=2
fi

# git-remind
export GIT_REMIND_PATHS=$HOME/git/*

export EDITOR=emacs
alias e='emacsclient -nw -a ""'
alias ekill='emacsclient -e "(kill-emacs)"'

#OS固有の設定
case ${OSTYPE} in
    darwin*)
        fpath=(/usr/local/share/zsh/site-functions $fpath)
        if [ -d /usr/local/opt/ruby/bin ];then
            export PATH="/usr/local/opt/ruby/bin:$PATH"
        fi
        case $MACVER in
            "10.14" | "10.15")
                export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
                export PATH="/usr/local/opt/llvm/bin:$PATH"
                export LDFLAGS="-L/usr/local/opt/llvm/lib"
                export CPPFLAGS="-I/usr/local/opt/llvm/include"
                export JAVA_HOME=`/usr/libexec/java_home -v 11`
                ;;
            11*)
                export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
                export PROMPT="%n@%m(`uname -m`) %1~ %# "
                PATH=/opt/homebrew/lib/ruby/gems/3.0.0/bin:/opt/homebrew/opt/ruby/bin:$PATH
                PATH=$HOMEBREW_DIR_A/bin:$MACPORTS_DIR_A/bin:$HOMEBREW_DIR_A/sbin:$PATH
                #alias emacs="/Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs"
                export JAVA_HOME=`/usr/libexec/java_home -v 11`
                ;;
        esac
	;;
    linux*)
	if grep '^fbterm' /proc/$PPID/cmdline > /dev/null; then
	    export TERM=fbterm
	fi
        function find_cd() {
            cd "$(find . -type d | peco)"
        }
        export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH:$HOME/.local/bin
        fpath=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions $fpath)
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	;;
esac

# gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(/opt/homebrew/bin/gpgconf --list-dirs agent-ssh-socket)"
fi


if [ -d $HOME/.local/bin ]; then
else
    mkdir -p $HOME/.local/bin
fi
PATH=$HOME/.local/bin:$PATH

typeset -U PATH
