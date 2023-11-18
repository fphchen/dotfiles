#!/bin/bash

# Define variables
GREEN="$(tput setaf 2)[OK]$(tput sgr0)"
RED="$(tput setaf 1)[ERROR]$(tput sgr0)"
YELLOW="$(tput setaf 3)[NOTE]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
LOG="/home/$(whoami)/install.log"

# Set the script to exit on error
set -e

printf "$(tput setaf 2)Welcome to the Arch Linux auto package installer!\n$(tput sgr0)"
sleep 1

printf "$YELLOW PLEASE BACKUP YOUR FILES BEFORE PROCEEDING!
This script will overwrite some of your configs and files!\n"
sleep 1

printf "$YELLOW Some commands requires you to enter your password in order to execute
If you are worried about entering your password, you can cancel the script now with CTRL Q or CTRL C and review contents of this script.\n"
sleep 1

# Function to print error messages
print_error() {
    printf " %s%s\n" "$RED" "$1" "$NC" >&2
}

# Function to print success messages
print_success() {
    printf "%s%s%s\n" "$GREEN" "$1" "$NC"
}

printf "${GREEN} Upgrading existing packages prior for autoinstaller.\n"
sudo pacman -Syu

ISgit=/sbin/git
if [ -f "$ISgit" ]; then
    printf "${GREEN} - AUR Helper dependencies found. Moving on!\n"
else
    printf "${GREEN} - AUR Helper dependencies NOT found.\n"
    read -n1 -rep "${CAT} Would you like to install git and dependencies? (y/n)" GIT
    if [[ $GIT =~ ^[Yy]$ ]]; then
        printf "${GREEN} Installing git and dependencies.\n"
        sudo pacman -S --noconfirm --needed git base-devel rustup
        sleep 3
        rustup default stable
    else
        printf "${RED} git and dependencies are needed for AUR Helper installation. Goodbye!\n"
        exit
    fi
fi

# Check if yay is installed
ISparu=/sbin/paru
ISyay=/sbin/yay

if [ -f "$ISparu" ]; then
    printf "${GREEN} - paru found. Moving on!\n"
    aur=paru
else
    printf "${YELLOW} - paru NOT found, trying yay.\n"
    if [ -f "$ISyay" ]; then
        printf "${GREEN} - yay found. Moving on!\n"
        aur=yay
    else
        printf "${YELLOW} - yay NOT found.\n"
        read -n4 -rep "${CAT} paru/yay is needed, would you like to install paru or yay? " AUR
        if [[ $AUR =~ paru ]]; then
            mkdir -p ~/Documents/git
            cd ~/Documents/git
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm --needed 2>&1 | tee -a $LOG
            cd ..
	        rm -rf paru
            aur=paru
            # Perform system update
            printf "${YELLOW} Upgrading AUR packages to avoid issue.\n"
            $aur -Syu --noconfirm 2>&1 | tee -a $LOG
        else
            if [[ $AUR =~ yay ]]; then
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm --needed 2>&1 | tee -a $LOG
                cd ..
                rm -rf yay
                aur=yay
                # Perform system update
                printf "${YELLOW} Upgrading AUR packages to avoid issue.\n"
                $aur -Syu --noconfirm 2>&1 | tee -a $LOG
            else
                printf "${RED} - yay/paru is required for auto-installation. Goodbye!\n"
                exit
            fi
        fi
    fi
fi

### Install packages ####
read -n1 -rep "${CAT} Would you like to install the packages? (y/n)" PKGS
if [[ $PKGS =~ ^[Yy]$ ]]; then
    blackedarch_pkgs="aircrack-ng arp-scan burpsuite dirbuster exploitdb graphviz gnu-netcat hcxdumptool hcxtools hydra less metasploit netdiscover nikto nmap python-requests sublist3r whatweb wireshark-qt"
    app_pkgs="firefox gimp gparted libreoffice openvpn vlc zathura zathura-pdf-mupdf zathura-ps"
    util_pkgs="brightnessctl cifs-utils fzf gvfs-nfs gvfs-smb networkmanager-openvpn neofetch nfs-utils pacman-contrib python-pip rust-script slurp smblient trash-cli unzip usbutils"
    font_pkgs="noto-fonts-cjk"
    theme_pkgs=""
    extra_pkgs="brave-bin joplin joplin-desktop"
    if ! $aur -S --noconfirm --needed $blackedarch_pkgs $app_pkgs $util_pkgs $font_pkgs $theme_pkgs $extra_pkgs 2>&1 | tee -a $LOG; then
        print_error " Failed to install additional packages - please check ${LOG}\n"
        exit 1
    fi
    print_success " All necessary packages installed successfully.\n"
