# Welcome to cloud-François ☁️🕺🏼

What the project is about.

# Installation instructions

1. Install a virtual environment to get the proper **ansible** binary on your machine

```sh
./setup/env_install.sh && source ~/.zshrc
conda activate 42Cloud-$USER
```

2. Create a vault_pwd file with the encryption passwrd in it (you should know it !)

```sh
echo -n "the_secret" > vault_pwd
```

3. Check that the host file containts valid public server addresses
4. Verify that you can connect as root with ssh to every server in **hosts** file
5. Launch ansible playbook

```sh
ansible-playbook site.yml
```

```sh
ansible-playbook site.yml -e "reset=true" # clear the application
```

```sh
ansible-playbook site.yml --tags webapp # select some tasks
```

# Main notions used in the project

## Ansible tasks and modules
- what is a task
- local / remote
- state
- what a module does
- task organization
- task general options (register, become, delegate_to, vars, with_items)

## Ansible roles
- what is a role
- interest of roles
- inner organization

## Ansible vault
- security concerns
- what we did with ansible vault

## Variables
- default et vars

## Files
- organization

## Templates
- What is it used for

## Tags
- What is it used for

## Lookups
- What is is used for

## Virtual environment (Conda)
- What is the interest (specfic version of python, full install of ansible on a workstation on which we are non root, fast setup)

# What we could have used

## Handlers (with notify)
- What we could h

## Conditional tasks (when)

# Authors

👩 **Estelle RECUERO**

* Github: [@estelle-rcr](https://github.com/estelle-rcr)

👨 **Thomas WAGNER**

* Github: [@twagger](https://github.com/twagger)

# Resources

TechWorld with Nana
VRTechnologies For Automation
Learn Linux TV
Ansible best practices
All modules page
All lookup plugins
Ansible vault