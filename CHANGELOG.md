# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **test:** Introduced simplified scripts for launching disposable interactive
  shell environments

  - Fedora 42 (`test/container/fedora_42.sh`)
  - Ubuntu 24.04 (`test/container/ubuntu_24.04.sh`)
  - Arch Linux (`test/container/archlinux_latest.sh`).

  These scripts provide direct, streamlined access to a clean container shell
  for manual testing without complex setup or background processes.
