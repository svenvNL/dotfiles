#!/bin/bash

# Catch and log errors
trap uncaughtError ERR
function uncaughtError {
    echo -e "\n❌  Error\n"
    echo -e "${ERR}"
    exit $?
}

function initLogFile() {
    ERROR_LOG="${HOME}/.dotfile-install-err.log"
}

function setupDirectories() {
    PROJECTS_DIR="${HOME}/Projects"
    DOTFILES_DIR="${PROJECTS_DIR}/dotfiles"

    echo -e "📂  Setting up directories..."
    echo -e "\tProjects:\t${PROJECTS_DIR}"

    mkdir -p ${PROJECTS_DIR}
}

function setupXClip() {
    sudo dnf -y install xclip &> ${ERROR_LOG}
}

function setupSSHKeys() {
    echo -e "\n🔑  Setting up SSH Key..."
    if [ ! -f "${HOME}/.ssh/id_rsa" ] ; then
        read -p "email": SSH_EMAIL
        ssh-keygen -t rsa -b 4096 -C "${SSH_EMAIL}"
        eval "$(ssh-agent -s)" &> ${ERROR_LOG}
        ssh-add ~/.ssh/id_rsa
    fi

    xclip -sel clip < ~/.ssh/id_rsa.pub

    echo -e "\t📋  Your SSH key has been copied to your clipboard, please add it to https://github.com/settings/keys"
    read -p "Press enter to continue"
}

function cloneRepo() {
    echo -e "\n🖥  Cloning dotfiles..."
    git clone git@github.com:svenvNL/dotfiles.git ${DOTFILES_DIR} &> ${ERROR_LOG}
    echo -e "\n\t✅  Done"
}

function runSetup() {
    bash "${DOTFILES_DIR}/setup.sh"
}

echo -e "👢  Bootstrapping Dotfiles...\n"

initLogFile

setupDirectories

setupXClip

setupSSHKeys

cloneRepo

runSetup
