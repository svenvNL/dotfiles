#!/bin/bash

function setupDirectories() {
    PROJECTS_DIR="${HOME}/Projects"
    DOTFILES_DIR="${PROJECTS_DIR}/dotfiles"
    
    echo -e "Setting up directories..."
    echo -e "\tProjects:\t${PROJECTS_DIR}"
    
    mkdir -p ${PROJECTS_DIR}
}

function setupXClip() {
    sudo dnf -y install xclip
}

function setupSSHKeys() {
    if [ ! -f "${HOME}/.ssh/id_rsa" ]; then
        read -p "Enter email for Github SSH key": GITHUB_EMAIL
        ssh-keygen -t rsa -b 4096 -C "${GITHUB_EMAIL}"
        
        # Start SSH-Agent
        eval "$(ssh-agent -s)"
        
        # Add key
        ssh-add "${HOME}/.ssh/id_rsa"
    fi
    
    xclip -sel clip < "${HOME}/.ssh/id_rsa.pub"
    
    read -p "Public key is coppied to the clipboard, press enter to continue"
}

function cloneRepo() {
    echo -e "\nCloning dotfiles..."
    git clone git@github.com:svenvNL/dotfiles.git ${DOTFILES_DIR}
}

function runSetup() {
    bash "${DOTFILES_DIR}/setup.sh"
}

setupDirectories

setupXClip

setupSSHKeys

cloneRepo

runSetup
