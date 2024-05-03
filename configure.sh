#!/bin/bash

initial_dir=$(pwd)

# Check if the script is running as root
if [ "$(id -u)" -eq 0 ]; then
  echo "This script should not be run as root. Please run without sudo."
  exit 1
fi

if [ -f "/usr/share/keyrings/metasploit-framework.gpg" ]; then
    sudo rm "/usr/share/keyrings/metasploit-framework.gpg"
    echo -e "\033[0;32mOld Metasploit GPG key removed.\033[0m"
else
    echo -e "\033[0;32mNo need to refresh Metasploit GPG keys right now....\033[0m"
fi

install_tools() {
    echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections

    local packages=(
        libssl-dev
        enum4linux crackmapexec getallurls dirsearch exploitdb getsploit feroxbuster kerberoast payloadsallthethings pdf-parser peirates pipal pspy radare2 responder smtp-user-enum snmpcheck snmpenum subfinder
        gpgv2 autoconf bison build-essential postgresql libaprutil1 libgmp3-dev libpcap-dev openssl libpq-dev libreadline-dev libsqlite3-dev libssl-dev locate libsvn1 libtool libxml2 libxml2-dev libxslt1-dev wget libyaml-dev libncurses-dev postgresql-contrib xsel zlib1g zlib1g-dev curl
        curl dos2unix outguess pdfcrack wireshark smbclient samba smbmap socat ssdeep samdump2 python3-scapy proxychains rdesktop proxychains4 steghide exiv2 foremost nbtscan ophcrack hashid libimage-exiftool-perl sucrack stegcracker fcrackzip net-tools binwalk zenity john 7zip nmap hashcat wfuzz hydra ffuf whatweb wafw00f cupp cewl crunch dirb gobuster htop lolcat sqlmap ruby-dev neofetch openvpn sublist3r
    )

    for package in "${packages[@]}"; do
        if ! dpkg -s "$package" &> /dev/null; then
            echo -e "\033[0;32mInstalling $package...\033[0m"
            sudo apt install "$package" -y || echo "Failed to install $package"
        else
            echo -e "\033[0;32m$package is already installed.\033[0m"
        fi
    done
}


