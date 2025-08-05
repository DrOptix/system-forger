# system-forger
Host, VMs and Containers configuration using Ansible

## Testing

### Containers

Because **system-forger** is supposed to setup development containers and
environments like Windows Subsystem for Linux aka WSL, it is better to test on
similar environments.

Environments like those are most of the time described either as a CLI only
environments or mainly CLI with some limited GUI capabilities. The focus will be
to make the environments usable when it comes to the CLI part of the equation.

To run the tests use those scripts:

- **Fedora 42**: `./test/container/fedora_42.sh`
