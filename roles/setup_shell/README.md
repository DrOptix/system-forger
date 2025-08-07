# setup_shell

Ansible role to automate the setup of a workstation's shell environment.

## Features

* Installs `bash` and `fish` shells.
* Sets `fish` as the default interactive shell for a specified user.
* Deploys custom `.bashrc` and `config.fish` files.
* Manages environment variables and `PATH` additions through a single flexible
  variable.

## Requirements

* Ansible 2.9 or newer.
* Target host must have `sudo` privileges configured for the Ansible connecting
  user.

## Role Variables

All variables are defined in `defaults/main.yml` and are prefixed with
`setup_shell_`.

* `setup_shell_user` (string):
  The user for whom the shell environment will be configured.
  Defaults to `{{ ansible_user_id }}` (the user connecting via Ansible).

* `setup_shell_env` (dictionary):
  A dictionary of environment variables to set.
  Values can be:
    * A simple string: `VAR_NAME: "single_value"`
    * A list of strings:
      * If `VAR_NAME` is `"PATH"`, list items are prepended to `PATH`

        Example:
        ```yaml
        PATH:
          - "/opt/my_tool/bin"
          - "$HOME/.local/bin"
        ```
      * For any other `VAR_NAME`, list items are concatenated with spaces.
        
        Example:
        ```yaml
        JAVA_OPTS:
          - "-Xmx512m"
          - "-Djava.awt.headless=true"
        ```

## Example Playbook

A bare-bones example for your workstation playbook.

```yaml
---
- name: Configure Workstation Shell
  hosts: workstation
  become: yes

  roles:
    - role: setup_shell
      vars:
        setup_shell_user: "your_username" # Or leave default for connecting user
        setup_shell_env:
          MY_CUSTOM_VAR: "hello world"
          ANOTHER_VAR: "some value"
          PATH:
            - "/usr/local/go/bin"
            - "/opt/terraform/bin"
            - "$HOME/.kube/bin"
          EDITOR: "nvim"
```


