# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **bootstrap:** New `bootstrap.sh` script to automate the initial setup of a
  Linux workstation. This includes idempotent installation of `git` and
  `ansible` (cross-distribution), and cloning the `system-forger` repository
  into `$HOME/.local/share/system-forger`.

- **bootstrap:** Control the checked out branch with the `SYSTEM_FORGER_BRANCH`
  environment variable. If it is not defined or it is empty then the `master`
  branch will be checked out.

- **playbooks:** Created initial `workstation.yml` and `wsl.yml` playbooks.
  These are the main setup entry points for different Linux environments,
  including pre-tasks to handle user details.

- **setup_base_cli:** Implemented basic `bash` shell setup, sets up a modular
  `~/.bashrc`, and creates the `~/.bashrc.d/` directory. In addition for
  platforms that are first looking for `~/.bash_profile` a simple implementation
  was added that just sources `~/.bashrc`.

  Playbooks now use this new role.

- **setup_base_cli:** Installing and configure `fish` shell. Create necessary
  config directories (`~/.config/fish/conf.d/` and `~/.config/fish/functions/`),
  deploying a custom `fish_prompt` function, and ensuring the `hostname` utility
  is installed cross-distribution.

  The `hostname` utility is used by the custom `fish_prompt`.

- **setup_base_cli:** Added custom `fish` shell greeting. This new greeting
  function displays the current kernel version, system uptime, and hostname on
  shell startup.

  Ensures `procps-ng` is installed on Fedora for `uptime` utility.

- **setup_base_cli:** Install `eza`, a replacement for `ls`. For Arch Linux and
  Ubuntu, `eza` is installed via the system package manager. For Fedora, the
  latest stable release tarball is downloaded directly from GitHub and deployed
  to the system, ensuring access to the latest version.

- **setup_base_cli:** Add idempotency to `eza` installation on Fedora. We
  install `eza` if it is missing from the system. We check the existance of
  `/usr/bin/eza` binary.

- **setup_base_cli:** Install `bat`, a modern `cat` replacement. This adds `bat`
  to the system and deploys `fish` functions (`cat.fish`, `bat.fish`) that
  override the default `cat` command for an enhanced viewing experience (syntax
  highlighting, line numbers, `git` integration).

  The functions automatically handle `batcat` on Ubuntu, and fall back to
  original `cat` if needed.

- **setup_base_cli:** Implemented `eza` aliases as `fish` functions: `ls`, `la`,
  `ll`, `lla`. This leverages `eza` as a modern replacement for `ls` and its
  common aliases.

  These functions provide enhanced directory listings, robustly fall back to
  `command ls` if `eza` is not found, and include comprehensive documentation.

- **setup_base_cli:** Implemented `fd` as a modern `find` replacement. This adds
  `fd` to the system (handling `fdfind` on Ubuntu), deploys a custom ignore file
  (`~/.config/fd/ignore`) that disables finding inside `.git` directories.

- **setup_base_cli:** Implemented `ripgrep` (`rg`) as a modern `grep`
  replacement. This installs `ripgrep` and deploys a `fish` function that
  overrides the default `grep` command for enhanced content searching, with a
  fallback to `command grep` if `rg` is not present.

- **setup_base_cli:** Install `btop` utility for enhanced process monitoring.

- **scripts:** Introduced the `./scripts` directory to hold all the scripts.
  This included moving `bootstrap.sh` into `./scripts/` and adding `install.sh`.

  The new `install.sh` script simplifies calling `ansible-playbook` defaulting
  to the `wsl` playbook and the user who runs the script.

  Now `bootstrap.sh` automatically runs `install.sh`.

- **setup_base_cli:** Integrated `tmux` with an XDG-compliant configuration
  for terminal multiplexing, including essential keybindings, Vim-mode.
  Navigation between panes is done using `Ctrl-{h, j, k , l}`. The `tmux`
  plugins are automatically installed.

- **setup_base_cli:** Configured 'fish' to automatically launch as the
  interactive shell from 'bash' via a new '~/.bashrc.d/99-launch-fish.sh'
  script. This provides the 'fish' experience for interactive sessions
  while keeping 'bash' as the login shell.

- **setup_base_cli:** Refactored the internal file organization for 'fish'
  configuration within the Ansible role, ensuring source paths align with
  their XDG-compliant deployment destinations. features, and Wayland clipboard
  support.

### Changed
- **test:** Introduced simplified scripts for launching disposable interactive
  shell environments

  - Fedora 42 (`test/container/fedora_42.sh`)
  - Ubuntu 24.04 (`test/container/ubuntu_24.04.sh`)
  - Arch Linux (`test/container/archlinux_latest.sh`).

  These scripts provide direct, streamlined access to a clean container shell
  for manual testing without complex setup or background processes.

- **setup_base_cli:** Grouped role files per task. The `files/` directory is now
  structured to organize static configuration files into subdirectories
  corresponding to the task files that deploy them, improving maintainability.

- **playbooks:** Consolidated playbook architecture from separate 'workstation'
  and 'wsl' playbooks into a single 'workstation.yml' for improved testing
  efficiency and maintainability.

### Fixed
- **test:** `btop` execution failure in ArchLinux test containers by adding the
  `--privileged` flag to `podman run`. This addresses the lack of `CAP_SETFCAP`
  during `btop`'s package installation on ArchLinux.

- **setup_base_cli:** Corrected an issue where 'fish' would not launch within
  new 'tmux' panes by explicitly unsetting the 'FISH_IS_RUNNING' environment
  variable in 'tmux.conf'.

- **setup_base_cli:** Fixed RGB colors rendering in `tmux` panes running inside
  containers.

- **setup_base_cli:** Correctly deploy `bat` fish functions to the correct path
  of `$HOME/.config/fish/functions/`.

- **setup_base_cli:** Corrected an inversion bug in `bat`/`cat` `fish` function
  definitions. The content of `cat.fish` and `bat.fish` were swapped to ensure
  each file defines its intended function, fixing the `bat` integration as a
  modern `cat` replacement.
