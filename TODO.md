# system-forger - Development TODO

This document outlines immediate tasks for the `develop` branch rewrite.
All tasks listed here are high-priority architectural refactorings.

**NOTE:** *This list is dynamic and subject to change.*

## Phase 1: Role Granularization

- [/]  Refactor `setup_base_cli` into granular roles:
    - [x] Create `roles/cli_bash` for Bash setup.
    - [ ] Create `roles/cli_fish` for Fish setup.
    - [ ] Create `roles/cli_tmux` for Tmux setup.
    - [ ] Create `roles/cli_modern_tools` for `eza`, `bat`, `ripgrep`, `fd`
          (and their configuration/aliases).
    - [ ] Create `roles/cli_neovim` for bare-bones Neovim setup (including
          `lazy.nvim` and a robust plugin loading mechanism).
    - [ ] Create `roles/cli_monitoring` for `btop` (and any other simple
          monitoring tools).
- [ ] Create `playbooks/base_cli_workstation.yml` to orchestrate these new
      roles for a full CLI setup.
- [ ] Remove the old monolithic `setup_base_cli` role's `main.yml` and its
      `include_tasks` files once migrations are complete.
- [ ] Eliminate all usage of the global `setup_base_cli_packages` variable.
      Each new role will manage its own package installations.

## Phase 2: Dotnet development setup

- [ ] Create `roles/devel_dotnet` for dotnet development (layer over
      `roles/cli_neovim`)
    - [ ] Add support for C# highlighting
    - [ ] Add support for C# LSP
    - [ ] Add support for C# formatter (check: LSP vs dedicated formatter)
    - [ ] Add DAP support for binaries
    - [ ] Add DAP support for tests

## Phase 3: Rust development setup

- [ ] Create `roles/devel_rust` for Rust development (layer over
      `roles/cli_neovim`)
    - [ ] Add support for Rust highlighting
    - [ ] Add support for Rust LSP
    - [ ] Add support for Rust formatter (check: LSP vs dedicated formatter)
    - [ ] Add DAP support for binaries
    - [ ] Add DAP support for tests
