#!/usr/bin/env bash

set -euo pipefail

# Constants
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="rust-analyzer"
TEMP_BINARY_NAME="${BINARY_NAME}_new"
GITHUB_BASE_URL="https://github.com/rust-analyzer/rust-analyzer/releases"

# Functions
detect_architecture() {
    case "$(uname -m)" in
        "x86_64")  echo "x86_64" ;;
        *)         echo "aarch64" ;;
    esac
}

detect_os() {
    local arch="$1"
    case "$(uname)" in
        "Darwin")
            echo "${arch}-apple-darwin"
            ;;
        "Linux")
            echo "${arch}-unknown-linux-gnu"
            ;;
        *)
            echo "Your platform ($(uname -a)) is not supported." >&2
            exit 1
            ;;
    esac
}

parse_version() {
    local version="latest/download"
    while getopts ":t:n" opt; do
        case $opt in
            t)
                version="download/$OPTARG"
                ;;
            n)
                version="download/nightly"
                ;;
            :)
                echo "-$OPTARG: is not specified." >&2
                exit 1
                ;;
            \?)
                echo "-$OPTARG undefined option." >&2
                exit 1
                ;;
        esac
    done
    echo "$version"
}

download_and_install() {
    local url="$1"
    local install_path="$2"
    local temp_path="$3"

    echo "downloading: $url"
    if ! curl -L "$url" | gunzip -c - > "$temp_path"; then
        echo "faild downloading file or expand file" >&2
        exit 1
    fi

    if [ -f "$install_path" ]; then
        echo "delete old ${BINARY_NAME}"
        rm "$install_path"
    fi

    echo "install new ${BINARY_NAME}"
    chmod +x "$temp_path"
    mv "$temp_path" "$install_path"
}

main() {
    # Detect system information
    local arch
    arch=$(detect_architecture)
    
    local os
    os=$(detect_os "$arch")
    echo "system: $os"

    # Parse version from command line arguments
    local version
    version=$(parse_version "$@")

    # Construct download URL
    local url="${GITHUB_BASE_URL}/${version}/${BINARY_NAME}-${os}.gz"

    # Prepare paths
    local install_path="${INSTALL_DIR}/${BINARY_NAME}"
    local temp_path="${INSTALL_DIR}/${TEMP_BINARY_NAME}"

    # Ensure install directory exists
    mkdir -p "$INSTALL_DIR"

    # Download and install
    download_and_install "$url" "$install_path" "$temp_path"
}

main "$@"
