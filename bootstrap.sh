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
    bash "${DOTFILES_DIR}/apache_license_bootstrap.sh"
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
