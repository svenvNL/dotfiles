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
    bash "${DOTFILES_DIR}/apache_license_bootstrap.sh"
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
