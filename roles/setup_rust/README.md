# setup_rust

Ansible role to automate the setup of Rust toolchain and related tools.

## Features

* Installs `rustup` and `rust`
* Deploys both bash and fish modules that are sourcing the Rust environment

## Requirements

* Ansible 2.9 or newer.
* Dependency on `setup_shell` role.

## Role Variables

All variables are defined in `defaults/main.yml` and are prefixed with
`setup_rust_`.

* `setup_rust_user` (string):
  The user for whom to install rust.
  Defaults to `{{ ansible_user_id }}` (the user connecting via Ansible).

