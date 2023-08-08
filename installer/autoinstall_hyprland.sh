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
    read -n1 -rep "${CAT} Would you like to install git and dependencies? (y/n)" INST
    if [[ $INST =~ ^[Yy]$ ]]; then
        printf "${GREEN} Installing git and dependencies.\n"
        sudo pacman -S --noconfirm --needed git base-devel rustup
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
        read -n4 -rep "${CAT} paru/yay is needed, would you like to install paru or yay? " INST
        if [[ $INST =~ paru ]]; then
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
            $aur -Syu --noconfirm --needed 2>&1 | tee -a $LOG
        else
            if [[ $INST =~ yay ]]; then
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm --needed 2>&1 | tee -a $LOG
                cd ..
                rm -rf yay
                aur=yay
                # Perform system update
                printf "${YELLOW} Upgrading AUR packages to avoid issue.\n"
                $aur -Syu --noconfirm --needed 2>&1 | tee -a $LOG
            else
                printf "${RED} - yay/paru is required for auto-installation. Goodbye!\n"
                exit
            fi
        fi
    fi
fi

### Install packages ####
read -n1 -rep "${CAT} Would you like to install the packages? (y/n)" inst
if [[ $inst =~ ^[Yy]$ ]]; then
    wm_pkgs="hyprland waybar wofi xdg-desktop-portal-hyprland xorg-xwayland wlr-randr polkit polkit-kde-agent wl-clipboard swww swaylock-effects swayidle swayimg grim"
    app_pkgs="firefox kitty zathura gimp gparted brave-bin spotify signal-desktop"
    util_pkgs="neofetch rust-script pavucontrol fzf dunst usbutils acpid amdgpu_top"
    font_pkgs="noto-fonts-cjk ttf-firacode-nerd"
    theme_pkgs=""
    if ! $aur -S --noconfirm --needed $wm_pkgs $app_pkgs $util_pkgs $font_pkgs $theme_pkgs 2>&1 | tee -a $LOG; then
        print_error " Failed to install additional packages - please check ${LOG}\n"
        exit 1
    fi
    printf "${YELLOW} Removing hyprland xdg-desktop-portal conflicts.\n"
    $aur -Rnsdd --noconfirm xdg-desktop-portal-kde 2>&1 | tee -a $LOG
    print_success " All necessary packages installed successfully.\n"
else
    printf "${YELLOW} No packages installed. Moving on!\n"
    sleep 1
fi

read -n1 -rep "${CAT} Would you like to install AMD packages? (y/n)" amd
if [[ $amd =~ ^[Yy]$ ]]; then
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
read -n1 -rep "${CAT} Would you like to git clone and symbolic link config files? (y/n)" CFG
if [[ $CFG =~ ^[Yy]$ ]]; then
    printf "${YELLOW} Git cloning GitHub files...\n"
    mkdir -p ~/Documents/git/fphchen/
    cd ~/Documents/git/fphchen
    git clone https://github.com/fphchen/dotfiles.git
    git clone https://github.com/fphchen/wallpapers.git
    printf "${YELLOW} Symbolic linking config files...\n"
    ln -s ~/Documents/git/fphchen/dotfiles/configs/dunst ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/hypr ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/kitty ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/neofetch ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/swaylock ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/swww ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/waybar ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/wofi ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/zathura ~/.config/ 2>&1 | tee -a $LOG
    rm ~/.bashrc
    ln -s ~/Documents/git/fphchen/dotfiles/configs/.bashrc ~/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/.vimrc ~/ 2>&1 | tee -a $LOG

    ### Symbolic linking Pipewire upmix for 7.1 Surround Sound ###
    mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d
    ln -s /usr/share/pipewire.conf/avail/20-upmix.conf ~/.config/pipewire/pipewire-pulse.conf.d/ 2>&1 | tee -a $LOG
else
    printf "${YELLOW} No symbolic link created. Moving on!\n"
    sleep 1
fi

# BLUETOOTH
read -n1 -rep "${CAT} OPTIONAL - Would you like to install Bluetooth packages? (y/n)" BLUETOOTH
if [[ $BLUETOOTH =~ ^[Yy]$ ]]; then
    printf "${GREEN} Installing Bluetooth packages...\n"
    blue_pkgs="bluez bluez-utils"
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
    printf "${YELLOW} No ACIP packages installed. Moving on!\n"
fi

### Enable SDDM Autologin ###
read -n1 -rep "${CAT} Would you like to enable SDDM autologin? (y/n)" SDDM
if [[ $SDDM =~ ^[Yy]$ ]]; then
    sudo mkdir -p /etc/sddm.conf.d
    LOC="/etc/sddm.conf.d/autologin.conf"
    echo -e "The following has been added to $LOC."
    echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "Enabling SDDM service...\n"
    sudo systemctl enable sddm
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
    fi
else
    printf "${YELLOW} No Asus  packages installed. Moving on!\n"
fi

# Asus Rog G14 Fingerprint Scanner packages
read -n1 -rep "${CAT} OPTIONAL - Would you like to install Asus ROG G14 fingerprint packages? (y/n)" ASUSFINGERPRINT
if [[ $ASUSFINGERPRINT =~ ^[Yy]$ ]]; then
    printf "${YELLOW} Removing libfprint package conflicts.\n"
    $aur -Rns libfprint fprintd
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
    printf "${YELLOW} No Asus  packages installed. Moving on!\n"
fi

printf "${GREEN} Autoinstaller completed.\n"
