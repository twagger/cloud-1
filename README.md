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
- What we could have done in this project with handlers

## Conditional tasks (when)
- What we could have done in this project with conditional tasks

# Authors

👩 **Estelle RECUERO**

* Github: [@estelle-rcr](https://github.com/estelle-rcr)

👨 **Thomas WAGNER**

* Github: [@twagger](https://github.com/twagger)

# Resources

* [TechWorld with Nana](https://youtu.be/1id6ERvfozo)
* [VRTechnologies For Automation](https://youtube.com/playlist?list=PL2qzCKTbjutIyQAe3GglWISLnLTQLGm7e)
* [Learn Linux TV](https://youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70)
* [Ansible best practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)
* [All modules page](https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html)
* [Ansible vault](https://blog.stephane-robert.info/post/ansible-vault/)
