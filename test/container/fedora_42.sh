#!/usr/bin/env bash

# Exit on any error, use unbound variables, and fail on pipe errors.
set -euo pipefail

# --- Container configuration ---
CONTAINER_IMAGE="fedora:42"
CONTAINER_NAME="system-forger-fedora-42-$(date +%Y%m%d_%H%M%S)"
CONTAINER_MOUNT_PATH="/opt/system-forger"

# --- Hardcoded Paths ---

# Determine script's directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Calculate the absolute path to the Ansible project root.
ABSOLUTE_ANSIBLE_PROJECT_ROOT="$(realpath -s "${SCRIPT_DIR}/../..")"

# --- Cleanup logic ---

# Function triggered on EXIT to cleanup the container
function cleanup() {
    echo "--- Shell session ended. Initiating cleanup. ---"
    echo "  Cleaning up container $CONTAINER_NAME..."

    podman container stop "$CONTAINER_NAME" &>/dev/null || true
    podman container rm "$CONTAINER_NAME" &>/dev/null || true

    echo "  Cleanup complete."
}

# Ensure cleanup is called on script exit
trap cleanup EXIT

# --- Main script logic ---
#
echo "--- Initializing Podman Container ---"
echo "  Script directory: $SCRIPT_DIR"
echo "  Resolved Ansible Project Root: $ABSOLUTE_ANSIBLE_PROJECT_ROOT"

# Pull the Fedora image.
echo "  Pulling image '$CONTAINER_IMAGE'..."

if ! podman pull "$CONTAINER_IMAGE"; then
    echo "  Failed to pull image. Check your Podman setup." >&2
    exit 1
fi

# Run the container with the entire Ansible project directory bind-mounted.
# The 'Z' option handles SELinux relabeling if applicable.
# 'ro' for read-only to prevent accidental host modifications.
echo "  Starting container '$CONTAINER_NAME' from image '$CONTAINER_IMAGE'..."

if ! podman run --name "$CONTAINER_NAME" \
                --detach \
                --volume "${ABSOLUTE_ANSIBLE_PROJECT_ROOT}:${CONTAINER_MOUNT_PATH}:ro,Z" \
                "$CONTAINER_IMAGE" \
                sleep infinity; then
    echo "  Failed to start container. Check Podman logs." >&2
    exit 1
fi

echo "  Container '$CONTAINER_NAME' started."


# Install Ansible inside the container.
echo "  Installing Ansible in container '$CONTAINER_NAME'..."

if ! podman exec "$CONTAINER_NAME" dnf update -y --refresh &>/dev/null; then
    echo "  Failed to update DNF cache. Is the container running?" >&2
    exit 1
fi

if ! podman exec "$CONTAINER_NAME" dnf install -y ansible; then
    echo "  Failed to install Ansible. Check container logs." >&2
    exit 1
fi

echo "  Ansible installed."

echo "--- Entering Interactive Shell ---"
echo "  Your entire Ansible project is mounted inside the container at: ${CONTAINER_MOUNT_PATH}"
echo "  "
echo "  You can 'cd' into ${CONTAINER_MOUNT_PATH} to navigate your project."
echo "  "
echo "  Press Ctrl+D or type 'exit' to leave the shell and trigger container cleanup."
echo "  "

# Enter the shell. This command will block until you exit the shell.
if ! podman exec -it "$CONTAINER_NAME" bash; then
    echo "  Failed to open interactive shell. Container might have stopped or crashed." >&2
    exit 1
fi
