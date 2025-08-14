#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME=$(basename "$0")

echo "[$SCRIPT_NAME] Checking for Ansible installation"

if ! command -v ansible &> /dev/null; then
    echo "[$SCRIPT_NAME] Ansible not found. Installing..."

    if command -v dnf &> /dev/null; then
        sudo dnf install -y ansible
    elif command -v apt &> /dev/null; then
        sudo apt update
        sudo env DEBIAN_FRONTEND=noninteractive apt install -y ansible
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm ansible
    else
        echo "[$SCRIPT_NAME] Error: No supported package manager (dnf, apt, pacman) found for Ansible installation." >&2
        exit 1
    fi

    echo "[$SCRIPT_NAME] Ansible installed."
else
    echo "[$SCRIPT_NAME] Ansible already installed."
fi
