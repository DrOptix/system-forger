#!/usr/bin/env bash

# Exit on any error, use unbound variables, and fail on pipe errors.
set -euo pipefail

SCRIPT_NAME=$(basename "$0")

# --- Container configuration ---
CONTAINER_IMAGE="fedora:42"
CONTAINER_MOUNT_PATH="/opt/system-forger"

# Determine script's information.
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Calculate the absolute path to the Ansible project root.
ABSOLUTE_ANSIBLE_PROJECT_ROOT="$(realpath -s "$SCRIPT_DIR/../..")"

function generate_selective_volume_mounts() {
    local host_base_path="$1"
    local container_base_path="$2"
    local mounts_array=()

    for item in "$host_base_path"/* "$host_base_path"/.*; do
        local item_basename="$(basename "$item")"

        if [[ "$item_basename" == "." || "$item_basename" == ".." || "$item_basename" == ".git" ]]; then
            continue
        fi

        mounts_array+=("-v" "$item:$container_base_path/$item_basename:ro,Z")
    done

    # Output the array elements
    echo "${mounts_array[@]}"
}

function run_container() {
    echo "[$SCRIPT_NAME] Start interactive shell in a disposable Fedora 42 container."

    local mounts=$(generate_selective_volume_mounts \
        "$ABSOLUTE_ANSIBLE_PROJECT_ROOT" \
        "$CONTAINER_MOUNT_PATH")

    local container_commands=(
        "pushd /opt/system-forger/ >/dev/null;"
        "./scripts/bootstrap.sh;"
        "exec bash -i;"
        "popd >/dev/null"
    )

    podman run -it --rm \
        $mounts \
        "$CONTAINER_IMAGE" bash -ic "${container_commands[*]}"
}

function main() {
    if ! run_container; then
        echo "[$SCRIPT_NAME] Failed to start container."
    fi
}

main "$@"
