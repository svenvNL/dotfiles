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

function setupSoftware() {
    echo -e "\n📦  Installing software..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &> ${ERROR_LOG}
    
    wget -q https://packages.microsoft.com/config/fedora/27/prod.repo &> ${ERROR_LOG}
    sudo mv prod.repo /etc/yum.repos.d/microsoft-prod.repo
    sudo chown root:root /etc/yum.repos.d/microsoft-prod.repo &> ${ERROR_LOG}
    
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    
    sudo dnf copr -y enable evana/fira-code-fonts &> ${ERROR_LOG}
    sudo dnf copr -y enable dirkdavidis/papirus-icon-theme &> ${ERROR_LOG}
    
    sudo dnf install fedora-workstation-repositories &> ${ERROR_LOG}
    sudo dnf config-manager --set-enabled google-chrome &> ${ERROR_LOG}
    
    sudo dnf -y upgrade &> ${ERROR_LOG}
    
    sudo dnf -y install snapd &> ${ERROR_LOG}
    sudo ln -fs /var/lib/snapd/snap /snap
    
    sudo dnf -y install code &> ${ERROR_LOG}
    sudo dnf -y install dotnet-sdk-2.1 &> ${ERROR_LOG}
    sudo dnf -y install nodejs &> ${ERROR_LOG}
    sudo dnf -y install bijiben &> ${ERROR_LOG}
    sudo dnf -y install arc-theme &> ${ERROR_LOG}
    sudo dnf -y install gnome-tweaks &> ${ERROR_LOG}
    sudo dnf -y install fira-code-fonts &> ${ERROR_LOG}
    sudo dnf -y install papirus-icon-theme &> ${ERROR_LOG}
    sudo dnf -y install google-chrome-stable &> ${ERROR_LOG}
    
    sudo snap install spotify &> ${ERROR_LOG}
    
    # shotwell
    # jetbrains toolbox
    # jetbrains rider
    # proprietary codecs
    # fat32
    echo -e "\n\t✅  Done"
}

function setupNodePackages() {
    echo -e "\n📦  Installing global node packages..." &> ${ERROR_LOG}
    sudo npm i -g --unsafe-perm bash-language-server
}

function setupSoftLinks() {
    echo -e "\n🔗  Setting up soft links"
    
    ln -fs "$PWD/.aliases" ~/.aliases
    ln -fs "$PWD/.bash_profile" ~/.bash_profile
    ln -fs "$PWD/.bash_prompt" ~/.bash_prompt
    ln -fs "$PWD/.bashrc" ~/.bashrc
    ln -fs "$PWD/.exports" ~/.exports
    ln -fs "$PWD/.functions" ~/.functions
    ln -fs "$PWD/.gitconfig" ~/.gitconfig
    ln -fs "$PWD/.inputrc" ~/.inputrc
    ln -fs "$PWD/Code/settings.json" ~/.config/Code/User/settings.json;
    
    echo -e "\n\t✅  Done"
}

function setupGit() {
    echo -e "\n🖥️  Setting up Git..."
    
    read -p "Email": GIT_EMAIL
    read -p "Name": GIT_NAME
    
    GIT_CONFIG='[user]\n'
    GIT_CONFIG+="email = ${GIT_EMAIL}\n"
    GIT_CONFIG+="name = ${GIT_NAME}"
    echo -e ${GIT_CONFIG} > "${HOME}/.gitconfig.local"
    
    echo -e "\n\t✅  Done"
}

initLogFile

setupSoftware

setupNodePackages

setupSoftLinks

setupGit

echo -e "\n🎉  Finished, reboot to complete.\n"
