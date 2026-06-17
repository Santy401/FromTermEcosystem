# Instalación estándar de Arch Linux

## Particionado

```bash
fdisk /dev/vda
```

Esquema para BIOS (MBR):
| Partición | Tamaño | Tipo | Formato |
|---|---|---|---|
| vda1 | 512M | Linux (83) | mkfs.fat -F32 |
| vda2 | 1G | Linux swap (82) | mkswap |
| vda3 | Resto | Linux (83) | mkfs.ext4 |

```bash
mkfs.fat -F32 /dev/vda1
mkfs.ext4 /dev/vda3
mkswap /dev/vda2
swapon /dev/vda2
```

## Montar particiones

```bash
mount /dev/vda3 /mnt
mount --mkdir /dev/vda1 /mnt/boot
```

## Instalar sistema base

```bash
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
```

## Configurar el sistema

```bash
arch-chroot /mnt
```

### Zona horaria y reloj

```bash
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc
```

### Localización

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
```

### Hostname

```bash
echo "arch-vm-01" > /etc/hostname
```

### Contraseña de root

```bash
passwd
```

### Bootloader (GRUB)

```bash
pacman -S grub
grub-install /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg
```

### Servicios esenciales

```bash
pacman -S openssh networkmanager
systemctl enable sshd NetworkManager
```

### Salir y reiniciar

```bash
exit
umount -R /mnt
reboot
```

## Post-instalación

```bash
ip a                     # ver IP
ping -c 3 archlinux.org  # probar internet
```

Desde el server host:
```bash
ssh root@192.168.122.x
```
