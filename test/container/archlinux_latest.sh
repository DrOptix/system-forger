#!/usr/bin/env bash

# Exit on any error, use unbound variables, and fail on pipe errors.
set -euo pipefail

SCRIPT_NAME=$(basename $0)

# --- Container configuration ---
CONTAINER_IMAGE="archlinux:latest"
CONTAINER_NAME="system-forger-archlinux-latest-$(date +%Y%m%d_%H%M%S)"
CONTAINER_MOUNT_PATH="/opt/system-forger"

# --- Hardcoded Paths ---

# Determine script's directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Calculate the absolute path to the Ansible project root.
ABSOLUTE_ANSIBLE_PROJECT_ROOT="$(realpath -s "${SCRIPT_DIR}/../..")"

# --- Cleanup logic ---

# Function triggered on EXIT to cleanup the container
function cleanup() {
    echo "[$SCRIPT_NAME] Shell session ended. Initiating cleanup."
    echo "[$SCRIPT_NAME]   Cleaning up container $CONTAINER_NAME..."

    podman container stop "$CONTAINER_NAME" &>/dev/null || true
    podman container rm "$CONTAINER_NAME" &>/dev/null || true

    echo "[$SCRIPT_NAME]   Cleanup complete."
}

# Ensure cleanup is called on script exit
trap cleanup EXIT

# --- Main script logic ---
#
echo "[$SCRIPT_NAME] Initializing Podman Container ---"
echo "[$SCRIPT_NAME]   Script directory: $SCRIPT_DIR"
echo "[$SCRIPT_NAME]   Resolved Ansible Project Root: $ABSOLUTE_ANSIBLE_PROJECT_ROOT"

# Pull the Archlinux image.
echo "[$SCRIPT_NAME]   Pulling image '$CONTAINER_IMAGE'..."

if ! podman pull "$CONTAINER_IMAGE"; then
    echo "[$SCRIPT_NAME]   Failed to pull image. Check your Podman setup." >&2
    exit 1
fi

# Run the container with the entire Ansible project directory bind-mounted.
# The 'Z' option handles SELinux relabeling if applicable.
# 'ro' for read-only to prevent accidental host modifications.
echo "[$SCRIPT_NAME]   Starting container '$CONTAINER_NAME' from image '$CONTAINER_IMAGE'..."

if ! podman run --name "$CONTAINER_NAME" \
                --detach \
                --volume "${ABSOLUTE_ANSIBLE_PROJECT_ROOT}:${CONTAINER_MOUNT_PATH}:ro,Z" \
                "$CONTAINER_IMAGE" \
                sleep infinity; then
    echo "[$SCRIPT_NAME]   Failed to start container. Check Podman logs." >&2
    exit 1
fi

echo "[$SCRIPT_NAME]   Container '$CONTAINER_NAME' started."


# Install Ansible inside the container.
echo "[$SCRIPT_NAME]   Installing Ansible in container '$CONTAINER_NAME'..."

if ! podman exec "$CONTAINER_NAME" pacman -Sy --noconfirm &>/dev/null; then
    echo "[$SCRIPT_NAME]   Failed to update pacman cache. Is the container running?" >&2
    exit 1
fi


if ! podman exec "$CONTAINER_NAME" pacman -S --noconfirm sudo; then
    echo "[$SCRIPT_NAME]   Failed to install sudo. Check container logs." >&2
    exit 1
fi

if ! podman exec "$CONTAINER_NAME" pacman -S --noconfirm ansible; then
    echo "[$SCRIPT_NAME]   Failed to install Ansible. Check container logs." >&2
    exit 1
fi

echo "[$SCRIPT_NAME] Ansible installed."

echo "[$SCRIPT_NAME] Entering Interactive Shell"
echo "[$SCRIPT_NAME]   Your entire Ansible project is mounted inside the container at: ${CONTAINER_MOUNT_PATH}"
echo "[$SCRIPT_NAME]   "
echo "[$SCRIPT_NAME]   You can 'cd' into ${CONTAINER_MOUNT_PATH} to navigate your project."
echo "[$SCRIPT_NAME]   "
echo "[$SCRIPT_NAME]   Press Ctrl+D or type 'exit' to leave the shell and trigger container cleanup."
echo "[$SCRIPT_NAME]   "

# Enter the shell. This command will block until you exit the shell.
if ! podman exec -it "$CONTAINER_NAME" bash; then
    echo "[$SCRIPT_NAME]   Failed to open interactive shell. Container might have stopped or crashed." >&2
    exit 1
fi
