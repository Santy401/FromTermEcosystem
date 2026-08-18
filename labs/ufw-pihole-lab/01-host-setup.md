# Fase 1 — Preparar el host

Todo el laboratorio vive **dentro** del host. Esta fase se ejecuta **una sola vez**
sobre nexuscloud (Ubuntu 24.04, KVM habilitado).

## 1. Instalar el stack de virtualización

```bash
sudo apt update
sudo apt install -y libvirt-daemon-system virtinst qemu-system-x86 bridge-utils libosinfo-bin
```

## 2. Activar libvirtd (socket-activated)

`libvirtd` está **socket-activated**: arranca solo al primer `virsh`. El estado
`inactive (dead)` es normal mientras no se use.

```bash
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
# Cerrar sesión y volver a entrar (o `newgrp libvirt`) para aplicar el grupo
```

## 3. Configurar virsh para el daemon del sistema

Sin esto, `virsh` conecta al daemon **de sesión** (per-usuario) y da
`Network not found` aunque la red exista:

```bash
echo 'export LIBVIRT_DEFAULT_URI=qemu:///system' >> ~/.bashrc
source ~/.bashrc
```

> Si el grupo `libvirt` se agregó recién, `source ~/.bashrc` en la misma shell no
> cambia el grupo: hace falta re-login o `newgrp libvirt` y volver a `source`.

## 4. El conflicto del puerto 53 (importante)

En este host corre **Pi-hole en Docker con `network_mode: host`**, escuchando en
`0.0.0.0:53`. El dnsmasq de libvirt intenta abrir `192.168.122.1:53` al levantar
virbr0 → **EADDRINUSE** y la red no arranca:

```
dnsmasq: failed to create listening socket for 192.168.122.1: Address already in use
```

**Solución aplicada**: desactivar el **DNS** de la red `default` (el DHCP y el NAT
siguen funcionando). Con `<dns enable="no"/>` libvirt lanza dnsmasq con `--port=0`.

```bash
sudo sed -i 's#</network>#  <dns enable="no"/>\n</network>#' /etc/libvirt/qemu/networks/default.xml
sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
```

## 5. Levantar la red `default`

```bash
virsh net-start default && virsh net-autostart default
virsh net-list --all
ip a show virbr0
```

Resultado esperado:

```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

`virbr0` sale con `state DOWN` y `192.168.122.1/24` → es **normal** (NO-CARRIER =
ninguna VM conectada todavía; sube a UP con la primera VM).

### Red `default` resultante (verificada con `virsh net-dumpxml default`)

```xml
<network connections='3'>
  <name>default</name>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <dns enable='no'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

## 6. Descargar la ISO de Debian 12 (netinst)

```bash
curl -L -o ~/github/FromTermEcosystem/scripts/debian-12-netinst.iso \
  https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12-netinst.iso
```

Copiar al pool de libvirt (QEMU no puede leer `/home/craxker`, modo `drwxr-x---`):

```bash
sudo cp ~/github/FromTermEcosystem/scripts/debian-12-netinst.iso /var/lib/libvirt/images/
```

## Checklist de verificación

```bash
virsh net-list --all     # default active
ip a show virbr0         # 192.168.122.1/24
ls -la /var/lib/libvirt/images/debian-12-netinst.iso   # ISO ~700MB
```

## Errores típicos de esta fase

| Error | Causa | Solución |
|---|---|---|
| `Network not found: no network with matching name` | virsh conectando a `qemu:///session` | `export LIBVIRT_DEFAULT_URI=qemu:///system` + `source ~/.bashrc` |
| `Failed to connect socket ... Permission denied` | La sesión no tiene el grupo `libvirt` | Re-login o `newgrp libvirt` |
| `Could not open '...iso': Permission denied` | ISO dentro de `/home/craxker` (inaccesible para QEMU) | Copiar la ISO a `/var/lib/libvirt/images/` |
| `Address already in use` al iniciar la red | Pi-hole del host ocupando `:53` | `<dns enable="no"/>` en la red |
