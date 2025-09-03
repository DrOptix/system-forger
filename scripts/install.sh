#!/usr/bin/env bash

# This script is the primary entry point for applying the 'workstation' Ansible
# playbook.
#
# It can be called directly or from 'bootstrap.sh'. It's designed to be
# safely repeatable to apply or update system configurations.

# --- Script Initialization ---
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SYSTEM_FORGER_REPO_ROOT="$SCRIPT_DIR/../"

# --- Global Quiet Pushd/Popd (for stdout only) ---
# Ensures command output from directory stack changes doesn't clutter logs.
# Errors (stderr) from pushd/popd will still be visible.
pushd () { command pushd "$@" >/dev/null; }
popd () { command popd "$@" >/dev/null; }

# --- Main Function ---
# Arguments:
#   1 (Optional): Target user for Ansible provisioning. Defaults to the current user.
function main() {
    local target_user="$(whoami)"
    local ansible_tags=""

    # Parse command line arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -u|--user)
                if [[ -n "$2" && "$2" != --* ]]; then
                    target_user="$2"
                    shift
                else
                    echo "[$SCRIPT_NAME] Error: '--user' requires an argument." >&2; exit 1
                fi
                ;;
            -t|--tags)
                if [[ -n "$2" && "$2" != --* ]]; then
                    ansible_tags="$2"
                    shift
                else
                    echo "[$SCRIPT_NAME] Error: '--tags' requires an argument." >&2; exit 1
                fi
                ;;
            *)
                echo "[$SCRIPT_NAME] Error: Unknown argument '$1'." >&2
                echo "Usage: $SCRIPT_NAME [--user <username>] [--tags <tag1,tag2>]" >&2
                exit 1
                ;;
        esac
        shift
    done

    echo "[$SCRIPT_NAME] Starting Ansible provisioning."
    echo "[$SCRIPT_NAME] Provisioning for user: '$target_user'"

    # Ensure we are in the root of the 'system-forger' repository for Ansible
    pushd "$SYSTEM_FORGER_REPO_ROOT" || {
        echo "[$SCRIPT_NAME] Error: Failed to enter repository root '$SYSTEM_FORGER_REPO_ROOT'. Exiting." >&2
        exit 1
    }

    local playbook_name="workstation"
    local main_playbook_path="$SYSTEM_FORGER_REPO_ROOT/playbooks/$playbook_name.yml"
    if [[ ! -f "$main_playbook_path" ]]; then
        echo "[$SCRIPT_NAME] Error: Playbook '$main_playbook_path' not found in repository root." >&2
        popd; exit 1
    fi

    local ansible_cmd=(ansible-playbook "$main_playbook_path" \
        --inventory localhost \
        --connection local \
        --extra-vars "target_user=$target_user")

     # Add tags if provided.
     if [[ -n "$ansible_tags" ]]; then
         echo "[$SCRIPT_NAME] Running with Ansible tags: '$ansible_tags'"
         ansible_cmd+=(--tags "$ansible_tags")
     else
         echo "[$SCRIPT_NAME] Running entire playbook (no tags specified)."
     fi

    # Handle become password logic based on whether the script is running as
    # 'root' or if the 'root' / 'sudo' password is provideded and no input from
    # the user is needed
    if [[ "$(id -u)" == "0" ]]; then
        echo "[$SCRIPT_NAME] Script is running as 'root'. No 'become' password needed for Ansible."
    elif [[ -n "${ANSIBLE_BECOME_PASS+x}" ]]; then
        echo "[$SCRIPT_NAME] Running as non-root. Using 'ANSIBLE_BECOME_PASS' from environment (non-interactive)."
        ansible_cmd+=(--become-pass "$ANSIBLE_BECOME_PASS")
    else
        echo "[$SCRIPT_NAME] Running as non-root. 'ANSIBLE_BECOME_PASS' not set. Will prompt for become password (interactive)."
        ansible_cmd+=(--ask-become-pass)
    fi

    echo "[$SCRIPT_NAME] Executing Ansible: ${ansible_cmd[*]}"
    "${ansible_cmd[@]}" || {
        echo "[$SCRIPT_NAME] Error: Ansible playbook execution failed for '$playbook_name.yml'." >&2
        popd; exit 1
    }

    echo "[$SCRIPT_NAME] Ansible playbook '$playbook_name.yml' completed successfully."

    popd # Return to the original directory
}

main "$@"
