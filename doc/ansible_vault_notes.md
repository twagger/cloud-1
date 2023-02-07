# Ansible Vault notes

Notes about Ansible Vault for encryption of sensitive data.

Full documentation available on Ansible website: https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html

## Ansible Vault use on single variables

### Encryption of a single variable with a password file:
For example, to encrypt the string ‘foobar’ using the only password stored in ‘a_password_file’ and name the variable ‘the_secret’:

```shell
ansible-vault encrypt_string --vault-password-file a_password_file 'foobar' --name 'the_secret'
```

## Ansible Vault use on a file with multiple variables

### Pros and cons of using a file with mutiple variables
File-level encryption is easy to use. Password rotation for encrypted files is straightforward with the rekey command. Encrypting files can hide not only sensitive values, but the names of the variables you use. However, with file-level encryption the contents of files are no longer easy to access and read. This may be a problem with encrypted tasks files. When encrypting a variables file, see Keep vaulted variables safely visible for one way to keep references to these variables in a non-encrypted file. Ansible always decrypts the entire encrypted file when it is when loaded or referenced, because Ansible cannot know if it needs the content unless it decrypts it.

## Operations on encrypted files:
### Creating encrypted files with id and passwords file

To create a new encrypted data file called ‘foo.yml’ with the ‘test’ vault password from ‘multi_password_file’:

```shell
ansible-vault create --vault-id test@multi_password_file foo.yml
```

The tool launches an editor (whatever editor you have defined with $EDITOR, default editor is vi). Add the content. When you close the editor session, the file is saved as encrypted data. The file header reflects the vault ID used to create it:

```shell
$ANSIBLE_VAULT;1.2;AES256;test
```

### Creating encrypted files with id and using the prompt for password
To create a new encrypted data file with the vault ID ‘my_new_password’ assigned to it and be prompted for the password:

```shell
ansible-vault create --vault-id my_new_password@prompt foo.yml
```

### Encrypting an existing file
To encrypt an existing file, use the ansible-vault encrypt command. This command can operate on multiple files at once. For example:

```shell
ansible-vault encrypt foo.yml bar.yml baz.yml
```

To encrypt existing files with the ‘project’ ID and be prompted for the password:

```shell
ansible-vault encrypt --vault-id project@prompt foo.yml bar.yml baz.yml
```

### Viewing encrypted file
To view the contents of an encrypted file without editing it, you can use the ansible-vault view command:

```shell
ansible-vault view foo.yml bar.yml baz.yml
```

### Editing encrypted files
To edit an encrypted file in place, use the ansible-vault edit command. This command decrypts the file to a temporary file, allows you to edit the content, then saves and re-encrypts the content and removes the temporary file when you close the editor. For example:

```shell
ansible-vault edit foo.yml
```

To edit a file encrypted with the vault2 password file and assigned the vault ID pass2:

```shell
ansible-vault edit --vault-id pass2@vault2 foo.yml
```

### Changing the password and/or vault ID on encrypted files
To change the password on an encrypted file or files, use the rekey command:

```shell
ansible-vault rekey foo.yml bar.yml baz.yml
```

This command can rekey multiple data files at once and will ask for the original password and also the new password. To set a different ID for the rekeyed files, pass the new ID to --new-vault-id. For example, to rekey a list of files encrypted with the ‘preprod1’ vault ID from the ‘ppold’ file to the ‘preprod2’ vault ID and be prompted for the new password:

```shell
ansible-vault rekey --vault-id preprod1@ppold --new-vault-id preprod2@prompt foo.yml bar.yml baz.yml
```

### Decrypting encrypted files
If you have an encrypted file that you no longer want to keep encrypted, you can permanently decrypt it by running the ansible-vault decrypt command. This command will save the file unencrypted to the disk, so be sure you do not want to edit it instead.

```shell
ansible-vault decrypt foo.yml bar.yml baz.yml
```

## Steps to secure your editor
Ansible Vault relies on your configured editor, which can be a source of disclosures. Most editors have ways to prevent loss of data, but these normally rely on extra plain text files that can have a clear text copy of your secrets.

### vim
You can set the following vim options in command mode to avoid cases of disclosure. There may be more settings you need to modify to ensure security, especially when using plugins, so consult the vim documentation.

Disable swapfiles that act like an autosave in case of crash or interruption.

```shell
set noswapfile
```
Disable creation of backup files.

```shell
set nobackup
set nowritebackup
```
Disable the viminfo file from copying data from your current session.

```shell
set viminfo=
```
Disable copying to the system clipboard.

