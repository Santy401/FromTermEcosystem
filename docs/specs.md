# Especificaciones del Servidor — FromTermEcosystem

| Componente | Detalle |
|---|---|
| **Hostname** | homeServerCasaOS |
| **Modelo** | Lenovo ThinkCentre M60e |
| **OS** | Ubuntu 24.04.4 LTS (Noble Numbat) |
| **Kernel** | Linux 6.8.0-124-generic |
| **CPU** | Intel Core i3-1005G1 (2 cores / 4 threads) @ 1.20GHz base / 3.40GHz max |
| **RAM** | 23 GiB (24 GB) |
| **Disco NVMe** | WDC PC SN530 256GB (OS + sistema) |
| **Disco SATA** | TOSHIBA MQ01ABF0 500GB (datos) |
| **Red** | 192.168.1.9/24 (enp1s0) + Tailscale + Docker networks |
| **Virtualización** | KVM/QEMU habilitado (VT-x + /dev/kvm) |
| **Red VMs** | virbr0 NAT: 192.168.122.0/24 (auto-asignación) |
