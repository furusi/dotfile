#!/bin/sh
cd `dirname $0`                 # ファイルのある場所をカレントディレクトリにする
ln -s $PWD/../.editorconfig $HOME/
ln -s $PWD/../.zshrc $HOME/
ln -s $PWD/../.zprofile $HOME/
ln -s $PWD/../.rgignore $HOME/
ln -s $PWD/../.gnupg/gpg.conf $HOME/.gnupg/
if [ "$(uname -m)" == 'arm64' ]; then
    ln -s $PWD/../.gnupg/gpg-agent.conf.darwin.arm64 $HOME/.gnupg/gpg-agent.conf
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -s $PWD/../.gnupg/gpg-agent.conf.linux.x86_64 $HOME/.gnupg/gpg-agent.conf
fi
touch $HOME/.zshrc.local.zsh
mkdir -p $HOME/.config/
ln -s $PWD/../.config/git/ $HOME/.config/
if [ ! -f $HOME/.config/git/config.local ];then
    echo '[user]
	name = ""
	email = ""
' > $HOME/.config/git/config.local
fi
ln -s $PWD/../.config/bat/ $HOME/.config/
ln -s $PWD/../.config/latexmk/ $HOME/.config/
ln -s $PWD/../.config/tig/ $HOME/.config/
sh ./init-emacs.sh
