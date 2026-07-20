# [Nombre Distro]

## Info rápida

| Campo | Valor |
|---|---|
| **Tipo** | Rolling / Stable / Inmutable / Punto-fijo |
| **Package manager** | pacman / apt / apk / xbps / emerge / nix |
| **Init system** | systemd / openrc / runit / s6 / dinit |
| **Facilidad** | Fácil / Media / Difícil |
| **Arquitecturas** | x86_64 / aarch64 / i686 |
| **ISO tamaño aprox** | ~XX MB |
| **RAM mínima** | XX MB |
| **Server-ready** | Sí / No / Con trabajo |

## Instalación manual

```
virt-install \
  --nombre vm-name \
  --ram 2048 \
  --vcpus 2 \
  --disk path=~/vms/vm-name.qcow2,size=10 \
  --cdron ~/isos/distro.iso \
  --os-variant ... \
  --network network=default \
  --graphics none \
  --console pty,target_type=serial
```

### Pasos

1.
2.
3.

### Post-instalación

```bash

```

## Errores encontrados

| Error | Causa | Solución |
|---|---|---|

## Variante server

```bash

```

## Variante "difícil" (hardened, minimal, etc.)

```bash

```

## Speedrun?

| Intento | Tiempo | Fecha | Notas |
|---|---|---|---|
