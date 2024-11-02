#!/usr/bin/env bash
if [ "$(uname -m)" == "x86_64" ]
then
    ARCH="x86_64"
else
    ARCH="aarch64"
fi

if [ "$(uname)" == 'Darwin' ]; then
    OS=$ARCH-apple-darwin
elif [ "$(uname)" == 'Linux' ]; then
    OS=$ARCH-unknown-linux-gnu
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

echo "system: $OS"

VERSION="latest/download"

while getopts :t:n OPT
do
    case $OPT in
        t) VERSION="download/$OPTARG";;
        n) VERSION="download/nightly";;
        :) echo "オプション-$OPTARG に引数が指定されていません。"; exit 1 ;;
        ?) echo "オプション-$OPTARG は定義されていません"; exit 1 ;;
    esac
done

URL="https://github.com/rust-analyzer/rust-analyzer/releases/$VERSION/rust-analyzer-$OS.gz"
echo "downloading: $URL"
curl -L $URL | gunzip -c - > ~/.local/bin/rust-analyzer_new


if [ -f ~/.local/bin/rust-analyzer ]
then
    echo "delete old rust-analyzer"
    rm ~/.local/bin/rust-analyzer
fi

echo "install new rust-analyzer"
chmod +x ~/.local/bin/rust-analyzer_new
mv ~/.local/bin/rust-analyzer_new ~/.local/bin/rust-analyzer
