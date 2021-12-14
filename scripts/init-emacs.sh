#!/bin/sh
EMACS_CONFIG_DIR=$HOME/.emacs.d/

mkdir -p $EMACS_CONFIG_DIR
cd `dirname $0`                 # ファイルのある場所をカレントディレクトリにする
ln -s $PWD/../.emacs.d/init.el $EMACS_CONFIG_DIR
ln -s $PWD/../.emacs.d/early-init.el $EMACS_CONFIG_DIR
ln -s $PWD/../.emacs.d/snippets $EMACS_CONFIG_DIR
ln -s $PWD/../.emacs.d/lisp $EMACS_CONFIG_DIR
ln -s $PWD/../.emacs.d/themes $EMACS_CONFIG_DIR
ln -s $PWD/../.emacs.d/straight $EMACS_CONFIG_DIR
