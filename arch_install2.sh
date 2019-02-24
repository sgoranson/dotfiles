#!/bin/bash

DISK=/dev/sda
SWAP_SIZE_GB=2

SWAP_SIZE=$(expr ${SWAP_SIZE_GB} \* 1024 \* 1024 \* 1024)

CAPACITY=$(sfdisk -l ${DISK} | grep \/dev | awk '{print $5}')
SECTORS=$(sfdisk -l ${DISK} | grep \/dev | awk '{print $7}')
BYTES_PER_SECTOR=$(expr ${CAPACITY} / ${SECTORS})

START_SECTOR=2048
SWAP_SECTORS=$(expr ${SWAP_SIZE} / ${BYTES_PER_SECTOR})
ROOT_START_SECTOR=$(expr ${START_SECTOR} + ${SWAP_SECTORS})

echo "label: dos" | sfdisk ${DISK}
echo "${START_SECTOR} ${SWAP_SECTORS} S -" | sfdisk ${DISK} --append
echo "${ROOT_START_SECTOR} - L -" | sfdisk ${DISK} --append

mkswap ${DISK}1
swapon ${DISK}1

mkfs -t ext4 -F ${DISK}2
mount -v ${DISK}2 /mnt

# install base packages
pacstrap /mnt base base-devel vim sudo dhcpcd linux-lts linux-lts-headers dkms grub openssh

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# create chroot script
cat > /mnt/install.sh << EOFEOF
#!/bin/bash

# remove non-LTS kernel
pacman --noconfirm -R linux

# set timezone
ln -sf /usr/share/zoneinfo/Canada/Halifax /etc/localtime

# generate /etc/adjtime
hwclock --systohc

# generate locales
sed -i.bak 's/^#\\(en_US\\.UTF-8.*\\)\$/\\1/g' /etc/locale.gen
locale-gen

# configure locales
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# setup hostname
echo "arch-base" > /etc/hostname
cat > /etc/hosts << "EOF"
127.0.0.1    localhost
::1          localhost
127.0.1.1    arch-base.localdomain    arch-base
EOF

# enable dhcp
NIC=\$(ip -o link show | grep BROADCAST | awk '{print \$2}' | sed 's/://g' | head -n 1)
systemctl enable dhcpcd@\${NIC}

# enable sshd
sed -i.bak 's/^.*PermitRootLogin.*\$/PermitRootLogin\ yes/g' /etc/ssh/sshd_config
systemctl enable sshd.service

# create initramfs
mkinitcpio -p linux-lts

# set root password
echo "root:root" | chpasswd

# set GRUB defaults
sed -i.bak 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet nomodeset"/g' /etc/default/grub

# install bootloader
grub-install --target=i386-pc ${DISK}

# configure bootloader
grub-mkconfig -o /boot/grub/grub.cfg

EOFEOF

# set chroot installer execute bit
chmod +x /mnt/install.sh

# enter chroot
arch-chroot /mnt /install.sh

# dismount swap
swapoff ${DISK}1

# dismount root
umount /mnt

reboot
