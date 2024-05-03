#!/bin/bash

function setup_system() {
    sudo apt update -y
    sudo apt upgrade -y

    grep -qxF 'deb http://http.kali.org/kali kali-rolling main non-free contrib' /etc/apt/sources.list || \
    echo 'deb http://http.kali.org/kali kali-rolling main non-free contrib' | sudo tee -a /etc/apt/sources.list > /dev/null
    
    wget -qO- https://archive.kali.org/archive-key.asc | sudo tee /etc/apt/trusted.gpg.d/archive-key.asc
    sudo apt update

    local content=$(cat <<-END
Package: *
Pin: release a=kali-rolling
Pin-Priority: 100
END
    )
    
    local file="/etc/apt/preferences.d/kali.pref"

    if ! grep -qxF "$content" "$file"; then
        echo "$content" | sudo tee -a "$file" > /dev/null
        echo "Content added to $file"
    else
        echo "Content already exists in $file"
    fi
}

function configure_services() {
    sudo apt install xrdp kali-tweaks -y
    apt-get install --yes pipewire-module-xrdp
    /usr/lib/kali_tweaks/helpers/hyperv-enhanced-mode enable
    systemctl start xrdp
    systemctl enable xrdp

    local sudoers_file="/etc/sudoers"

    for user in /home/*; do
        local username=$(basename "$user")

        if ! grep -q "^$username " "$sudoers_file"; then
            echo "$username ALL=(ALL) NOPASSWD: ALL" >> "$sudoers_file"
        fi
    done

}

# Call the functions
setup_system
configure_services
sudo apt install gnome-shell-extension-dash-to-panel -y
sudo apt install gnome-shell-extension-arc-menu -y
sudo poweroff
