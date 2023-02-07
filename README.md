# Welcome to cloud-François ☁️ 🕺🏼

usage instructions :


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
