# Speedrun — Instalación contrarreloj

## ¿Qué es esto?

Un speedrun de Arch consiste en instalar el sistema completo desde cero en el menor tiempo posible. Este proyecto incluye un script que automatiza la creación de la VM, abre un cronómetro, y registra tu tiempo.

## Preparación

Primero instala `screen` en tu servidor:

```bash
sudo apt install screen
```

## Cómo hacer un speedrun

### 1. Lanzar el script

```bash
~/FromTermEcosystem/scripts/arch-speedrun.sh
```

Esto:
- Destruye la VM anterior si existe
- Crea una VM nueva con disco SATA (sda)
- Inicia un `screen` con cronómetro
- Te conecta automáticamente a la consola

### 2. Instalar Arch

Desde la consola de la VM, ejecuta los comandos de instalación. El cronómetro corre desde que arranca.

Secuencia óptima (la más rápida):

```bash
# Particionado rápido (todo en un solo comando)
echo -e "o\nn\np\n1\n\n+512M\nt\n1\nef\nn\np\n2\n\n\nw" | fdisk /dev/sda

# Formatear
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Montar
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

# Pacstrap (lo que más tarda)
pacstrap -K /mnt base linux linux-firmware

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot + configuración mínima
arch-chroot /mnt /bin/bash -c "
    echo 'arch-speedrun' > /etc/hostname
    ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
    hwclock --systohc
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen
    echo 'root:root' | chpasswd
    pacman -S --noconfirm grub openssh networkmanager
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    systemctl enable sshd NetworkManager
"

# Desmontar y apagar
umount -R /mnt
poweroff
```

> NOTA: usamos `poweroff` en vez de `reboot` porque la VM arranca con el kernel del ISO directamente. Si hicieras `reboot`, volvería a entrar al ISO. `poweroff` apaga la VM limpiamente y detiene el cronómetro.

### 3. Ver tu tiempo

Cuando ejecutes `poweroff`, la VM se apaga y el cronómetro se detiene. El `screen` muestra tu tiempo total automáticamente. Vuelve a tu servidor:

```
Ctrl+A, D  (para salir del screen)
```

Mira el tiempo con:
```bash
screen -r arch-speedrun
```

### 4. Registrar tu récord

Apunta tu tiempo en `~/FromTermEcosystem/notes/speedrun-records.md`:

```markdown
# Récords de Speedrun

| Fecha | Tiempo | Notas |
|---|---|---|
| 2026-06-16 | 4:32 | Primer intento, me trabé en particionado |
| 2026-06-16 | 3:15 | Ya más fluido |
```

## Trucos para bajar tiempo

| Técnica | Ahorro estimado |
|---|---|
| Usar `echo -e "..." \| fdisk` en vez de interactivo | ~30s |
| No instalar `linux-firmware` (en VM no hace falta) | ~3min |
| Usar `copy` en vez de `pacstrap` | ~2min |
| Scriptear todo el chroot con `-c` | ~20s |
| Tener los comandos copiados, no escribirlos | ~1min |

## Récords mundiales (para referencia)

El speedrun de Arch instalado en VM desde ISO suele estar entre **3-4 minutos** con práctica.
