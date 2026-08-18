# Lab: Red, UFW/puertos y Pi-hole en 3 VMs Debian

> **Objetivo**: aprender cómo funcionan las IPs en servidores, manejar el firewall
> **UFW** y montar un **Pi-hole local aislado**, todo dentro de un laboratorio de VMs
> por terminal. Nada de esto toca la red real del host.

## Diagrama de arquitectura

```
                        ┌────────────────────────────── nexuscloud ──────────────────────────────┐
                        │  Ubuntu 24.04 · KVM/QEMU · 192.168.1.9/24 (enp1s0)                    │
                        │                                                                       │
                        │  Docker host: pihole (:53) ── escucha 0.0.0.0:53  ⚠️ conflicto de 53  │
                        │                                                                       │
                        │  virbr0 ── switch virtual ── 192.168.122.1/24                         │
                        │    ├─ dnsmasq  DHCP   (reparte 122.2 – 122.254)                       │
                        │    └─ dnsmasq  DNS    ✗ desactivado (<dns enable="no"/>)              │
                        │         └─> así NO choca con el Pi-hole del host en :53               │
                        └────────────────────────────┬──────────────────────────────────────────┘
                                                     │  NAT → internet (las VMs salen "disfrazadas")
                    ┌────────────────────────────────┼──────────────────────────────┐
                    │                                │                              │
      ┌─────────────▼─────────────┐    ┌─────────────▼─────────────┐    ┌────────────▼─────────────┐
      │      vm-pihole            │    │      vm-client-1          │    │      vm-client-2          │
      │   hostname: debian-pihole │    │   hostname: client-1      │    │   hostname: client-2      │
      │   2 vCPU · 2GB · 15GB     │    │   1 vCPU · 1GB · 10GB     │    │   1 vCPU · 1GB · 10GB     │
      │   user: pihole            │    │   user: santi             │    │   user: santi             │
      │   192.168.122.219         │    │   192.168.122.147         │    │   192.168.122.134         │
      │                           │    │                           │    │                           │
      │  UFW: 22/tcp 80/tcp       │    │  UFW: 22/tcp 80/tcp       │    │  UFW: 22/tcp 80/tcp       │
      │  nginx (:80)              │    │  nginx (:80)              │    │  nginx (:80)              │
      │  Pi-hole (53 · 80 · admin)│    │                           │    │                           │
      │  ── DNS del laboratorio ──┼────┼──► resuelven DNS aquí ────┼───►│                          │
      └───────────────────────────┘    └───────────────────────────┘    └──────────────────────────┘
```

## Tabla de VMs (estado real del lab)

| VM | MAC | Disco | IP DHCP (dinámica) | Rol |
|---|---|---|---|---|
| `vm-pihole` | `52:54:00:80:d5:62` | `/var/lib/libvirt/images/vm-pihole.qcow2` | `192.168.122.219` | Servidor DNS (Pi-hole) + firewall |
| `vm-client-1` | `52:54:00:cf:5f:41` | `/var/lib/libvirt/images/vm-client-1.qcow2` | `192.168.122.147` | Cliente de prueba |
| `vm-client-2` | `52:54:00:93:97:76` | `/var/lib/libvirt/images/vm-client-2.qcow2` | `192.168.122.134` | Cliente de prueba |

> Las IPs son **dinámicas** (DHCP). La fuente de verdad siempre es:
> `virsh domifaddr <vm>`.

## Fases del lab

| Fase | Tema | Documento | Estado |
|---|---|---|---|
| 1 | Preparar el host (KVM + red virbr0 + ISO) | [01-host-setup.md](01-host-setup.md) | ✅ Ejecutado |
| 2 | Crear las 3 VMs por terminal | [02-create-vms.md](02-create-vms.md) | ✅ Ejecutado |
| 3 | UFW: abrir/cerrar/borrar puertos | [03-ufw-puertos.md](03-ufw-puertos.md) | 🔄 Parcial (vm-pihole listo) |
| 4 | Pi-hole aislado + DNS de la red | [04-pihole-integration.md](04-pihole-integration.md) | ⏳ Pendiente |

## Comandos de orquestación (resumen)

```bash
virsh list --all                  # estado de las 3 VMs
virsh domifaddr <vm>              # IP actual de una VM
virsh console <vm>                # consola serial (salir con Ctrl + ])
virsh shutdown/start/reboot <vm>  # ciclo de vida
```

## Lo que se aprende

1. Qué es una IP, un puerto y un servicio (SSH/HTTP/DNS)
2. Qué hace un bridge (`virbr0`), el DHCP y el NAT
3. Cómo un firewall (UFW) filtra puertos y por qué abrir SSH **antes** de habilitarlo
4. Cómo se integra un resolver DNS (Pi-hole) dentro de una red aislada
