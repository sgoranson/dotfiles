#!/bin/bash

set -euo pipefail

coloroff='\e[0m'
black='\e[0;30m'
blue='\e[0;34m'
cyan='\e[0;36m'
green='\e[0;32m'
purple='\e[0;35m'
red='\e[0;31m'
white='\e[0;37m'
yellow='\e[0;33m'
infoColor=${green}
questionColor=${red}
outputColor=${yellow}


strInstallDrive=/dev/sda
strLanguage='en_US.UTF-8'
strTimezone='America/New_York'
strHostname='archbox1'
strUsername='steve'


#Intro
echo -e ${infoColor}"Welcome to the Spot Communication's Arch Linux installer and configurator"
echo -e ${outputColor}

parted ${strInstallDrive} rm 1
parted ${strInstallDrive} rm 2
parted ${strInstallDrive} rm 3
parted ${strInstallDrive} rm 4
parted ${strInstallDrive} rm 5
parted ${strInstallDrive} rm 6
dd if=/dev/zero of=${strInstallDrive} bs=512 count=10

# parted ${strInstallDrive} mklabel gpt
# parted ${strInstallDrive} mkpart primary fat32 1MiB ${strPartitionSizeBoot}
parted ${strInstallDrive} mklabel msdos
parted ${strInstallDrive} mkpart primary ext4 1MiB ${strPartitionSizeBoot}

parted mkpart primary ext4 1MiB 100MiB
parted set 1 boot on
parted mkpart primary ext4 100MiB 90%
parted mkpart primary linux-swap 90% 100%


echo -e ${infoColor}"END OF PARTITIONING"
echo -e ${outputColor}
sleep 3

#Format the partitions
# mkfs.vfat -F32 ${strInstallDrive}1
mkfs.ext4 {$strInstallDrive}1
mkfs.ext4 ${strInstallDrive}2
mkswap ${strInstallDrive}3
swapon ${strInstallDrive}3
sync

#Mount the partitions
mount ${strInstallDrive}2 /mnt
cd /mnt
rm -rf *
mkdir -p /mnt/boot
mkdir -p /mnt/home
mount ${strInstallDrive}1 /mnt/boot
cd /mnt/boot
rm -rf *
# mount ${strInstallDrive}4 /mnt/home
# cd /mnt/home
# rm -rf *
# cd ~
echo -e ${infoColor}"END OF FORMATTING"
sleep 3

#Update local mirrors
echo -e ${infoColor}"UPDATING LOCAL MIRRORS"
echo -e ${outputColor}
pacman -Sy reflector
reflector --verbose --country 'United States' -l 200 -p http -p https --sort rate --save /etc/pacman.d/mirrorlist
sleep 3

#Install the base system
echo -e ${infoColor}"INSTALLING THE BASE SYSTEM"
echo -e ${outputColor}
pacstrap  /mnt base base-devel sudo wget iw wpa_supplicant reflector grub os-prober
sleep 3


#Generate an fstab
echo -e ${infoColor}"GENERATING FSTAB"
genfstab -U -p /mnt >> /mnt/etc/fstab

#Set locale
echo -e ${infoColor}"START OF SETTING LOCALE"
echo -e ${outputColor}
arch-chroot /mnt /bin/bash -c "sed -i 's/#${strLanguage}/${strLanguage}/' /etc/locale.gen"
arch-chroot /mnt locale-gen
arch-chroot /mnt /bin/bash -c "echo LANG=${strLanguage} > /etc/locale.conf"
echo -e ${infoColor}"END OF SETTING LOCALE"
sleep 3

#Set timezone
echo -e ${infoColor}"START OF SETTING TIMEZONE"
echo -e ${outputColor}
arch-chroot /mnt /bin/bash -c "ln -s /usr/share/zoneinfo/${strTimezone} /etc/localtime"
arch-chroot /mnt hwclock --systohc --utc
echo -e ${infoColor}"END OF SETTING TIMEZONE"
sleep 3

#Set hostname
echo -e ${infoColor}"START OF SETTING HOSTNAME"
arch-chroot /mnt /bin/bash -c "echo ${strHostname} > /etc/hostname"
arch-chroot /mnt /bin/bash -c "sed -i 's/localhost /localhost $strHostname/' /etc/hosts"
echo -e ${infoColor}"END OF SETTING HOSTNAME"
sleep 3

#Install the bootloader
echo -e ${infoColor}"START OF BOOTLOADER INSTALLATION"
echo -e ${outputColor}
# arch-chroot /mnt pacman -S dosfstools
# arch-chroot /mnt bootctl --path=/boot install
# arch-chroot /mnt /bin/bash -c 'echo "title Arch Linux" >> /boot/loader/entries/arch.conf\'
# arch-chroot /mnt /bin/bash -c 'echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf\'
# arch-chroot /mnt /bin/bash -c 'echo "initrc /initramfs-linux.img" >> /boot/loader/entries/arch.conf\'
# arch-chroot /mnt /bin/bash -c $'echo "options root=${strInstallDrive}1 rw resume=${strInstallDrive}3" >> /boot/loader/entries/arch.conf\'
# arch-chroot /mnt /bin/bash -c 'echo "timeout 0" > /boot/loader/loader.conf\' #There is only 1 > because the file is created on install, and were overwriting it
# arch-chroot /mnt /bin/bash -c 'echo "default arch" >> /boot/loader/loader.conf\'
arch-chroot /mnt grub-install --target=i386-pc --recheck ${strInstallDrive}
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo -e ${infoColor}"END OF BOOTLOADER INSTALLATION"
sleep 3

#Set root password
echo -e ${infoColor}"SETTING ROOT PASSWORD"
echo -e ${outputColor}
echo "root:root" | arch-chroot /mnt chpasswd
sleep 3

#Create a user account
echo -e ${infoColor}"START OF USER ACCOUNT CREATION"
echo -e ${outputColor}
arch-chroot /mnt useradd -m -G wheel -s /usr/bin/zsh ${strUsername}
arch-chroot /mnt usermod -aG audio,games,rfkill,users,uucp,video,wheel ${strUsername}
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /mnt/etc/sudoers.d/10-installer
echo "${strUsername}:${strUsername}" | arch-chroot /mnt chpasswd
echo -e ${infoColor}"END OF USER ACCOUNT CREATION"
sleep 3


#Finish up
echo -e ${infoColor}"FINISHING UP. reboot now"
umount -R /mnt
