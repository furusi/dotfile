

#alias

#export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# auto change directory
#
setopt auto_cd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

#disable lately command execution(統計のrとかぶる)
disable r

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks

# 8 ビット目を通すようになり、日本語のファイル名を表示可能
setopt print_eight_bit

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# cd をしたときにlsを実行する
function chpwd() { ls -a }

# cdのタイミングで自動的にpushd
setopt auto_pushd

TERM=xterm-256color

# OPAM configuration
echo $PATH|grep "opam"
if [ $? -eq 1 ] ; then
. $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

#right prompt
#PROMPT=$BLUE'[%n@%m] %(!.#.$) '$WHITE
#RPROMPT=$GREEN'[%~]'$WHITE
#setopt transient_rprompt

#PATH="$HOME/perl5/bin${PATH+:}${PATH}"; export PATH;
#PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

alias git-graph="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias tmattach="tmux a -t"
alias findgrep="find ./ -type f -print0|xargs -0 grep"




if [ -f $HOME/.iterm2_shell_integration.zsh ];then
    source $HOME/.iterm2_shell_integration.zsh
fi


if [ -f $HOME/.zshrc.local.zsh ];then
    source $HOME/.zshrc.local.zsh
fi
if [ -d $HOME/.nix-profile ];then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
    # source $HOME/.nix-profile/share/zsh/plugins/nix/nix.plugin.zsh
    fpath=($HOME/nix-zsh-completions $fpath)
    fpath=($HOME/.nix-profile/share/zsh/site-functions $fpath)
    alias nixinstall='nix-env -i'
    alias nixsearch='nix-env -qa'
    alias nixlist='nix-env --query --installed'
    alias nixoutdated='nix-env --upgrade --dry-run'
    alias nixupgrade='nix-env --upgrade'
    alias nixupdate='nix-channel --update'
fi

if [ -d $HOME/.zfunc ];then
    fpath=($HOME/.zfunc $fpath)
fi

if [ -f $HOME/.poetry/env ];then
    poetry config virtualenvs.in-project true
fi

if [ -d /home/linuxbrew ];then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi


# PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# [ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"


if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

#OS固有の設定
case ${OSTYPE} in
    darwin*)
	#BSDlsコマンドのカラーリング
	alias ls='ls -G -w'
        # export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
        # source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # export PATH=/usr/local/texlive/2020/bin/x86_64-darwin:$PATH

        fpath=(/usr/local/share/zsh/site-functions $fpath)
        if [ -d /usr/local/opt/ruby/bin ];then
            export PATH="/usr/local/opt/ruby/bin:$PATH"
        fi
        case $MACVER in
            "10.14" | "10.15")
	        alias brew="PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin brew"
                ;;
            11*)
                alias intelbrew="PATH=$HOMEBREW_DIR_I/bin:/usr/bin:/bin:$HOMEBREW_DIR_I/sbin:/usr/sbin:/sbin arch --x86_64 $HOMEBREW_DIR_I/bin/brew"
                alias armbrew="PATH=$HOMEBREW_DIR_A/bin:/usr/bin:/bin:$HOMEBREW_DIR_A/sbin:/usr/sbin:/sbin $HOMEBREW_DIR_A/bin/brew"
                ;;
        esac
	;;
    linux*)
	alias ls='ls --color'
        alias ll='exa -l'
	alias fbterm='env LANG=ja_JP.UTF8 fbterm'
        alias pacman-rm='pacman -R'
        alias pacman-rm-and-deps='pacman -Rs'
        alias pacman-rm-only='pacman -Rdd'
        alias pacman-search-installed-package='pacman -Qs'
        alias pacman-info-remote='pacman -Si'
        alias pacman-info-installed='pacman -Qi'
        alias pacman-search-file-owned='pacman -Qo'
        alias pacman-downloadonly='pacman -Sw'
        alias pacman-refresh-file-database='pacman -Fy'
        alias pacman-list-installed='pacman -Qe'
        fpath=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions $fpath)
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	;;
esac

# gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

#laravel
PATH=~/.config/composer/vendor/bin:$PATH

typeset -U fpath
autoload -U compinit
compinit -u
typeset -U PATH

