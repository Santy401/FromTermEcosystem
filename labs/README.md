# Labs — Prácticas aisladas en VMs

Laboratorios reproducibles y **100% aislados** del host: se prueban servidores,
redes, firewalls y DNS sin tocar nada de la red real.

## Índice

| Lab | Tema | Estado |
|---|---|---|
| [ufw-pihole-lab](ufw-pihole-lab/) | Red, UFW/puertos y Pi-hole en 3 VMs Debian | 🔄 En progreso |

## Cómo leer un lab

Cada lab sigue la misma secuencia:

1. **`01-host-setup.md`** — preparar el host (KVM, red virbr0, ISO)
2. **`02-create-vms.md`** — crear las VMs con comandos exactos
3. **`NN-*`** — cada práctica de aprendizaje (firewall, DNS, etc.)

Todos los comandos están pensados para correr **por terminal**, sin interfaz gráfica.
