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
mkdir $HOME/.config/fish
ln -s $PWD/../.config/fish/config.fish $HOME/.config/fish/
mkdir $HOME/.config/gitui/
ln -s $PWD/../.config/gitui/key_bindings.ron $HOME/.config/gitui/
ln -s $PWD/../.config/powershell/ $HOME/.config/
ln -s $PWD/../.config/nvim/ $HOME/.config/
ln -s $PWD/../.config/wezterm/ $HOME/.config/
ln -s $PWD/../.config/starship/ $HOME/.config/
sh ./init-emacs.sh
