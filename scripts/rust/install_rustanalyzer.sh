#!/usr/bin/env bash
if [ "$(uname)" == 'Darwin' ]; then
    OS='aarch64-apple-darwin'
    echo $OS
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS='x86_64-unknown-linux-gnu'
    echo $OS
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$OS.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
