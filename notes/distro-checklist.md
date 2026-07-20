# Distro Checklist — FromTermEcosystem

El ecosistema GNU/Linux y sus primos BSD, ordenado por familias y prioridad de aprendizaje.

## Prioridad recomendada

| # | Distro | Por qué aprenderla |
|---|---|---|
| 1 | **Debian** | Base de casi todo servidor, instalación texto nativa, estable |
| 2 | **Alpine Linux** | Minimal, musl + openrc, init alternativo, base de contenedores |
| 3 | **FreeBSD** | No Linux — el contraste te enseña Linux mejor (ZFS, jails, pf) |
| 4 | **Gentoo** | Source-based, te obliga a entender cada paquete y el sistema |
| 5 | **NixOS** | Paradigma declarativo/inmutable, cambia la forma de pensar |
| 6 | **Void Linux** | Rolling + runit, medio entre Arch y Alpine, liviano |
| 7 | **Slackware** | La más antigua activa, simplicidad UNIX sin systemd |
| 8 | **Linux From Scratch** | Construir Linux desde cero: la comprensión definitiva |

## Debian y derivados

- [ ] **Debian** — estable, universal, base de servidores
- [ ] **Ubuntu Server** — popular, compatibilidad, ecosistema
- [ ] **Ubuntu Core** — inmutable, snap-centric, IoT

## Red Hat y familia

- [ ] **Fedora Server** — innovación, SELinux por defecto
- [ ] **Fedora Workstation** — escritorio, Wayland, GNOME moderno
- [ ] **Fedora Silverblue** — inmutable, ostree, contenedores
- [ ] **Fedora CoreOS** — minimal, auto-actualizable, cloud-native
- [ ] **CentOS Stream** — rolling-upstream de RHEL
- [ ] **Rocky Linux** — clon 1:1 de RHEL, enterprise
- [ ] **AlmaLinux** — clon 1:1 de RHEL, community-driven
- [ ] **RHEL** — estándar empresarial (dev subscription gratis)
- [ ] **Oracle Linux** — RHEL-compatible, kernel UEK, btrfs

## SUSE y familia

- [ ] **openSUSE Tumbleweed** — rolling, estable, YaST
- [ ] **openSUSE Leap** — punto-fijo, híbrido con SLE
- [ ] **SLES** — enterprise, SAP, alto rendimiento
- [ ] **MicroOS** — inmutable, transactional-update, contenedores

## Arch y derivados

- [ ] **Arch Linux** — rolling, DIY, pacman, AUR, wiki absoluta
- [ ] **EndeavourOS** — Arch accesible, installer gráfico, bien pulido
- [ ] **Manjaro** — Arch estable, capas de testing, aptito para escritorio
- [ ] **Garuda Linux** — Arch gaming, btrfs + snapper, rendimiento
- [ ] **CachyOS** — Arch optimizado, scheduler BORE, Cachy repos
- [ ] **ArcoLinux** — Arch educativo, multi-escritorio, aprendé Arch

## Independientes (no derivan de ninguna grande)

- [ ] **Alpine Linux** — minimal (5 MB), musl + openrc, contenedores
- [ ] **Void Linux** — rolling, runit, xbps, sin systemd
- [ ] **Gentoo** — source-based, USE flags, Portage, máximo control
- [ ] **Slackware** — BSD-style init, sin dependencias automáticas, clásica
- [ ] **Solus** — independiente, eopkg, escritorio curado
- [ ] **Mageia** — fork de Mandriva, comunitaria, amigable
- [ ] **PCLinuxOS** — rolling, apt-get tradicional, para escritorio
- [ ] **Clear Linux** — Intel, optimizado rendimiento, stateless
- [ ] **Tiny Core Linux** — ~11 MB, minimal extremo, aprendizaje
- [ ] **Puppy Linux** — liviana, corre en RAM, rescate
- [ ] **antiX** — liviana, sin systemd, para hardware viejo
- [ ] **MX Linux** — antiX + Xfce, balance liviano-amigable

## Declarativas / Inmutables

- [ ] **NixOS** — declarativo, reproducible, nix language
- [ ] **GNU Guix** — declarativo, Scheme, GNU, sin systemd

## Seguridad / Pentesting

- [ ] **Kali Linux** — estándar de pentesting, rolling
- [ ] **Parrot Security OS** — pentesting + privacidad, más ligero
- [ ] **BlackArch** — Arch + 3000+ herramientas de seguridad
- [ ] **Pentoo** — Gentoo-based, hardened, pentesting

## Contenedores / Cloud / Inmutables

- [ ] **Flatcar Container Linux** — minimal, auto-actualizable, cloud
- [ ] **Talos Linux** — Kubernetes-native, API-driven, inmutable
- [ ] **Bottlerocket** — AWS, minimal, seguro, para contenedores
- [ ] **Photon OS** — VMware, minimal, para hypervisor y cloud

## NAS / Servidores de almacenamiento

- [ ] **TrueNAS SCALE** — ZFS, contenedores, KVM, web UI
- [ ] **OpenMediaVault** — Debian-based, NAS casero, plugins
- [ ] **XigmaNAS** — FreeBSD-based, ZFS, NAS clásico

## Educativas / Experimentales

- [ ] **Linux From Scratch** — construí Linux desde cero
- [ ] **CRUX** — minimal, BSD-style, ports system, precursora de Arch
- [ ] **Bedrock Linux** — mezclá distros en un solo sistema
- [ ] **Chimera Linux** — desde cero, FreeBSD userland + Linux kernel

## No son Linux, pero vale muchísimo aprenderlas

- [ ] **FreeBSD** — ZFS, jails, pf, ports, licenses BSD
- [ ] **OpenBSD** — seguridad absoluta, pf, auditado
- [ ] **NetBSD** — portabilidad extrema, run anywhere
- [ ] **DragonFly BSD** — Hammer2 FS, kernel ligero, clusters

---

**Leyenda**
- `[ ]` — pendiente de probar
- `[x]` — documentado en `docs/02-distros/`
