# Red de VMs: virbr0 y NAT

Cuando instalas libvirt, crea automáticamente:

## virbr0
- Un switch virtual (bridge) en el host
- IP del host en esa red: 192.168.122.1
- Las VMs reciben IP automáticamente vía DHCP: 192.168.122.2 - 192.168.122.254

## NAT
- Las VMs salen a internet usando la IP del host (enmascaramiento NAT)
- Las VMs pueden verse entre sí en 192.168.122.0/24
- El host puede hacer SSH a cualquier VM en esa red

## Acceso SSH
Para conectar por SSH a una VM desde el host:
ssh user@192.168.122.x
