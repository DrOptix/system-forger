#!/usr/bin/env bash

# Determine script's information.
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

SYSTEM_FORGER_BRANCH="${SYSTEM_FORGER_BRANCH:-master}"
SYSTEM_FORGER_REPO_PATH="$HOME/.local/share/system-forger"

# --- Package Manager Helper Functions ---

# dnf_install: Installs packages using dnf.
# Arguments: A list of package names.
function dnf_install() {
    local packages=("$@")

    echo "[$SCRIPT_NAME] Installing packages via dnf: ${packages[*]}"
    sudo dnf install -y "${packages[@]}" || {
        echo "[$SCRIPT_NAME] Error: dnf package installation failed." >&2
        return 1
    }

    return 0
}

# apt_install: Installs packages using apt.
# Arguments: A list of package names.
function apt_install() {
    local packages=("$@")

    echo "[$SCRIPT_NAME] Running apt update..."
    sudo env DEBIAN_FRONTEND=noninteractive apt update || {
        echo "[$SCRIPT_NAME] Error: apt update failed." >&2
        return 1
    }

    echo "[$SCRIPT_NAME] Installing packages via apt: ${packages[*]}"
    sudo env DEBIAN_FRONTEND=noninteractive apt install -y "${packages[@]}" || {
        echo "[$SCRIPT_NAME] Error: apt package installation failed." >&2
        return 1
    }

    return 0
}

# pacman_install: Installs packages using pacman.
# Arguments: A list of package names.
function pacman_install() {
    local packages=("$@")

    # -Sy syncs databases
    # --needed prevents reinstallation if already present
    echo "[$SCRIPT_NAME] Installing packages via pacman: ${packages[*]}"
    sudo pacman -Sy --noconfirm --needed "${packages[@]}" || {
        echo "[$SCRIPT_NAME] Error: pacman package installation failed." >&2
        return 1
    }

    return 0
}

# --- Main Package Installation Function ---

# install_packages: Detects the package manager and calls the appropriate helper.
# Arguments: A list of package names.
function install_packages() {
    local packages=("$@")

    [[ ${#packages[@]} -eq 0 ]] && {
        echo "[$SCRIPT_NAME] No packages specified. Skipping."
        return 0
    }

    if command -v dnf &>/dev/null; then
        dnf_install "${packages[@]}"
    elif command -v apt &>/dev/null; then
        apt_install "${packages[@]}"
    elif command -v pacman &>/dev/null; then
        pacman_install "${packages[@]}"
    else
        echo "[$SCRIPT_NAME] Error: No supported package manager (dnf, apt, pacman) found." >&2
        return 1
    fi

    # Capture exit code from the last package manager call
    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        echo "[$SCRIPT_NAME] Successfully processed packages: ${packages[*]}."
        return 0
    else
        echo "[$SCRIPT_NAME] Error: Package installation failed for: ${packages[*]}." >&2
        return $exit_code
    fi
}

# --- Clean and Clone Repository Function ---

# clean_and_clone: Removes an existing system-forger repo and clones a fresh one.
# Arguments: 1 - The git branch to checkout (defaults to master if not provided).
function clean_and_clone() {
    # Default to 'master' if no branch is specified.
    local branch="${1:-master}"

    echo "[$SCRIPT_NAME] Removing existing system-forger installation at '$SYSTEM_FORGER_REPO_PATH'..."

    rm -rf "$SYSTEM_FORGER_REPO_PATH" || {
        echo "[$SCRIPT_NAME] Warning: Failed to fully remove old installation at '$SYSTEM_FORGER_REPO_PATH'." >&2
    }

    echo "[$SCRIPT_NAME] Cloning system-forger repository (branch: $branch) into '$SYSTEM_FORGER_REPO_PATH'..."
    git clone "https://github.com/DrOptix/system-forger.git" "$SYSTEM_FORGER_REPO_PATH" || {
        echo "[$SCRIPT_NAME] Error: Failed to clone repository." >&2
        exit 1
    }

    if [[ "$branch" == "master" ]]; then
        echo "[$SCRIPT_NAME] Repository remains on 'master' branch (no custom branch specified)."
    else
        echo "[$SCRIPT_NAME] Checking out custom branch: $branch"

        pushd "$SYSTEM_FORGER_REPO_PATH" || {
            echo "[$SCRIPT_NAME] Error: Failed to enter repository directory '$SYSTEM_FORGER_REPO_PATH'." >&2
            exit 1
        }

        git fetch origin "$branch" || {
            echo "[$SCRIPT_NAME] Error: Failed to fetch branch '$branch'." >&2
            popd
            exit 1
        }

        git checkout "$branch" || {
            echo "[$SCRIPT_NAME] Error: Failed to checkout branch '$branch'." >&2
            popd
            exit 1
        }

        popd

        echo "[$SCRIPT_NAME] Repository successfully checked out to branch '$branch'."
    fi
}

function main() {
    install_packages git ansible
    clean_and_clone "$SYSTEM_FORGER_BRANCH"
}

main "$@"
