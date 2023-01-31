# Project notes

Note about **cloud-1** project

## Setup steps

1. **Install Ansible** : possible to install it in a virtual environment like conda with pip installer. For the moment this is the chosen way. 
2. **Select a cloud provider**: For this project, 42 has a partnership with Scaleway so we have a free access to resources for the time of the project.
3. **Prerequisites on managed servers (nodes)**: Python, SSH daemon running, OS like Ubuntu 20.04
4. **Configure Ansible** to work with remote servers. Remote servers will be hosted on Scaleway cloud and we need to have an access.
    - Create ssh connection using ssh keys (password-less authentication)
    - Provide the nodes IF/ FQDN in inventory/hosts file on Ansible controller
    - Test the configuration by running : `ansible all -m ping`

### Detail

Root user is not recommanded to work on remote nodes. We should create a specific user `ansadmin` on the controller and across all servers to use with Ansible.

```sh
useradd ansadmin
passwd ansadmin
```

