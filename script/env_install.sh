#!/bin/bash
#
# This script is an installation script to create a dedicated conda environment
# with Ansible

function which_dl {
    # If operating system name contains Darwnin: MacOS. Else Linux
    if uname -s | grep -iqF Darwin; then
        echo "Miniconda3-latest-MacOSX-x86_64.sh"
    else
        echo "Miniconda3-latest-Linux-x86_64.sh"
    fi
}

function which_shell {
    # if $SHELL contains zsh, zsh. Else Bash
    if echo $SHELL | grep -iqF zsh; then
        echo "zsh"
    else
        echo "bash"
    fi
}

function when_conda_exist {
    # check and install 42Cloud environement
    printf "Checking 42Cloud-$USER environment: "
    if conda info --envs | grep -iqF 42Cloud-$USER; then
        printf "\e[33mDONE\e[0m\n"
    else
        printf "\e[31mKO\e[0m\n"
        printf "\e[33mCreating 42Cloud environnment:\e[0m\n"
        conda update -n base -c defaults conda -y
        conda config --add channels conda-forge
        conda create --name 42Cloud-$USER python=3.10 ansible -y
    fi
}

function set_conda {
    # if conda is not installed on the system
    MINICONDA_PATH="/goinfre/$USER/miniconda3"
    CONDA=$MINICONDA_PATH"/bin/conda"
    PYTHON_PATH=$(which python)
    SCRIPT=$(which_dl)
    MY_SHELL=$(which_shell)
    DL_LINK="https://repo.anaconda.com/miniconda/"$SCRIPT
    DL_LOCATION="/tmp/"
    printf "Checking conda: "
    TEST=$(conda -h 2>/dev/null)
    if [ $? == 0 ] ; then
        printf "\e[32mOK\e[0m\n"
        when_conda_exist
        return
    fi
    printf "\e[31mKO\e[0m\n"
    if [ ! -f $DL_LOCATION$SCRIPT ]; then
        printf "\e[33mDonwloading installer:\e[0m\n"
        cd $DL_LOCATION
        curl -LO $DL_LINK
        cd -
    fi
    printf "\e[33mInstalling conda:\e[0m\n"
    sh $DL_LOCATION$SCRIPT -b -p $MINICONDA_PATH
    printf "\e[33mConda initial setup:\e[0m\n"
    $CONDA init $MY_SHELL
    $CONDA config --set auto_activate_base false
    printf "\e[33mCreating 42Cloud-$USER environnment:\e[0m\n"
    $CONDA update -n base -c defaults conda -y
    $CONDA config --add channels conda-forge
    $CONDA create --name 42Cloud-$USER python=3.10 ansible -y
    printf "\e[33mLaunch the following command or restart your shell:\e[0m\n"
    if [ $MY_SHELL == "zsh" ]; then
        printf "\tsource ~/.zshrc\n"
    else
        printf "\tsource ~/.bash_profile\n"
    fi
}

function setup_ansible {
    # setup the basic Ansible config
    ENV_PATH="/goinfre/$USER/miniconda3/envs/42Cloud-$USER/"
    INVENTORY="ansible/inventory"
    LIBRARY="ansible/library"
    ROLES="ansible/roles"
    # copy the config file from ../conf in the proper location
    printf "Copying ansible.cfg from conf folder : "
    if [ -f "../conf/ansible.cfg" ]; then
        cp "../conf/ansible.cfg" $ENV_PATH
        printf "\e[32mOK\e[0m\n"
    else
        printf "\e[31mKO\e[0m\n"
    fi
    # create the ansible configuration directories
    printf "Creating the ansible configuration directories : "
    mkdir -p $ENV_PATH$INVENTORY $ENV_PATH$LIBRARY $ENV_PATH$ROLES
    printf "\e[32mOK\e[0m\n"
}

# Conda + dedicated env install
set_conda

# Ansible setup
setup_ansible
