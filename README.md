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
	
	1. In case you get the error "UNREACHABLE [...] Host key verification failed", use the following command to remove the concerned host from your known hosts file:
	```sh
	ssh-keygen -f "/mnt/nfs/homes/$USER/.ssh/known_hosts" -R "XX.XXX.XX.XXX"    
	```
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

## Virtual environment (Conda)
- What is the interest (specfic version of python, full install of ansible on a workstation on which we are non root, fast setup)

## Ansible playbook
- the main playbook `site.yml` is located at the root of the project and execute different sets of `plays` named roles (see more in Ansible roles below).
- the host file references all the hosts we worked with (no longer viable) under the name `webservers`. We call them all at once when play the playbook by default.
- We can also call individually the execution of the playbook on one host using the option `--limit $HOSTNAME`
- Servers can also be called using different group names when set up in the hosts file. For instance, we could have set up the groups `scaleway` and `google` instead of `webservers` to call one group or the other separately.

## Tags
- in the main playbook `site.yml`, the different roles are executed all together when playing the playbook. However, we added `tags` in order to call only one play at a time. For instance, to relaunch the webapp role only, we used `--tags webapp`

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

## Variables
- There two directories in each role dedicated to variables, default and vars. The `default` file is used to store default values for having a fallback value. The `vars` file is used to set up variables that will be used in the plays. When set up, `vars` variables overwrite `default` values.

## Files
- The folder files is used to store files that are used in the plays, such as files that we copy to the servers or the encrypted .env file which is not copied to the server but read by Ansible using the encryption key (see more in Ansible vault).

## Templates
- The templates folder is used to store template of scripts that will be used for setup on each machine when they need specific data of the server. As this value will be replaced at the execution, we template the script and store them here.

## Lookups
- The lookup plugins from Ansible are provided to execute functions and access data from the controller machine or outside sources (database, APIs...) in contrary to the other function which are played on the remote server. We used it to read the public key or to read the encrypted variables executing ansible vault decryption.

## Ansible vault
- Ansible vault is a service to handle security concerns around sensitive data such as passwords that may be used within the playbook. 
- As we have a .env file used by docker-compose, we encrypted the file on our controller machine using the `ansible-vault encrypt` command. We created a local file named vault_pwd at the root of the project containing our encryption key and provided this file within the play `webapp`. The .env file remains always encrypted on the controller machine and is only read by Ansible at execution. The value of the variables are then passed to the server machine where an .env file is created to be used by Docker there. 


# Going further

## Having roles dedicated to each docker container
- we could have added roles dedicated to each container in order to administrate them separately from our controller machine using Ansible (logs, stop, restart...). It would enable us to check container's state without connecting to the remote server.

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
