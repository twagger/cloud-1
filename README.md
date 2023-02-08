# Welcome to cloud-François ☁️🕺🏼

The project is about using Ansible to deploy a multicontainer application to a distant cloud server.

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

As we are working on shared school machines, we used [Conda](https://docs.conda.io/en/latest/) in this project to setup a virtual environment containing all the necessary packages (python and ansible + dependencies).

In order for the environment to be easy to setup, this project contain a setup script in `/setup` :

```sh
./setup/env_install.sh && source ~/.zshrc
conda activate 42Cloud-$USER
```


## Ansible tasks and modules

The main concept we used in Ansible is the Task. A task is a single command you want to execute on a remote host.

The tasks are working with **modules** which allow you to execute specific actions on a machine (like copying a file, creating a folder, launching a service, ...)

List of supported modules : [All modules](https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html)

Examples of module with their attributes :

```yml
- name: start nginx
    service:
    name: nginx
    state: started

- name: Add a user for ansible tasks
  user:
    name: "admin"
    comment: "Ansible admin}"
    shell: "/bin/bash"
    create_home: yes
    state: present
```

### State

The modules usually have a **state**. The state is defining the state we want to have the resource by the action of the module. It is recommanded by the Ansible doc to always specify the state if it is possible, even if the default value fits.

Example of states :
 - File : present / absent
 - Apt : present / absent

By using a mudule, we are just specifying in which state we want the resource to be and Ansible will "translate" this to the necessary chain of commands in order to achieve the proper state. If your state s 'present' and the file you want to create is already here, it will consider the state as ok and go to the next task **without having an unnecessary action**.

### Organization

It is recommanded to organize tasks in roles so they are easier to manage and reuse. This is explained in the next part.

However, you have the possibility to split playbooks that are to huge into 'sub-playbooks' that can be imported onto a global one.

Here is an example from the project :

*main.yml*
```yml
---
# Prerequisites
- include_tasks: 
- include_tasks: main/02_env_file_update.yml
- include_tasks: main/03_bind_folders.yml

# down the app (and optionally reset it)
- include_tasks: main/04_down_reset.yml

# buildand launch containers
- include_tasks: main/05_deploy.yml

# configuring crontab to launch task on startup
- include_tasks: main/06_launch_on_reboot.yml
```

*main/01_file_copy.yml*
```yml
---
# create a directory named /app
- name: create directory /app
  become: yes
  become_user: root
  file:
    path: /app
    owner: "{{ ansible_user }}"
    state: directory
  
# copy files from controler
- name: copy webapp files
  synchronize:
    src: "{{ role_path }}/files/webapp_files/"
    dest: "/app"
    delete: yes
  vars:
    ans_user: "{{ ansible_user }}"
  delegate_to: localhost

 ...
```

### Task general options

You have the possibility to use several general 'options' on tasks. Here are the ones we used in the project :

- **register** : to register the output of a task so it can be used as a variable in other tasks

```yml
- name: get the current user
  shell: echo $USER
  register: current_user

- name: add the current user in docker group
  become: yes
  become_user: root
  user:
    name: "{{ current_user.stdout }}"
    groups: docker
    append: yes
    state: present
```

- **become / become_user** : to execute a distant task as a specific user

```yml
- name: create directory /app
  become: yes
  become_user: root
  file:
    path: /app
    owner: "{{ ansible_user }}"
    state: directory
```

- **delegate_to** : to execute the task on a certain host (even on localhost)

```yml
- name: copy webapp files
  synchronize:
    src: "{{ role_path }}/files/webapp_files/"
    dest: "/app"
    delete: yes
  vars:
    ans_user: "{{ ansible_user }}"
  delegate_to: localhost
```

- **with_items** : to loop over the items of a list

```yml
- name: create database and wp bind folder
  become: yes
  become_user: root
  file:
    path: "{{ bind_folder }}/{{ item }}"
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    state: directory
  with_items:
    - db
    - wordpress
```

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
