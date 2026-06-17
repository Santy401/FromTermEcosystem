# Virtualización por terminal con virt-install

## ¿Qué estamos haciendo?

Normalmente las VMs se manejan con interfaz gráfica (VirtualBox, VMware). Pero en un servidor headless (sin monitor) todo se hace por **terminal SSH**. virt-install + libvirt permiten crear y gestionar VMs completamente desde la terminal.

## ¿Cómo se ve la VM en mi terminal?

La clave está en:

```
--console pty,target_type=serial
```

Esto conecta el **puerto serie virtual** de la VM a tu terminal. Cuando ejecutas `virsh console arch-vm-01`, tu SSH se engancha a ese puerto serie y ves la salida de la VM como si estuvieras sentado frente a ella.

## Comandos básicos para gestionar VMs

| Comando | Qué hace |
|---|---|
| `virsh console arch-vm-01` | Entrar a la consola de la VM |
| `Ctrl + ]` | Salir de la consola (sin apagar la VM) |
| `virsh destroy arch-vm-01` | Apagar la VM forzadamente |
| `virsh undefine arch-vm-01` | Borrar la definición de la VM |
| `virsh list --all` | Ver todas las VMs |
| `virsh start arch-vm-01` | Encender una VM apagada |
| `virsh shutdown arch-vm-01` | Apagado suave (ACPI) |

## Errores que encontramos y solución

### Error 1: `--cdrom` no muestra instalación en texto

```bash
virt-install --cdrom archivo.iso
```

El menú de boot del ISO de Arch usa ISOLINUX (interfaz gráfica), no texto. En consola serie no se ve bien.

### Error 2: `--location` no funciona con ISO de Arch

```
ERROR: Could not find an installable distribution at URL
```

`--location` funciona con ISOs que tienen árbol de instalación (Debian, Fedora), pero Arch no usa esa estructura. Necesita un directorio con `vmlinuz` + `initrd` + `squashfs`.

### Error 3: No podía destruir la VM por nvram

```
error: cannot undefine domain with nvram
```

Cuando usas `--boot uefi`, se crea un archivo nvram (firmware UEFI). Para borrarla completamente:

```bash
virsh undefine --nvram arch-vm-01
```

### Error 4: Arch ISO no encuentra el disco de instalación

```
ERROR: '/dev/disk/by-label/ARCH_202606' device did not show up after 30 seconds
```

El kernel sabía qué label buscar (`archisolabel=ARCH_202606`) pero el CDROM no estaba conectado a la VM. La solución fue agregar el ISO como segundo disco:

```
--disk path=archivo.iso,device=cdrom
```

### Error 5: Disco en uso al recrear la VM

```
ERROR: Disk is already in use by other guests
```

Aunque la VM esté destruida, libvirt mantiene la definición. Primero undefined correctamente:

```bash
virsh destroy arch-vm-01      # apagar
virsh undefine --nvram arch-vm-01  # borrar definición + nvram si usó UEFI
```

Luego volver a ejecutar virt-install.

### Error 6: Falta método de instalación al usar `--boot kernel`

```
ERROR: Debe indicarse un método de instalación
```

Al pasar kernel/initrd directamente con `--boot`, virt-install no sabe cómo bootear. Hay que decirle `--import` para que no busque medio de instalación:

```bash
--import \
--boot kernel=/ruta/vmlinuz,initrd=/ruta/initramfs.img,...
```

## Solución final: `--import` + kernel directo + cdrom

La combinación ganadora:

1. Extraer kernel e initrd del ISO:
   ```bash
   mkdir -p ~/FromTermEcosystem/tmp
   sudo mount -o loop archlinux-2026.06.01-x86_64.iso /mnt/archiso
   cp /mnt/archiso/arch/boot/x86_64/vmlinuz-linux ~/FromTermEcosystem/tmp/
   cp /mnt/archiso/arch/boot/x86_64/initramfs-linux.img ~/FromTermEcosystem/tmp/
   sudo umount /mnt/archiso
   ```

2. Obtener el label del ISO:
   ```bash
   blkid archlinux-2026.06.01-x86_64.iso
   # LABEL="ARCH_202606"
   ```

3. Crear la VM:
   ```bash
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
     --boot kernel=/home/developer/server-journey/tmp/vmlinuz-linux,initrd=/home/developer/server-journey/tmp/initramfs-linux.img,kernel_args="console=ttyS0 archisolabel=ARCH_202606" \
     --console pty,target_type=serial
   ```

4. La VM arranca directo en la terminal y te deja en el prompt de instalación de Arch.
