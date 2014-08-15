#!/bin/bash

SDA1=/dev/sda1 # change as needed
SDA=/dev/sda # change as needed
MNT=/mnt # change as needed
FSTAB=/etc/fstab
PACMAN_MIRROR=/etc/pacman.d/mirrorlist
HOSTNAME=/etc/hostname
ZONE=/usr/share/zoneinfo/America/Los_Angeles
LOCAL_TIME=/etc/localtime
LOCALE_GEN=/etc/locale.gen
LOCALE_CONF=/etc/locale.conf
MKINITCPIO_CONF=/etc/mkinitcpio.conf
GRUB_CFG=/boot/grub/grub.cfg
BASH=/bin/bash
SUDOERS=/etc/sudoers
CREATOR="CSCoder4ever"

echo "Welcome to $CREATOR's installation script! part 2 of 2"

echo "generating locale"
	locale-gen && locale > $LOCALE_CONF

sleep 1 && echo "Creating Initial RAM disk"
	mkinitcpio -p linux

sleep 1 && echo "set root password"
	passwd

sleep 1 && echo "Configuring grub"
	grub-install --target=i386-pc --recheck --debug --force $SDA && grub-mkconfig -o /boot/grub/grub.cfg 

sleep 1 && read -p "Create user now? y/n: " userResponse
if [ "$userResponse" = "y" ]; then
	read -p "Enter new username: " userName
	useradd -m -g users -G audio,video,optical,storage,disk,lp,sys,wheel,rfkill,log,systemd-journal -s $BASH $userName
	passwd $userName
else
	echo "Skipping..."
fi

sleep 1 && read -p "Would you like to update the machine and install necessary programs? y/n: " SyuR
if [ "$SyuR" = "y" ]; then
	pacman -Syyu
	sleep 1 && echo "Installing necessary programs" # Optimized for a laptop with Intel Graphics.
        pacman -S wpa_supplicant dialog git alsa-utils alsa-plugins xorg-server xorg-xinit xorg-server-utils\
        ttf-dejavu mesa arandr xf86-video-intel xf86-input-synaptics i3 sakura nitrogen dmenu networkmanager\
        xfce4-notifyd network-manager-applet gnome-icon-theme wicd wicd-gtk wireless_tools gnome-keyring\
        thunar thunar-volman gvfs gvfs-afc tilda conky firefox htop pavucontrol xfce4-power-manager audacious\
        vlc terminator leafpad pulseaudio screenfetch scrot gimp lxappearance viewnior thunderbird libreoffice\
        flashplugin volumeicon fakeroot jshon expac wget gparted clipit transmission-gtk file-roller p7zip zip\
        unrar arj unace lib32-glibc emacs mc openssh nfs-utils dzen2 remmina freerdp ntfs-3g gksu\
        lxde-icon-theme moc wavpack xfce4-screenshooter tmux timidity++ libstdc++5 linux-headers dosfstools\
        galculator figlet bc evince 
else
	echo "skipping..."
fi

# if packer's PKGBUILD file is found, it will install it.

if [ -f PKGBUILD ]; then 
    echo "Packer PKGBUILD found, installing.. "
    makepkg --asroot
    pacman -U packer-*.pkg.tar.*
    echo "updating packer"
    packer -Syyu
fi

# Below is to copy the most current i3 file on github to the local install.

sleep 1 && echo "Copying dzen2 conky and i3-related files"
	git clone https://github.com/CSCoder4ever/cscoder-files.git
	cd cscoder-files
	mkdir /home/$userName/.i3
	cp i3-configs/config /home/$userName/.i3/config
	cp i3-configs/.i3status.conf /home/$userName/
	cp conky-configs/DzenConkyBar /home/$userName/.conkyrc
	cp conky-configs/zconky /home/$userName/.programs/Various-Scripts/zconky.sh
	ln -s /home/$userName/.programs/Various-Scripts/zconky.sh /usr/bin/zconky
	cd ..
	rm -r cscoder-files

sleep 1 && echo "removing temporary files"
	rm /part2.sh

	# if either PKGBUILD and/or packer tar exist, remove them at will
	
	if [ -f PKGBUILD ]; then
	    rm /PKGBUILD
	fi
	
	if [ -f packer-*.pkg.tar.* ]; then
	    rm /packer-*.pkg.tar.*
	fi

sleep 1 && echo "Installation complete!"

exit
