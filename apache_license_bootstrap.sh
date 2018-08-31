#!/bin.bash

# Copyright 2018 Matt Gaunt

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is a modified version of https://github.com/gauntface/dotfiles/blob/master/bootstrap.sh
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

setupSSHKeys
