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

### Changed
- **test:** Introduced simplified scripts for launching disposable interactive
  shell environments

  - Fedora 42 (`test/container/fedora_42.sh`)
  - Ubuntu 24.04 (`test/container/ubuntu_24.04.sh`)
  - Arch Linux (`test/container/archlinux_latest.sh`).

  These scripts provide direct, streamlined access to a clean container shell
  for manual testing without complex setup or background processes.