link_john_scripts() {
    # Define the source directory
    local source_dir="/usr/share/john"

    # Check if John The Ripper is already built and installed
    if [ -d "$source_dir" ] && [ -x "$source_dir/john" ]; then
        echo -e "\033[0;32mJohn The Ripper is already installed and built in $source_dir.\033[0m"
    else
        echo "Setting up John The Ripper."
        cd /tmp
        git clone https://gitlab.com/kalilinux/packages/john.git
        cd john/src
        ./configure && make
        sudo mkdir -p "$source_dir"
        sudo cp -r ../run/* "$source_dir"
        sudo chmod +x "$source_dir"/*
    fi

    # List of scripts to link
    local scripts=(
        1password2john.py
        7z2john.pl
        adxcsouf2john.py
        aem2john.py
        aix2john.py
        andotp2john.py
        androidbackup2john.py
        androidfde2john.py
        ansible2john.py
        apex2john.py
        applenotes2john.py
        aruba2john.py
        atmail2john.pl
        axcrypt2john.py
        bestcrypt2john.py
        bitcoin2john.py
        bitshares2john.py
        bitwarden2john.py
        bks2john.py
        blockchain2john.py
        ccache2john.py
        cisco2john.pl
        cracf2john.py
        dashlane2john.py
        deepsound2john.py
        diskcryptor2john.py
        dmg2john.py
        DPAPImk2john.py
        ecryptfs2john.py
        ejabberd2john.py
        electrum2john.py
        encfs2john.py
        enpass2john.py
        enpass5tojohn.py
        ethereum2john.py
        filezilla2john.py
        geli2john.py
        hccapx2john.py
        htdigest2john.py
        ibmiscanner2john.py
        ikescan2john.py
        ios7tojohn.pl
        itunes_backup2john.pl
        iwork2john.py
        kdcdump2john.py
        keychain2john.py
        keyring2john.py
        keystore2john.py
        kirbi2john.py
        known_hosts2john.py
        krb2john.py
        kwallet2john.py
        lastpass2john.py
        ldif2john.pl
        libreoffice2john.py
        lion2john.pl
        lotus2john.py
        luks2john.py
        mac2john.py
        mcafee_epo2john.py
        monero2john.py
        money2john.py
        mosquitto2john.py
        mozilla2john.py
        multibit2john.py
        neo2john.py
        office2john.py
        openbsd_softraid2john.py
        openssl2john.py
        padlock2john.py
        pcap2john.py
        pdf2john.pl
        pem2john.py
        pfx2john.py
        pgpdisk2john.py
        pgpsda2john.py
        pgpwde2john.py
        prosody2john.py
        pse2john.py
        ps_token2john.py
        pwsafe2john.py
        radius2john.py
        restic2john.py
        sap2john.pl
        sense2john.py
        signal2john.py
        sipdump2john.py
        ssh2john.py
        sspr2john.py
        staroffice2john.py
        strip2john.py
        telegram2john.py
        tezos2john.py
        truecrypt2john.py
        vdi2john.pl
        vmx2john.py
        zed2john.py
    )

    # Loop through each script and create a symbolic link if it doesn't exist
    for script in "${scripts[@]}"; do
        local target_link="/usr/bin/${script}"
        if [ ! -L "${target_link}" ] && [ ! -e "${target_link}" ]; then
            echo -e "\033[0;32mLinking ${script}...\033[0m"
            sudo ln -s "${source_dir}/${script}" "${target_link}"
        else
            echo -e "\033[0;32m${script} is already linked.\033[0m"
        fi
    done
}

# Install brave browser
install_brave_browser() {
    if command -v brave-browser >/dev/null 2>&1; then
        echo -e "\033[0;32mBrave Browser is already installed.\033[0m"
        return 0
    fi

    echo "Starting the installation of Brave Browser..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser -y
    sudo apt remove firefox-esr -y
    echo -e "\033[0;32mBrave Browser has been installed and Firefox ESR has been removed.\033[0m"
}

install_rust_scan() {
    local package_name="rustscan"
    local package_version="2.2.2"
    local package_arch="amd64"
    local package="rustscan_2.2.2_amd64.deb"
    local url="https://github.com/RustScan/RustScan/releases/download/${package_version}/${package}"

    if ! dpkg -s "$package_name" &> /dev/null; then
        echo -e "\033[0;32mRustScan is not installed. Installing now...\033[0m"
        wget "$url" -O "/tmp/$package"
        sudo dpkg -i "/tmp/$package"
    else
        echo -e "\033[0;32mRustScan is already installed.\033[0m"
    fi
}

# Setting a new wallpaper
install_wallpaper_settings() {
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    cd "$initial_dir"
    sudo cp resources/background.jpg ~/Pictures/background.jpg
    gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/Pictures/background.jpg"
    gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Pictures/background.jpg"
}

# Setup our hostfolder command
install_hosting_folder() {
    if [ ! -f /bin/hostfolder ]; then
        echo "hostfolder does not exist. Proceeding with installation..."
        sudo wget -O /tmp/hosting_folder https://raw.githubusercontent.com/pentestfunctions/escalation-folder/main/hosting_folder
        sudo chmod +x /tmp/hosting_folder
        sudo mv /tmp/hosting_folder /bin/hostfolder
        echo -e "\033[0;32mhostfolder has been installed successfully.\033[0m"
    else
        echo -e "\033[0;32mhostfolder already exists. No action taken.\033[0m"
    fi
}

# Define the function to install Joplin if it's not already installed
install_joplin() {
    if ! command -v ~/.joplin/Joplin.AppImage &> /dev/null; then
        echo "Joplin is not installed. Installing Joplin..."
        wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
        echo -e "\033[0;32mJoplin installation complete.\033[0m"
    else
        echo -e "\033[0;32mJoplin is already installed.\033[0m"
    fi
}

# Install metasploit
install_metasploit() {
    if ! command -v msfconsole &> /dev/null; then
        echo -e "\033[0;32mmsfconsole is not installed. Installing Metasploit Framework...\033[0m"
        sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
        chmod 755 /tmp/msfinstall
        sudo /tmp/msfinstall
        sudo rm /tmp/msfinstall
        echo "Metasploit Framework installation complete."
    else
        echo -e "\033[0;32mMetasploit Framework is already installed.\033[0m"
    fi
}

# Install seclists
install_seclists() {
    if [ ! -d "/usr/share/seclists" ]; then
        echo -e "\033[0;32mSecLists is not installed. Installing...\033[0m"
        wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O SecList.zip \
        && unzip SecList.zip \
        && rm -f SecList.zip \
        && sudo mv SecLists-master/ /usr/share/seclists
        echo -e "\033[0;32mSecLists installation complete.\033[0m"
    else
        echo -e "\033[0;32mSecLists is already installed.\033[0m"
    fi
}

# Fix venv python shit
fix_python_environment() {
    # Find and remove any EXTERNALLY-MANAGED files in any /usr/lib/python* directories
    echo -e "\033[0;32mSearching for EXTERNALLY-MANAGED files to remove...\033[0m"
    for file in /usr/lib/python*/EXTERNALLY-MANAGED; do
        if [ -f "$file" ]; then
            echo "Removing $file..."
            sudo rm "$file"
        fi
    done

    # Check if the symbolic link /bin/python exists and points to /bin/python3
    if [ ! -L /bin/python ] || [ "$(readlink /bin/python)" != "/bin/python3" ]; then
        echo -e "\033[0;32mCreating or updating the symbolic link for Python...\033[0m"
        sudo ln -sf /bin/python3 /bin/python
        echo -e "\033[0;32mSymbolic link for Python fixed.\033[0m"
    else
        echo -e "\033[0;32mPython symbolic link is already correctly set.\033[0m"
    fi
}

