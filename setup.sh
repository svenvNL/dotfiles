#!/bin/bash

function setupSoftware() {
    echo -e "\nInstalling software..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    
    wget -q https://packages.microsoft.com/config/fedora/27/prod.repo
    sudo mv prod.repo /etc/yum.repos.d/microsoft-prod.repo
    sudo chown root:root /etc/yum.repos.d/microsoft-prod.repo
    
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    
    sudo dnf copr -y enable evana/fira-code-fonts
    sudo dnf copr -y enable dirkdavidis/papirus-icon-theme
    
    sudo dnf install fedora-workstation-repositories
    sudo dnf config-manager --set-enabled google-chrome
    
    sudo dnf -y upgrade
    
    sudo dnf -y install snapd
    sudo ln -fs /var/lib/snapd/snap /snap
    
    sudo dnf -y install code
    sudo dnf -y install dotnet-sdk-2.1
    sudo dnf -y install nodejs
    sudo dnf -y install bijiben
    sudo dnf -y install arc-theme
    sudo dnf -y install gnome-tweaks
    sudo dnf -y install fira-code-fonts
    sudo dnf -y install papirus-icon-theme
    sudo dnf -y install google-chrome-stable
    sudo dnf -y install shotwell
    
    sudo snap install spotify
}

function setupNodePackages() {
    echo -e "\nInstalling global node packages..."
    sudo npm i -g --unsafe-perm bash-language-server
}

function setupSoftLinks() {
    echo -e "\nSetting up soft links"
    
    ln -fs "$PWD/.aliases" ~/.aliases
    ln -fs "$PWD/.bash_profile" ~/.bash_profile
    ln -fs "$PWD/.bash_prompt" ~/.bash_prompt
    ln -fs "$PWD/.bashrc" ~/.bashrc
    ln -fs "$PWD/.exports" ~/.exports
    ln -fs "$PWD/.functions" ~/.functions
    ln -fs "$PWD/.gitconfig" ~/.gitconfig
    ln -fs "$PWD/.inputrc" ~/.inputrc
    ln -fs "$PWD/Code/settings.json" ~/.config/Code/User/settings.json;
}

function setupGit() {
    echo -e "\nSetting up Git..."
    
    read -p "Email": GIT_EMAIL
    read -p "Name": GIT_NAME
    
    GIT_CONFIG='[user]\n'
    GIT_CONFIG+="email = ${GIT_EMAIL}\n"
    GIT_CONFIG+="name = ${GIT_NAME}"
    echo -e ${GIT_CONFIG} > "${HOME}/.gitconfig.local"
}

setupSoftware

setupNodePackages

setupSoftLinks

setupGit
