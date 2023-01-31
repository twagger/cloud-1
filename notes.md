# Project notes

Notes about Ansible learning and the project in general.

## Why use Ansible ?

Automate IT tasks/ repetitive task (new version deployment, maintenance on servers, ...)

More efficient and less risky than doing the same task manually on different servers.

### Main benefits

1. Execute the taks remotely from our own machine (instead of connecting in ssh to each server one by one)

2. All the steps of configuration / installation / deployement in a single YAML file (instead of multiple scripts with possibly different formats and languages)

3. Re use the same file to excecute the same task for different environments

4. More reliable (less errors than a human repeting multiple times a set of manual operations)

5. Ansible is agentless : no need to install a specific thing on the machines you want to work on, just ssh is needed on them. You just have to install Ansible on the "control machine"

## How Ansible is working ?

### Modules

Ansible works with **modules** (small programs that do the actual work).
- They get sent from the control machine to the target server
- They do their job on the target server (install something, update, ...)
- They get removed when they are done

Modules are very granular : one module = one small specific task (Create or copy a file, install Nginx server, Start Nginx server, start a docker container, ...)

The list of modules is available in Ansible documentation : [list of all modules](https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html).

As modules are granular and specifics, you need to group them in a certain sequence in order to achieve a certain configuration. This invole **Ansible playbooks**.

### Ansible playbooks

Ansible uses **YAML** for configuration.

In a playbook, modules are **Tasks**. In a task you have :
- Module name
- Module arguments
- Description of the small step performed by the module (-name:)

Example of one configuration in a playbook :
```yaml
tasks:
  - name: create directory for nginx
      file:
      path: /path/to/nginx/dir
      state: directory

  - name: install nginx latest version
      yum:
      name: nginx
      state: latest

  - name: start nginx
      service:
      name: nginx
      state: started
```

You can specify on which server the configuration should be executed :

```yaml
- hosts: databases
  remote_user: root
```

Variables can be passed through the configuration file :

```yaml
- hosts: databases
  remote_user: root
  vars:
    tablename: foo
    tableowner: someuser

  tasks:
    - name: Rename table {{ tablename }} to bar
      postgresql_table:
        table: {{ tablename }}
        rename: bar
```

The block below is defining which **tasks** are to be done on which **hosts** with which **user**. It is commonly called a **play**.

A good practice is to name a play :
```yaml
- name: install and start nginx server
  hosts: webservers
  remote_user: root

  tasks:
    - name: create directory for nginx
      file:
        path: /path/to/nginx/dir
        state: directory

    - name: install nginx latest version
      yum:
        name: nginx
        state: latest
    
    - name: start nginx
      service:
        name: nginx
        state: started
```

In a single playbook, we can have multiple plays, they can depend on each otheror not. A file containing multiple plays is called the **playbook**.

A playbook describes :
- **how** and in **which order**
- at what **time** and **where**
- **what** (the modules) should be executed

The playbooks orchestrates the modules excecution

### Ansible inventory list

Ansible maintain a list of servers with references so you can use it in the configuration files.

Example of Hosts file :
```ini
10.24.0.100

[webservers]
web1.myserver.com
web2.myserver.com

[databases]
10.24.0.7
10.24.0.8
```

## Ansible for Docker

You can use a configuration very similar to dockerfiles with Ansible playbook to create docker container, or vagrant container, or a cloud instance, or bare metal server.

### dependencies

Ansible can manage the dependencies between the host of a container and the container itself (like storage, network, ...)

## Ansible tower

**UI dashboard** allowing you to store automation tasls, manage the teams, configurations of the teams, ...

## Steps

1. Install Ansible : possible to install it in a virtual environment like conda with pip installer
2. Configure Ansible to work with remote servers

