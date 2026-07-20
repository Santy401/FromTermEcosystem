# Arch Speedrun

Instalación contrarreloj de Arch Linux usando `arch-speedrun.sh`.

## Uso

```bash
./scripts/arch-speedrun.sh
```

## Requisitos

- ISO de Arch descargado en `scripts/`
- Kernel e initrd extraídos en `tmp/`
- Label del ISO actualizado en el script

## Récords

Ver [speedrun-records.md](../../notes/speedrun-records.md)

## Tips para mejorar tiempo

- Particionado fijo (sin swap si hay RAM suficiente)
- Tipear comandos de memoria, no mirar la wiki
- Usar `pacstrap -K` en paralelo mientras se configura el fstab
- Script post-instalación preescrito para copiar al chroot
