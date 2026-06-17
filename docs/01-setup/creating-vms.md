# Crear VMs con virt-install

## Sintaxis básica

virt-install opciones

## Opciones principales

| Opción | Qué hace | Ejemplo |
|---|---|---|
| `--name` | Nombre de la VM | `--name arch-vm-01` |
| `--ram` | RAM en MB | `--ram 2048` = 2 GB |
| `--vcpus` | Número de CPUs virtuales | `--vcpus 1` |
| `--disk` | Disco virtual: ruta y tamaño | `--disk path=~/vm.qcow2,size=10` |
| `--cdrom` | ISO de instalación | `--cdrom ~/arch.iso` |
| `--os-variant` | Sistema operativo (optimiza la VM) | `--os-variant archlinux` |
| `--network` | Red de la VM | `--network network=default` |
| `--graphics none` | Sin interfaz gráfica (headless) | |
| `--console` | Consola por puerto serie | `--console pty,target_type=serial` |

## Ver variantes de OS disponibles

osinfo-query os | grep arch

## Personalizar

- Más RAM: `--ram 4096` (4 GB)
- Más CPUs: `--vcpus 2`
- Más disco: `--disk size=20` (20 GB)
- Sin CDROM (para VM ya instalada): quitar `--cdrom`