```shell
set clipboard=
```
You can optionally add these settings in .vimrc for all files, or just specific paths or extensions. See the vim manual for details.


## Using encrypted variables and files

Full documentation available on Ansible website: https://docs.ansible.com/ansible/latest/vault_guide/vault_using_encrypted_content.html


### Passing a single password

To prompt for the password:
```shell
ansible-playbook --ask-vault-pass site.yml
```

To retrieve the password from the /path/to/my/vault-password-file file:
```shell
ansible-playbook --vault-password-file /path/to/my/vault-password-file site.yml
```

To get the password from the vault password client script my-vault-password-client.py:

```shell
ansible-playbook --vault-password-file my-vault-password-client.py
```

See other options for Passing vault IDs and multiple vault passwods in the official doc.


### Setting a default password source

If you don’t want to provide the password file on the command line or if you use one vault password file more frequently than any other, you can set the DEFAULT_VAULT_PASSWORD_FILE config option or the ANSIBLE_VAULT_PASSWORD_FILE environment variable to specify a default file to use. For example, if you set ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass.txt, Ansible will automatically search for the password in that file. This is useful if, for example, you use Ansible from a continuous integration system such as Jenkins.

The file that you reference can be either a file containing the password (in plain text), or it can be a script (with executable permissions set) that returns the password.


### When are encrypted files made visible?

In general, content you encrypt with Ansible Vault remains encrypted after execution. However, there is one exception. If you pass an encrypted file as the src argument to the copy, template, unarchive, script or assemble module, the file will not be encrypted on the target host (assuming you supply the correct vault password when you run the play). This behavior is intended and useful. You can encrypt a configuration file or template to avoid sharing the details of your configuration, but when you copy that configuration to servers in your environment, you want it to be decrypted so local users and processes can access it.

 
### Format of files encrypted with Ansible Vault
Ansible Vault creates UTF-8 encoded txt files. The file format includes a newline terminated header. For example:
```shell
$ANSIBLE_VAULT;1.1;AES256
```
or
```shell
$ANSIBLE_VAULT;1.2;AES256;vault-id-label
```

The header contains up to four elements, separated by semi-colons (;).

1. The format ID ($ANSIBLE_VAULT). Currently $ANSIBLE_VAULT is the only valid format ID. The format ID identifies content that is encrypted with Ansible Vault (via vault.is_encrypted_file()).

2. The vault format version (1.X). All supported versions of Ansible will currently default to ‘1.1’ or ‘1.2’ if a labeled vault ID is supplied. The ‘1.0’ format is supported for reading only (and will be converted automatically to the ‘1.1’ format on write). The format version is currently used as an exact string compare only (version numbers are not currently ‘compared’).

3. The cipher algorithm used to encrypt the data (AES256). Currently AES256 is the only supported cipher algorithm. Vault format 1.0 used ‘AES’, but current code always uses ‘AES256’.

4. The vault ID label used to encrypt the data (optional, vault-id-label) For example, if you encrypt a file with --vault-id dev@prompt, the vault-id-label is dev.


 
## Keep vaulted variables safely visible

You should encrypt sensitive or secret variables with Ansible Vault. However, encrypting the variable names as well as the variable values makes it hard to find the source of the values. To circumvent this, you can encrypt the variables individually using ansible-vault encrypt_string, or add the following layer of indirection to keep the names of your variables accessible (by grep, for example) without exposing any secrets:

1. Create a group_vars/ subdirectory named after the group.

2. Inside this subdirectory, create two files named vars and vault.

3. In the vars file, define all of the variables needed, including any sensitive ones.

4. Copy all of the sensitive variables over to the vault file and prefix these variables with vault_.

5. Adjust the variables in the vars file to point to the matching vault_ variables using jinja2 syntax: db_password: {{ vault_db_password }}.

6. Encrypt the vault file to protect its contents.

7. Use the variable name from the vars file in your playbooks.

8. When running a playbook, Ansible finds the variables in the unencrypted file, which pulls the sensitive variable values from the encrypted file. There is no limit to the number of variable and vault files or their names.


### Use in our project

Encryption of env variables in the vault file:
```shell
ansible-vault encrypt --vault-password-file vault_pwd roles/webapp/files/env_vars/vault
```

Then use the variables in the file /env_vars/vault_env in playbooks.

Decryption of the vault file (permanent):
```shell
ansible-vault decrypt --vault-password-file vault_pwd roles/webapp/files/env_vars/vault
```

Use with ansible playook:
```shell
ansible-playbook site.yml --vault-password-file vault_pwd --tags webapp
```



ansible-vault decrypt ---ask-vault-pass 