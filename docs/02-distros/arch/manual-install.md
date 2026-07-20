# Arch Linux — Instalación manual

## Boot de la ISO por consola serie

Porque Arch ISO usa ISOLINUX (interfaz gráfica), no se puede bootear directo con `--cdrom`. 
Se necesita extraer kernel + initrd y pasar el ISO como CDROM:

```bash
# Extraer kernel e initrd
mkdir -p ~/FromTermEcosystem/tmp
sudo mount -o loop archlinux-2026.06.01-x86_64.iso /mnt/archiso
cp /mnt/archiso/arch/boot/x86_64/vmlinuz-linux ~/FromTermEcosystem/tmp/
cp /mnt/archiso/arch/boot/x86_64/initramfs-linux.img ~/FromTermEcosystem/tmp/
sudo umount /mnt/archiso

# Obtener label del ISO
blkid archlinux-2026.06.01-x86_64.iso
# LABEL="ARCH_202606"

# Crear la VM
virt-install \
  --name arch-vm-01 \
  --ram 2048 \
  --vcpus 1 \
  --disk path=~/FromTermEcosystem/scripts/arch-vm-01.qcow2,size=10 \
  --disk path=~/FromTermEcosystem/scripts/archlinux-2026.06.01-x86_64.iso,device=cdrom \
  --os-variant archlinux \
  --network network=default \
  --graphics none \
  --import \
  --boot kernel=/home/user/FromTermEcosystem/tmp/vmlinuz-linux,initrd=/home/user/FromTermEcosystem/tmp/initramfs-linux.img,kernel_args="console=ttyS0 archisolabel=ARCH_202606" \
  --console pty,target_type=serial
```

## Variantes de particionado

### GPT + UEFI

| Partición | Tamaño | Tipo | Formato |
|---|---|---|---|
| vda1 | 512M | EFI System (EF) | mkfs.fat -F32 |
| vda2 | 1G | Linux swap (82) | mkswap |
| vda3 | Resto | Linux (83) | mkfs.ext4 |

Bootloader:
```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

### GPT + UEFI sin swap

| Partición | Tamaño | Formato |
|---|---|---|
| vda1 | 512M | mkfs.fat -F32 |
| vda2 | Resto | mkfs.ext4 |

### MBR + BIOS (legacy)

| Partición | Tamaño | Tipo | Formato |
|---|---|---|---|
| vda1 | 1G | Linux swap (82) | mkswap |
| vda2 | Resto | Linux (83) | mkfs.ext4 |

Bootloader:
```bash
pacman -S grub
grub-install --target=i386-pc /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg
```

## Pasos de instalación

```bash
# 1. Particionar
fdisk /dev/vda

# 2. Formatear
mkfs.fat -F32 /dev/vda1   # si es EFI
mkfs.ext4 /dev/vda2        # o vda3 según el esquema
mkswap /dev/vda2 && swapon /dev/vda2  # si hay swap

# 3. Montar
mount /dev/vda2 /mnt        # o vda3
mount --mkdir /dev/vda1 /mnt/boot  # solo UEFI

# 4. Instalar sistema base
pacstrap -K /mnt base linux linux-firmware

# 5. Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 6. Chroot
arch-chroot /mnt

# 7. Configurar
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "arch-vm" > /etc/hostname
passwd

# 8. Instalar bootloader
# (según esquema de particionado, ver arriba)

# 9. Servicios básicos
systemctl enable sshd

# 10. Salir y reiniciar
exit
umount -R /mnt
reboot
```

## Post-instalación

```bash
# Primer login como root
pacman -S sudo vim git htop neofetch bash-completion

# Crear usuario normal
useradd -m -G wheel developer
passwd developer
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
```

## Errores encontrados

| Error | Causa | Solución |
|---|---|---|
| `archisolabel no found` | Kernel no encuentra el ISO | Verificar CDROM conectado y label con `blkid` |
| `grub-install: error: failed to get canonical path` | Falta montar `/boot` | Asegurar `/dev/vda1` montado en `/mnt/boot` |
| No puedo hacer SSH | sshd no activo o IP desconocida | `systemctl status sshd`, `ip a` |
| `Disk is already in use by other guests` | Definición de VM persistió | `virsh undefine --nvram vm-name` antes de recrear |
| `--location` no funciona con Arch | Arch no usa árbol de instalación | Usar `--boot kernel=...` + `--import` |
