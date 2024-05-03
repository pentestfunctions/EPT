# 🚀 Setup Guide for EPT on Debian 12 (Hyper-V)
- Essential Pentesting Toolkit for Debian 12

This guide will help you configure a Debian 12 virtual machine on a Windows host, including adjustments for screen resolution, installation of necessary software, and system configuration.

## 📋 Prerequisites
- Hyper-V enabled on Windows
- Debian 12 ISO
- Internet connection for the VM

## 🛠 Initial Setup

### 🖥 Create New VM
1. Choose "New VM" (not quick create)
2. Select "Generation 2"
3. Go to Settings:
   - Disable Secure Boot
   - Enable guest services in the Integration Services.

### 🔌 Enable Enhanced Session Mode
Run the following command in an administrator PowerShell on the Windows host (MAKE SURE YOU CHANGE DebianTest to your Hyper-V image name):
```bash
Set-VM -VMName DebianTest -EnhancedSessionTransportType HvSocket
```

### 📦 Install Debian 12
Install Debian 12 as you prefer. Remember to set up both root/sudo and user accounts. During the final step of the installation:
- Configure Gnome

## ⚙️ Configuration Steps

### 🌟 Step 1: Post-Installation Setup
After the first boot:
```bash
# Login with your user account (not root)
su root  # Switch to root on that profile
apt install git -y  # Install git
```

### 📡 Step 2: Clone and Run Setup Script
```bash
git clone https://github.com/pentestfunctions/test-setup.git
cd test-setup
chmod +x setup.sh
./setup.sh
```

### 🔄 Reboot the System
After running `setup.sh`, the system will reboot. Simply click to reconnect.

### 💻 Configure RDP and Final Setup
When you boot the VM, on the login screen you will be prompted for enhanced session mode (RDP) after a few seconds. You can adjust the resolution now if you wish. Also ensure that give it a few seconds before logging into Xorg

Once logged into the Xorg session, run:
```bash
cd ~/test-setup
sudo chmod +x configure.sh
./configure.sh
```

Then simply setup your .bashrc with this one
```
https://github.com/pentestfunctions/test-setup/blob/main/.bashrc
```
