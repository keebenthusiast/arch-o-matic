#!/bin/bash

SDA1=/dev/sda1
SDA=/dev/sda
MNT=/mnt
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
if [[ "$userResponse" = "y" || "$userResponse" = "Y" ]]; then
	read -p "Enter new username: " userName
	useradd -m -g users -G audio,video,optical,storage,disk,lp,sys,wheel,rfkill,log,systemd-journal -s $BASH $userName
	passwd $userName
else
	echo "Skipping..."
fi

sleep 1 && read -p "Would you like to update the machine and install necessary programs? y/n: " SyuR
if [[ "$SyuR" = "y" || "$SyuR" = "Y" ]]; then
	pacman -Syyu
	sleep 1 && echo "Installing necessary server programs"
        pacman -S openssh git mc samba wget htop fakeroot jshon expac nfs-utils net-tools webmin apache php php-apache\
        mariadb perl-net-ssleay screenfetch emacs tmux bc #jenkins 
	if [ -f PKGBUILD ]; then
	   echo "Packer PKGBUILD found, installing.. "
		makepkg --asroot
		pacman -U packer-*.pkg.tar.gz
		echo "updating packer"
		packer -Syyu
	fi
else
	echo "skipping..."
fi

sleep 1 && echo "removing temporary files"
	rm /part2.sh
	rm /PKGBUILD 
	rm /packer-*.pkg.tar.gz
sleep 1 && echo "Installation complete!"

exit
