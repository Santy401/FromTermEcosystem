# Arch Linux — Notas y variantes

## Variantes de instalación

| Método | Cuándo usarlo |
|---|---|
| **Manual (standard.md)** | Para aprender, depurar, o personalizar cada paso |
| **Speedrun (speedrun.sh)** | Cuando ya sabes el proceso y quieres repetirlo rápido |

## Variantes de particionado

### GPT + UEFI

Si usas `--boot uefi` en virt-install:

| Partición | Tamaño | Tipo | Formato |
|---|---|---|---|
| vda1 | 512M | EFI System (EF) | mkfs.fat -F32 |
| vda2 | 1G | Linux swap (82) | mkswap |
| vda3 | Resto | Linux (83) | mkfs.ext4 |

Y el bootloader cambia a:
```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

### Sin swap (si tienes mucha RAM)

Solo dos particiones:
| Partición | Tamaño | Formato |
|---|---|---|
| vda1 | 512M | mkfs.fat -F32 |
| vda2 | Resto | mkfs.ext4 |

## Paquetes útiles post-instalación

```bash
# Herramientas básicas
pacman -S sudo vim git htop neofetch bash-completion

# Crear usuario normal
useradd -m -G wheel developer
passwd developer
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
```

## Errores comunes

### "archisolabel no found"

El kernel no encuentra el ISO. Verifica que el CDROM esté conectado a la VM y que el label coincida:
```bash
blkid archivo.iso
```

### "grub-install: error: failed to get canonical path"

Falta montar `/boot`. Asegúrate de que `/dev/vda1` esté montado en `/mnt/boot`.

### No puedo hacer SSH

```bash
systemctl status sshd  # debe estar active (running)
ip a                    # verificar IP
```
