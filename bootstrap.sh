#!/usr/bin/env bash

# Determine script's information.
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

SYSTEM_FORGER_BRANCH="${SYSTEM_FORGER_BRANCH:-master}"

clear

function install_package() {
    local package=$1

    if ! command -v "$package" &> /dev/null; then
        echo "[$SCRIPT_NAME] $package not found. Installing..."

        if command -v dnf &> /dev/null; then
            sudo dnf install -y "$package"
        elif command -v apt &> /dev/null; then
            sudo env DEBIAN_FRONTEND=noninteractive apt update
            sudo env DEBIAN_FRONTEND=noninteractive apt install -y "$package"
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm --needed "$package"
        else
            echo "[$SCRIPT_NAME] Error: No supported package manager (dnf, apt, pacman) found for Git and Ansible installation." >&2
            exit 1
        fi

        echo "[$SCRIPT_NAME] $package installed"
    else
        echo "[$SCRIPT_NAME] $package already installed"
    fi
}

function clean_and_clone() {
    local branch=$1

    echo "[$SCRIPT_NAME] Removing old system-forger installation"

    rm -rf "$HOME/.local/share/system-forger"
    git clone https://github.com/DrOptix/system-forger.git "$HOME/.local/share/system-forger" >/dev/null

    # Checkout custom branch only if different than "master"
    if [[ $branch != "master" ]]; then
        pushd "$HOME/.local/share/system-forger"
        git fetch origin "$branch" && git checkout "$banch"
        popd
    fi
}

function main() {
    install_package git
    install_package ansible
    clean_and_clone "$SYSTEM_FORGER_BRANCH"
}

main "$@"
