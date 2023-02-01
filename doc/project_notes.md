# Project notes

Notes about **cloud-1** project

# Setup steps

1. **Install Ansible** : possible to install it in a virtual environment like conda with pip installer. For the moment this is the chosen way. 
2. **Select a cloud provider**: For this project, 42 has a partnership with Scaleway so we have a free access to resources for the time of the project.
3. **Prerequisites on managed servers (nodes)**: Python, SSH daemon running, OS like Ubuntu 20.04
4. **Configure Ansible** to work with remote servers. Remote servers will be hosted on Scaleway cloud and we need to have an access.
    - Create ssh connection using ssh keys (password-less authentication)
    - Provide the nodes IF / FQDN in inventory/hosts file on Ansible controller
    - Test the configuration by running : `ansible all -m ping`

## Detail

### Specific user

Root user is not recommanded to work on remote nodes. We should create a specific user `ansadmin` on the controller and across all servers to use with Ansible.

```sh
useradd ansadmin
passwd ansadmin
```

This user will be provided with sudo privileges. So you can add the user to the sudo configuration via `visudo` command to complete the sudo config with :

```
ansadmin    ALL=(ALL)   NOPASSWD: ALL
```

### SSH config on nodes

Make sure that `PasswordAuthentication` parameter is set to **yes** in /etc/ssh/sshd_config.

If there is any change, don't forget to restart ssh service :
```sh
systemctl restart sshd
```

Make sure that the ssh key is properly installed on the nodes. If not, the below command can be used to copy a public key onto a distant server :

```sh
ssh-copy-id <remote-ip>
```

In order for this command to be effective, you should launch it from the `ansadmin` user that has beem created on the controller machine.

If the configuration is correct, we should be able to connect to a distant server with : 

```sh
ssh user_name@hostname
```

### Update ansible config to reference proper configuration folders

As we are using a conda environment for our ansible installation on the controller machine, we need to have specific files in specific places :

#### $HOME/.ansible/ansible.cfg
```ruby
[defaults]
inventory = $HOME/.ansible/inventory
library = $HOME/.ansible/library
roles_path = $HOME/.ansible/roles
```

Of course, to simplify the setup of the environment, all of this specific configuration should be part of the environment installation script.

We can reuse the conda installation script from 42AI and modify it so it is dedicated to install the proper 'cloud' environment with ansible and the default config.

### Update inventory (hosts) file

We should update the inventory file of the controller machine so it can effectively know the nodes it can join.

create a `hosts` file in the ansible home folder `$HOME/.ansible/`

Example of what a minimal host file could contain (IPs / FQDN of the scaleway server(s)) :

```ruby
8.12.5.53
```

### Test connectivity

We can test that the configuration is ok for now with a simple command :

```sh
ansible all -m ping
```

we should have a response from all servers with `SUCCESS` and a `pong` response showing that the servr is answering and that the global configuration is ok at this point.

# Points to study

- Working with dynamic inventory as the IP adresses are not necessary fixed.
- Role (purpose of the host) structure for the project
- Staging / production environment ?
