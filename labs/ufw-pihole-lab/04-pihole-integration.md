# Fase 4 — Pi-hole aislado + DNS del laboratorio

> ⏳ **Estado**: pendiente de ejecutar. Esta fase documenta los comandos exactos
> para el siguiente paso del lab.

**Objetivo**: instalar **Pi-hole** dentro de `vm-pihole` para que sea el resolver
DNS de todo el laboratorio — completamente aislado, sin tocar el Pi-hole del host
ni la red real.

## Diagrama del flujo DNS

```
                  vm-pihole (192.168.122.219)
        ┌─────────────────────────────────────────┐
        │   Pi-hole  ──  :53 (DNS)                │
        │     │         :80 (dashboard /admin)    │
        │     │         UFW: 22 · 53 · 80 · 443   │
        └─────┬───────────────────────────────────┘
              │  "¿cuál es la IP de google.com?"
     ┌────────┴────────┐       ┌──────────────┐
     ▼                 ▼       ▼              ▼
vm-client-1      vm-client-2        (y cualquier VM que
122.147          122.134             apunte aquí su DNS)
resolv.conf ──►  192.168.122.219
```

## 1. Instalar Pi-hole dentro de vm-pihole

```bash
ssh pihole@192.168.122.219
sudo curl -sSL https://install.pi-hole.net | bash
```

Durante el setup:
- Interfaz: seleccionar **enp1s0** (la única)
- Proveedor DNS upstream: el que prefieras (ej. Cloudflare)
- IP del Pi-hole: la que muestre (`192.168.122.219`)

## 2. Abrir los puertos de Pi-hole en el UFW de la VM

```bash
sudo ufw allow 53/tcp && sudo ufw allow 53/udp     # DNS
sudo ufw allow 80/tcp                              # dashboard
sudo ufw allow 443/tcp                             # https (opcional)
sudo ufw status numbered
```

## 3. Verificar desde nexuscloud

```bash
curl -I http://192.168.122.219/admin       # dashboard de Pi-hole
dig @192.168.122.219 google.com            # → respuesta del Pi-hole interno
```

## 4. Apuntar los clientes al Pi-hole del lab

```bash
# dentro de vm-client-1 y vm-client-2
sudo nano /etc/resolv.conf
# nameserver 192.168.122.219
```

Probar desde cada cliente:

```bash
dig google.com                            # resuelve vía Pi-hole del lab
nslookup doblepru.github.io
```

## 5. Ver el filtrado (blocklists)

1. Entrar a `http://192.168.122.219/admin`
2. Login (la contraseña la muestra el instalador)
3. Agregar una blocklist de prueba o marcar un dominio
4. `dig` de un dominio bloqueado → responde con `0.0.0.0`
5. Consultar el apartado **Query Log** para ver qué piden los clientes

## 6. IPs fijas (reproducibilidad)

El DHCP asigna IPs dinámicas; para que el laboratorio sea reproducible, fijar
leases estáticos en la red `default`:

```bash
sudo virsh net-edit default
```

Dentro de `<dhcp>` agregar por cada VM (usar sus MAC reales):

```xml
<host mac='52:54:00:80:d5:62' ip='192.168.122.20'/>
<host mac='52:54:00:cf:5f:41' ip='192.168.122.21'/>
<host mac='52:54:00:93:97:76' ip='192.168.122.22'/>
```

Reiniciar la red (⚠️ corta el NAT momentáneamente):

```bash
sudo virsh net-destroy default && sudo virsh net-start default
# o reiniciar cada VM
```

## Cheat-sheet DNS

| Herramienta | Uso |
|---|---|
| `dig @<ip> <dominio>` | Consultar DNS contra un servidor específico |
| `nslookup <dominio>` | Consulta simple |
| `/etc/resolv.conf` | Nameservers del sistema |
| `ss -tulpn \| grep :53` | Ver qué escucha en el puerto 53 |
