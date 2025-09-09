# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

### Added

- **playbooks**: Add a unique `workstation.yml` playbook that is meant to
  orchestrate all the tasks. Granularity is achieved by the use of Ansible tags.

- **setup_base_cli:** Role that sets up a base layer of modern CLI tools for
  workstations, containers and VMs.

  - **bash:** Login shell setup for modularity with a `.bashrc` and
    `.bash_profile` that integrate with `.bashrc.d/`. The user or other Ansible
    tasks can place their own config files in `.bashrc.d/` and a new instance
    of `bash` will source them. For interactive shells `bash` is configured to
    launch `fish`.

  - **fish:** Primary interactive shell with custom prompt and greeting. Like
    `bash` this one is set to be modular. The user or other Ansible tasks can
    place their own config files in `.config/fish/conf.d/` and a new instance
    of `fish` will source them.

  - **tmux:** Manually invoked. Used to enhance the experience in interactive
    shells when multiple terminals must share the same terminal window. Add the
    concept of sessions, windows and panes to a CLI only environment. Features
    include `Ctrl-a` prefix, mouse support, Vim-like copy mode, and automated
    plugin management (e.g., seamless pane navigation).

  - **eza:** Modern alternative to `ls`. This is perfect for interactive shells
    like `fish`, adding to a good UX by providing highlighting and `git`
    integration. In case `eza` gets removed it will revert to using `ls`.

  - **bat:** Modern alternative to `cat`. This is perfect for interactive shells
    like `fish`, adding to a good UX by providing highlighting and `git`
    integration. In case `bat` gets removed it will revert to using `cat`.

  - **ripgrep:** Modern alternative to `grep`. This is perfect for interactive
    shells like `fish`, adding to a good UX by providing highlighting and `git`
    integration. In case `ripgrep` gets removed it will revert to using `grep`.

  - **fd:** Modern alternative to `find`. This is perfect for interactive shells
    like `fish`, adding to a good UX by providing highlighting and `git`
    integration. In case `fd` gets removed it will **NOT** revert to using
    `find`. `fd` and `find` are not CLI or partially CLI compatible.

  - **neovim:** Install `neovim` with basic configuration:
    - Highlighting current line
    - Relative line numbers
    - Smart case text search
    - 80 char marker line
    - Use spaces instead of tabs
    - Ergonomic splits management: split horizontally, split vertically, close,
      make splits equal size.
    - Ergonomic tabs management: create new tab, close tab, go to next tab, go
      to previous tab.
    - Move selected lines up or down
    - Fuzzy finder using `telescope` plugin. `lazy.nvim` is used as plugin
      manager.

  - **btop:** Modern system monitor for the CLI. Provided monitoring for disk
    usage, CPU and GPU loads, current processes, network upload and download
    speed overview.

- **bootstrapping:** Automate initial setup and Ansible playbook execution.

  - The `scripts/bootstrap.sh` is provided to install `git` and `ansible` on all
    supported platforms and clone the `system-forger`.

  - The `scripts/install.sh` simplifies running the `workstation.yml` playbook
    with intelligent argument handling for user, authorization and tags.

- **test:** Add scripts to setup container based testing for Fedora 42, Ubuntu
  24.04 and ArchLinux. The scripts are using `podman`, but they don't use
  container files to describe, build and cache the environments. For invocation
  a new ephemeral container is built and launched.

## References

Keep a Changelog: https://keepachangelog.com/en/1.1.0/
Semantic Versioning: https://semver.org/spec/v2.0.0.html
Unreleased: https://github.com/DrOptix/system-forger/commits/master/
