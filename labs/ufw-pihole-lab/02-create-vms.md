# Fase 2 — Crear las 3 VMs (nombres exactos)

Comandos probados en el lab. Se usa `--location` (instalador de **texto** en la
consola serial, ideal para headless) y el disco se crea en el **pool por defecto**
de libvirt (`/var/lib/libvirt/images/`).

> `--extra-args "console=ttyS0,115200 netcfg/get_nameservers=192.168.122.1"`
> - `console=ttyS0,115200` → el instalador imprime en la consola serial
> - `netcfg/get_nameservers=192.168.122.1` → DNS bootstrap con el Pi-hole del host
>   (el DNS de libvirt está desactivado)

## vm-pihole (servidor DNS + firewall)

```bash
virt-install \
  --name vm-pihole --ram 2048 --vcpus 2 \
  --disk size=15,bus=sata \
  --location /var/lib/libvirt/images/debian-12-netinst.iso \
  --os-variant debian12 \
  --network network=default \
  --graphics none --console pty,target_type=serial \
  --extra-args "console=ttyS0,115200 netcfg/get_nameservers=192.168.122.1"
```

## vm-client-1 (cliente de prueba)

```bash
virt-install \
  --name vm-client-1 --ram 1024 --vcpus 1 \
  --disk size=10,bus=sata \
  --location /var/lib/libvirt/images/debian-12-netinst.iso \
  --os-variant debian12 \
  --network network=default \
  --graphics none --console pty,target_type=serial \
  --extra-args "console=ttyS0,115200 netcfg/get_nameservers=192.168.122.1"
```

## vm-client-2 (cliente de prueba)

```bash
virt-install \
  --name vm-client-2 --ram 1024 --vcpus 1 \
  --disk size=10,bus=sata \
  --location /var/lib/libvirt/images/debian-12-netinst.iso \
  --os-variant debian12 \
  --network network=default \
  --graphics none --console pty,target_type=serial \
  --extra-args "console=ttyS0,115200 netcfg/get_nameservers=192.168.122.1"
```

## Configuración durante la instalación (las 3 VMs)

1. **Install** (instalador de texto)
2. Hostname → `debian-pihole` / `client-1` / `client-2`
3. Dominio → `lab.local`
4. Usuario → `pihole` (vm-pihole) / `santi` (clientes), con **sudo**
5. Particionado → **Guided – use entire disk**
6. Red → DHCP (recibe 192.168.122.x)
7. Software → marcar **SSH server**, resto minimal
8. Reboot al final

> Para salir de la consola serial: **`Ctrl` + `]`** (la VM sigue corriendo).
> Para volver: `virsh console <vm>`.

## Resultado verificado

```bash
virsh list --all
```

```
 Id   Name          State
------------------------------
 5    vm-pihole     running
 7    vm-client-1   running
 9    vm-client-2   running
```

| VM | MAC | Disco |
|---|---|---|
| `vm-pihole` | `52:54:00:80:d5:62` | `/var/lib/libvirt/images/vm-pihole.qcow2` |
| `vm-client-1` | `52:54:00:cf:5f:41` | `/var/lib/libvirt/images/vm-client-1.qcow2` |
| `vm-client-2` | `52:54:00:93:97:76` | `/var/lib/libvirt/images/vm-client-2.qcow2` |

## Acceso por SSH

```bash
virsh domifaddr <vm>                 # IP actual (DHCP dinámico)
ssh <usuario>@<ip-de-la-vm>          # pihole@... en vm-pihole, santi@... en los clientes
```

## Errores típicos de esta fase

| Error | Causa | Solución |
|---|---|---|
| `Permission denied` sobre el `.qcow2` | Disco dentro de `/home/craxker` | Quitar `path=` y dejar `size=` (usa el pool) |
| `Could not open '...iso': Permission denied` | QEMU no puede leer el home | Copiar la ISO a `/var/lib/libvirt/images/` |
| No imprime el instalador | `--cdrom` no muestra salida en serial | Usar `--location` + `console=ttyS0,115200` |
| `ssh: connect ... port 22: Network is unreachable` | IP de broadcast (`.255`) o red reiniciándose | Usar `virsh domifaddr` y probar con `ping` |
