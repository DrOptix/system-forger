#!/usr/bin/env bash

# Exit on any error, use unbound variables, and fail on pipe errors.
set -euo pipefail

# --- Container configuration ---
CONTAINER_IMAGE="ubuntu:24.04"
CONTAINER_MOUNT_PATH="/opt/system-forger"

# Determine script's information.
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Calculate the absolute path to the Ansible project root.
ABSOLUTE_ANSIBLE_PROJECT_ROOT="$(realpath -s "$SCRIPT_DIR/../..")"

function run_container() {
    echo "[$SCRIPT_NAME] Start interactive shell in a disposable Ubuntu 24.04 container."

    local container_commands=(
        "export DEBIAN_FRONTEND=noninteractive;"
        "apt-get update;"
        "apt-get install -y --no-install-recommends sudo;"
        "pushd /opt/system-forger/ >/dev/null;"
        "./scripts/bootstrap.sh;"
        "exec bash -i;"
        "popd >/dev/null"
    )

    podman run -it --rm \
        -v "$ABSOLUTE_ANSIBLE_PROJECT_ROOT:$CONTAINER_MOUNT_PATH:ro,Z" \
        "$CONTAINER_IMAGE" bash -ic "${container_commands[*]}"
}

function main() {
    if ! run_container; then
        echo "[$SCRIPT_NAME] Failed to start container."
    fi
} 

main "$@"
