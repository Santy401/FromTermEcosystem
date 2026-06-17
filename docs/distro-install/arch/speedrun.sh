#!/bin/bash

# ==========================================================
# Arch Linux Speedrun - Instalación completamente automática
# ==========================================================
# Uso desde Arch ISO:
#   1. wget -O - https://tu-server/speedrun.sh | bash
#   2. O copia este script y ejecútalo
#
# Requisitos: disco /dev/vda (10GB+)
# ==========================================================

set -e

DISK="/dev/vda"
BOOT_SIZE="512M"
SWAP_SIZE="1G"
HOSTNAME="arch-vm-01"
ZONEINFO="America/Mexico_City"
PASSWORD="root"

echo "==> Particionando $DISK..."
parted -s "$DISK" mklabel msdos
parted -s "$DISK" mkpart primary fat32 1MiB "$BOOT_SIZE"
parted -s "$DISK" mkpart primary linux-swap "$BOOT_SIZE" "$SWAP_SIZE"
parted -s "$DISK" mkpart primary ext4 "$SWAP_SIZE" 100%

BOOT_PART="${DISK}1"
SWAP_PART="${DISK}2"
ROOT_PART="${DISK}3"

echo "==> Formateando..."
mkfs.fat -F32 "$BOOT_PART"
mkswap "$SWAP_PART"
mkfs.ext4 "$ROOT_PART"

echo "==> Montando..."
swapon "$SWAP_PART"
mount "$ROOT_PART" /mnt
mount --mkdir "$BOOT_PART" /mnt/boot

echo "==> Instalando sistema base..."
pacstrap -K /mnt base linux linux-firmware

echo "==> Generando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "==> Configurando sistema..."
arch-chroot /mnt /bin/bash <<EOF
    echo "$HOSTNAME" > /etc/hostname
    ln -sf "/usr/share/zoneinfo/$ZONEINFO" /etc/localtime
    hwclock --systohc

    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen

    echo -e "$PASSWORD\n$PASSWORD" | passwd

    pacman -S --noconfirm grub openssh networkmanager
    grub-install "$DISK"
    grub-mkconfig -o /boot/grub/grub.cfg

    systemctl enable sshd NetworkManager
EOF

echo "==> Desmontando..."
umount -R /mnt

echo ""
echo "Instalación completada. Reinicia con: reboot"
echo "Usuario: root"
echo "Contraseña: $PASSWORD"