else
    printf "${YELLOW} No packages installed. Moving on!\n"
    sleep 1
fi

read -n1 -rep "${CAT} Would you like to install AMD packages? (y/n)" AMD
if [[ $AMD =~ ^[Yy]$ ]]; then
    amd_pkgs="amdgpu_top"
    if ! $aur -S --noconfirm --needed $amd_pkgs 2>&1 | tee -a $LOG; then
        print_error " Failed to install AMD packages - please check ${LOG}\n"
        exit 1
    fi
    print_success " All AMD packages installed successfully.\n"
else
    printf "${YELLOW} No AMD packages installed. Moving on!\n"
    sleep 1
fi

### Symbolic linking Config Files ###
read -n1 -rep "${CAT} Would you like to git clone and symbolic link config files? (y/n)" GITCFG
if [[ $GITCFG =~ ^[Yy]$ ]]; then
    printf "${YELLOW} Git cloning GitHub files...\n"
    mkdir -p ~/.config ~/Desktop ~/Documents ~/Downloads ~/Pictures ~/Videos ~/Temp
    mkdir -p ~/Documents/git/fphchen/
    cd ~/Documents/git/fphchen
    git clone https://github.com/fphchen/dotfiles.git
    git clone https://github.com/fphchen/wallpapers.git
    printf "${YELLOW} Symbolic linking config files...\n"
    ln -s ~/Documents/git/fphchen/dotfiles/configs/zathura ~/.config/ 2>&1 | tee -a $LOG
    rm ~/.bashrc
    ln -s ~/Documents/git/fphchen/dotfiles/configs/.bashrc ~/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/.vimrc ~/ 2>&1 | tee -a $LOG

    ### Symbolic linking Pipewire upmix for 7.1 Surround Sound ###
    mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d
    ln -s /usr/share/pipewire/pipewire.conf.avail/20-upmix.conf ~/.config/pipewire/pipewire-pulse.conf.d/ 2>&1 | tee -a $LOG
    sudo ln -s /usr/share/pipewire/pipewire.conf.avail/20-upmix.conf /etc/pipewire/pipewire-pulse.conf.d/ 2>&1 | tee -a $LOG
else
    printf "${YELLOW} No symbolic link created. Moving on!\n"
    sleep 1
fi

# BLUETOOTH
read -n1 -rep "${CAT} OPTIONAL - Would you like to install Bluetooth packages? (y/n)" BLUETOOTH
if [[ $BLUETOOTH =~ ^[Yy]$ ]]; then
    printf "${GREEN} Installing Bluetooth packages...\n"
    blue_pkgs="bluez bluez-utils blueman"
    if ! $aur -S --noconfirm --needed $blue_pkgs 2>&1 | tee -a $LOG; then
        print_error "Failed to install bluetooth packages - please check ${LOG}\n"    
    else    
        printf " Activating Bluetooth services...\n"
        sudo systemctl enable --now bluetooth.service
        sleep 1
    fi
else
    printf "${YELLOW} No bluetooth packages installed. Moving on!\n"
fi

# ACPI
read -n1 -rep "${CAT} OPTIONAL - Would you like to install ACPI packages? (y/n)" ACPI
if [[ $ACPI =~ ^[Yy]$ ]]; then
    printf "${GREEN} Installing ACPI packages...\n"
    acpi_pkgs="acpid"
    if ! $aur -S --noconfirm --needed $acpi_pkgs 2>&1 | tee -a $LOG; then
        print_error "Failed to install ACPI packages - please check ${LOG}\n"    
    else    
        printf " Activating ACPI services...\n"
        sudo systemctl enable --now acpid.service
        sleep 1
    fi
else
    printf "${YELLOW} No ACPI packages installed. Moving on!\n"
fi

read -n1 -rep "${CAT} OPTIONAL - Would you like to install SDDM Login Manager? (y/n)" LOGINMAN
if [[ $LOGINMAN =~ ^[Yy]$ ]]; then
    printf "${GREEN} Removing existing LightDM packages...\n"
    $aur -Rns --noconfirm lightdm lightdm-gtk-greeter 2>&1 | tee -a $LOG

    printf "${GREEN} Installing SDDM packages...\n"
    loginman_pkgs="sddm qt5-graphicaleffects qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-multimedia gst-libav gst-plugins-good phonon-qt5-gstreamer"
    if ! $aur -S --noconfirm --needed $loginman_pkgs 2>&1 | tee -a $LOG; then
        print_error "Failed to install SDDM packages - please check ${LOG}\n"    
    else    
        printf " Activating SDDM services...\n"
        sudo systemctl enable sddm
        sleep 1
    fi
