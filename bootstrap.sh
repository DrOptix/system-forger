#!/usr/bin/env bash

# Determine script's information.
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

SYSTEM_FORGER_BRANCH="${SYSTEM_FORGER_BRANCH:-master}"

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
    install_packages git ansible
    clean_and_clone "$SYSTEM_FORGER_BRANCH"
}

main "$@"