function enable_extensions() {
    # Enable user extensions in GNOME
    cd "$initial_dir"
    gsettings set org.gnome.shell disable-user-extensions false
    gnome-extensions enable "dash-to-panel@jderose9.github.com"
    gnome-extensions enable "arcmenu@arcmenu.com"
    dconf load /org/gnome/shell/extensions/dash-to-panel/ < resources/dash_settings
    dconf load /org/gnome/shell/extensions/arcmenu/ < resources/ArcMenu_Settings
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
    sudo apt install xfce4-terminal -y
    mkdir -p ~/.config/xfce4/terminal
    touch ~/.config/xfce4/terminal/terminalrc
    cp resources/terminalrc ~/.config/xfce4/terminal/terminalrc
}

sudo apt purge --autoremove gnome-games -y > /dev/null 2>&1
sudo apt-get purge gnome-contacts -y > /dev/null 2>&1
sudo apt remove libreoffice-* -y > /dev/null 2>&1
sudo apt autoremove -y > /dev/null 2>&1
sudo apt autoclean -y > /dev/null 2>&1
sudo apt install xfce4-terminal -y > /dev/null 2>&1 && echo -e "\033[0;32mxfce4-terminal installation was successful\033[0m" || echo "Installation failed"
sudo apt remove gnome-terminal -y  > /dev/null 2>&1 && echo -e "\033[0;32mgnome-terminal is already removed\033[0m" || echo "gnome-terminal removal failed"

install_tools
install_rust_scan
install_brave_browser
link_john_scripts
install_joplin
install_seclists
install_metasploit
install_hosting_folder
[ -x "$(command -v wpscan)" ] && echo -e "\033[0;32mwpscan is already installed\033[0m" || (sudo gem install wpscan && echo -e "\033[0;32mInstallation successful\033[0m")
enable_extensions

gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

cd "$initial_dir"
cp resources/.bashrc ~/.bashrc
source ~/.bashrc
sudo cp /bin/xfce4-terminal /bin/gnome-terminal
install_wallpaper_settings
echo "All Tools seem to be installed!"
