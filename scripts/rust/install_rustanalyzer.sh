#!/usr/bin/env bash
if [ "$(uname)" == 'Darwin' ]; then
    if [ "$(uname -m)" == "x86_64" ]
    then
        ARCH="x86_64"
    else
        ARCH="aarch64"
    fi
    OS=$ARCH-apple-darwin
elif [ "$(uname)" == 'Linux' ]; then
    if [ "$(uname -m)" == "x86_64" ]
    then
        ARCH="x86_64"
    else
        ARCH="aarch64"
    fi
    OS=$ARCH-unknown-linux-gnu
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi
echo "system: $OS"
echo "downloading: https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$OS.gz"
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$OS.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