else
    printf "${YELLOW} No SDDM packages installed. Moving on!\n"
fi

### Enable SDDM Autologin ###
read -n1 -rep "${CAT} Would you like to enable SDDM autologin? (y/n)" SDDM
if [[ $SDDM =~ ^[Yy]$ ]]; then
    sudo mkdir -p /etc/sddm.conf.d
    LOC="/etc/sddm.conf.d/autologin.conf"
    echo -e "The following has been added to $LOC."
    echo -e "[Autologin]\nUser=$(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "Restarting SDDM service...\n"
    sudo systemctl reload-or-restart sddm
    sleep 1
else
    printf "${YELLOW} SDDM Autologin NOT enabled. Moving on!\n"
fi

# SUNSHINE
read -n1 -rep "${CAT} OPTIONAL - Would you like to install remote desktop streaming packages? (y/n)" SUNSHINE
if [[ $SUNSHINE =~ ^[Yy]$ ]]; then
    printf "${GREEN} Installing Sunshine packages...\n"
    rds_pkgs="sunshine"
    if ! $aur -S --noconfirm --needed $rds_pkgs 2>&1 | tee -a $LOG; then
       	print_error "Failed to install remote desktop streaming packages - please check ${LOG} \n"    
    else    
        printf " Activating avahi-daemon services for Sunshine...\n"
        sudo systemctl enable --now avahi-daemon
        sleep 1
    fi
else
    printf "${YELLOW} No remote desktop streaming packages installed. Goodbye!\n"
fi

# Asus ROG G14 packages
read -n1 -rep "${CAT} OPTIONAL - Would you like to install Asus ROG packages? (y/n)" ASUS
if [[ $ASUS =~ ^[Yy]$ ]]; then
    printf "${GREEN} Installing Asus ROG packages...\n"
    asus_pkgs="asusctl rog-control-center supergfxctl"
    if ! $aur -S --noconfirm --needed $asus_pkgs 2>&1 | tee -a $LOG; then
        print_error "Failed to install Asus ROG packages - please check ${LOG}\n"    
    else    
        printf " Activating Asus services...\n"
        sudo systemctl enable --now asusd.service
        sleep 1
        sudo systemctl enable --now supergfxd.service
        sleep 1
    fi
else
    printf "${YELLOW} No Asus packages installed. Moving on!\n"
fi

# Asus Rog G14 Fingerprint Scanner packages
read -n1 -rep "${CAT} OPTIONAL - Would you like to install Asus ROG G14 fingerprint packages? (y/n)" ASUSFINGERPRINT
if [[ $ASUSFINGERPRINT =~ ^[Yy]$ ]]; then
    printf "${YELLOW} Removing libfprint package conflicts.\n"
    $aur -Rns libfprint fprintd 2>&1 | tee -a $LOG
    printf "${GREEN} Installing Asus ROG G14 fingerprint packages...\n"
    asusfp_pkgs="libfprint-goodix-521d fprintd"
    if ! $aur -S --noconfirm --needed $asusfp_pkgs 2>&1 | tee -a $LOG; then
        print_error "Failed to install Asus ROG G14 fingerprint packages - please check ${LOG}\n"    
    else    
        printf " Activating Asus ROG G14 fingerprint services...\n"
        sudo systemctl enable --now asusd.service
        sleep 1
    fi
else
    printf "${YELLOW} No Asus packages installed. Moving on!\n"
fi

read -n1 -rep "${CAT} OPTIONAL - Would you like to install 8814AU WLAN driver packages from morrownr git? (y/n)" WLAN8814AU
if [[ $WLAN8814AU =~ ^[Yy]$ ]]; then
    printf "${GREEN} Installing 8814AU WLAN driver dependency packages...\n"    
    wlan8814au_pkgs="linux-headers dkms git bc iw"
    if ! $aur -S --noconfirm --needed $wlan8814au_pkgs 2>&1 | tee -a $LOG; then
        print_error "Failed to install 8814AU WLAN driver dependency packages - please check ${LOG}\n"    
    else    
        printf " Cloning git packages...\n"
        mkdir -p ~/Documents/git
        cd ~/Documents/git
        git clone https://github.com/morrownr/8814au.git
        cd 8814au
        printf " Installing 8814AU WLAN driver"
        sudo ./install-driver.sh
        sleep 1
    fi
else
    printf "${YELLOW} No 8814AU WLAN drier packages installed. Moving on!\n"
fi

printf "${GREEN} Autoinstaller completed.\n"
