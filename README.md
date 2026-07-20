# FromTermEcosystem

Todo nace desde la terminal.

Aprendizaje real sobre Linux, virtualización, automatización, redes y orquestación — documentado paso a paso, con errores, soluciones y diagramas.

No es un blog, no es un tutorial: es el registro vivo de construir un ecosistema desde cero, desde una terminal SSH.

## Catálogo de distros

| Distro | Tipo | Estado | Docs | Script |
|---|---|---|---|---|
| [Arch Linux](docs/02-distros/arch/) | Rolling | ✅ Probada | [manual-install](docs/02-distros/arch/manual-install.md) · [speedrun](docs/02-distros/arch/speedrun.md) | [`arch-speedrun.sh`](scripts/arch-speedrun.sh) |
| Debian Server | Stable | 🔜 Próxima | — | — |
| Ubuntu Server | Stable | 🔜 Próxima | — | — |
| Alpine Linux | Rolling/Ligera | 🔜 Próxima | — | — |
| Void Linux | Rolling | 🔜 Próxima | — | — |
| Gentoo | Source-based | 🔜 Próxima | — | — |
| NixOS | Inmutable | 🔜 Próxima | — | — |

## Estructura del repo

```
docs/
├── 01-setup/            # Virtualización por terminal (virt-install, virsh, redes)
├── 02-distros/          # Catálogo de distros probadas
│   ├── _template.md     # Plantilla para agregar nuevas distros
│   └── arch/            # Arch Linux
├── 03-*/                # (futuro) networking, automatización, troubleshooting
└── specs.md              # Especificaciones del servidor host

scripts/
├── arch-speedrun.sh      # Speedrun de Arch
└── lib/                  # Librerías compartidas
    ├── vm.sh             # Helpers para VMs (crear, destruir, consola)
    └── iso-utils.sh      # Montar ISO, extraer kernel, obtener label

notes/
├── speedrun-records.md   # Récords de speedruns
└── distro-checklist.md   # Check-list de distros por probar
```

## Cómo agregar una distro nueva

1. Elegir la distro de la lista o proponer una nueva
2. Copiar `docs/02-distros/_template.md` a `docs/02-distros/<nombre>/README.md`
3. Rellenar la plantilla con la instalación paso a paso
4. Documentar errores y soluciones encontrados
5. Opcional: crear script de automatización en `scripts/`
6. Actualizar la tabla de catálogo en este README

## Requisitos del host

- KVM/QEMU + libvirt habilitados
- `virt-install`, `virsh`, `osinfo-query`
- Espacio en disco para ISOs y discos virtuales
