#!/bin/bash

# Define variables
GREEN="$(tput setaf 2)[OK]$(tput sgr0)"
RED="$(tput setaf 1)[ERROR]$(tput sgr0)"
YELLOW="$(tput setaf 3)[NOTE]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
LOG="~/install.log"

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

ISgit=/sbin/git
if [ -f "$ISgit" ]; then
    printf "%s - AUR Helper dependencies found. Moving on!\n" "$GREEN"
else
    printf "%s - AUR Helper dependencies NOT found.\n" "$YELLOW"
    read -n1 -rep "${CAT} Would you like to install git and dependencies? (y/n)" INST
    if [[ $INST =~ ^[Yy]$ ]]; then
        printf "${GREEN} Installing git and dependencies.\n"
        sudo pacman -S --needed git base-devel rustup
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
    printf "%s - paru found. Moving on!\n" "$GREEN"
    aur=paru
else
    printf "%s - paru NOT found, trying yay.\n" "$YELLOW"
    if [ -f "$ISyay" ]; then
        printf "\n%s - yay found. Moving on!\n" "$GREEN"
        aur=yay
    else
        printf "%s - yay NOT found.\n" "$YELLOW"
        read -n4 -rep "${CAT} paru/yay is needed, would you like to install paru or yay? " INST
        if [[ $INST =~ paru ]]; then
            mkdir -p ~/Documents/git
            cd ~/Documents/git
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm 2>&1 | tee -a $LOG
            cd ..
	        rm -rf paru
            aur=paru
            # Perform system update
            printf "${YELLOW} System Update to avoid issue\n"
            $aur -Syu --noconfirm 2>&1 | tee -a $LOG
        else
            if [[ $INST =~ yay ]]; then
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm 2>&1 | tee -a $LOG
                cd ..
                rm -rf yay
                aur=yay
                # Perform system update
                printf "${YELLOW} System Update to avoid issue\n"
                $aur -Syu --noconfirm 2>&1 | tee -a $LOG
            else
                printf "%s - yay/paru is required for auto-installation. Goodbye!\n" "$RED"
                exit
            fi
        fi
    fi
fi

### Install packages ####
read -n1 -rep "${CAT} Would you like to install the packages? (y/n)" inst
if [[ $inst =~ ^[Yy]$ ]]; then
    wm_pkgs="hyprland waybar wofi xdg-desktop-portal-hyprland xorg-xwayland wlr-randr polkit wl-clipboard ttf-firacode-nerd dunst swww swaylock-effects"
    app_pkgs="firefox noto-fonts-cjk kitty neofetch zathura rust-script pavucontrol fzf gimp gparted brave-bin spotify"
    theme_pkgs=""
    if ! $aur -S --noconfirm $wm_pkgs $app_pkgs $theme_pkgs 2>&1 | tee -a $LOG; then
        print_error " Failed to install additional packages - please check the install.log \n"
        exit 1
    fi
    printf "${YELLOW} Removing hyprland xdg-desktop-portal conflicts."
    $aur -Rnsdd xdg-desktop-portal-kde
    print_success " All necessary packages installed successfully."
else
    printf "${YELLOW} No packages installed. Moving on!\n"
    sleep 1
fi

read -n1 -rep "${CAT} Would you like to install AMD packages? (y/n)" amd
if [[ $amd =~ ^[Yy]$ ]]; then
    amd_pkgs="amdgpu_top"
    if ! $aur -S --noconfirm $amd_pkgs 2>&1 | tee -a $LOG; then
        print_error " Failed to install AMD packages - please check the install.log \n"
        exit 1
    fi
    print_success " All AMD packages installed successfully."
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
    ln -s ~/Documents/git/fphchen/dotfiles/configs/swww ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/waybar ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/wofi ~/.config/ 2>&1 | tee -a $LOG
    ln -s ~/Documents/git/fphchen/dotfiles/configs/swaylock ~/.config/ 2>&1 | tee -a $LOG
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
    printf " Installing Bluetooth Packages...\n"
    blue_pkgs="bluez bluez-utils"
    if ! $aur -S --noconfirm $blue_pkgs 2>&1 | tee -a $LOG; then
       	print_error "Failed to install bluetooth packages - please check the install.log"    
    else    
        printf " Activating Bluetooth Services...\n"
        sudo systemctl enable --now bluetooth.service
        sleep 1
    fi
else
    printf "${YELLOW} No bluetooth packages installed. Moving on!\n"
fi

### Enable SDDM Autologin ###
read -n1 -rep "${CAT} Would you like to enable SDDM autologin? (y/n)" SDDM
if [[ $SDDM == "Y" || $SDDM == "y" ]]; then
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
    printf " Installing Sunshine Packages...\n"
    rds_pkgs="sunshine"
    if ! $aur -S --noconfirm $rds_pkgs 2>&1 | tee -a $LOG; then
       	print_error "Failed to install remote desktop streaming packages - please check the install.log"    
    else    
        printf " Activating avahi-daemon Services for Sunshine...\n"
        sudo systemctl enable --now avahi-daemon
        sleep 1
    fi
else
    printf "${YELLOW} No remote desktop streaming packages installed. Goodbye!\n"
fi
