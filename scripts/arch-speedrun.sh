#!/bin/bash

# ==========================================================
# Arch Speedrun — Timer + Auto VM + Screen
# ==========================================================
# Lanza una VM para instalar Arch contrarreloj.
# Cuando haces reboot dentro de la VM, el cronómetro se
# detiene y muestra tu tiempo total.
#
# Uso:
#   ./scripts/arch-speedrun.sh
#
# Una vez dentro:
#   1. Particionas, formateas, montas
#   2. pacstrap -K /mnt base linux linux-firmware
#   3. genfstab, arch-chroot, config, grub, servicios
#   4. reboot  ← al hacer esto, el screen se cierra y ves tu tiempo
# ==========================================================

VM_NAME="arch-speedrun"
DISK_PATH="$HOME/FromTermEcosystem/scripts/${VM_NAME}.qcow2"
ISO_PATH="$HOME/FromTermEcosystem/scripts/archlinux-2026.06.01-x86_64.iso"
KERNEL="$HOME/FromTermEcosystem/tmp/vmlinuz-linux"
INITRD="$HOME/FromTermEcosystem/tmp/initramfs-linux.img"
RAM="2048"
VCPUS="1"
DISK_SIZE="10"

echo "==> Limpiando screen sessions anteriores..."
screen -ls 2>/dev/null | grep "$VM_NAME" | cut -d. -f1 | tr -d '\t' | xargs -r -I{} screen -S {} -X quit 2>/dev/null || true

echo "==> Eliminando VM anterior si existe..."
virsh destroy "$VM_NAME" 2>/dev/null || true
virsh undefine --nvram "$VM_NAME" 2>/dev/null || true

echo "==> Eliminando disco anterior..."
rm -f "$DISK_PATH"

echo "==> Creando nueva VM: $VM_NAME"
virt-install \
  --name "$VM_NAME" \
  --ram "$RAM" \
  --vcpus "$VCPUS" \
  --disk path="$DISK_PATH",size="$DISK_SIZE",bus=sata \
  --disk path="$ISO_PATH",device=cdrom,bus=sata \
  --os-variant archlinux \
  --network network=default \
  --graphics none \
  --import \
  --boot kernel="$KERNEL",initrd="$INITRD",kernel_args="console=ttyS0 archisolabel=ARCH_202606" \
  --console pty,target_type=serial &>/dev/null &

# Esperar a que la VM exista
echo "==> Esperando VM..."
for i in $(seq 1 10); do
  virsh domstate "$VM_NAME" 2>/dev/null | grep -q running && break
  sleep 1
done

echo "=============================="
echo "  Speedrun iniciado"
echo "  Cuando hagas 'reboot' en la VM,"
echo "  el screen se cierra y ves tu tiempo."
echo "  Ctrl+A, D -> salir sin cerrar"
echo "=============================="

START_TIME=$(date +%s)

# Lanzar virsh console y un monitor de estado en el screen
screen -S "arch-speedrun" -dm bash -c "
  echo '⏱️  CRONÓMETRO CORRIENDO — Al terminar, ejecuta:  poweroff'
  echo ''

  # Monitor: esperar a que la VM se apague (poweroff)
  (
    while true; do
      STATE=\$(virsh domstate $VM_NAME 2>/dev/null)
      if [ \"\$STATE\" != \"running\" ]; then
        END_TIME=\$(date +%s)
        ELAPSED=\$((END_TIME - $START_TIME))
        MINS=\$((ELAPSED / 60))
        SECS=\$((ELAPSED % 60))
        echo ''
        echo '=============================='
        echo '  🏁  SPEEDRUN COMPLETADO  🏁'
        printf '  TIEMPO TOTAL: %d min %d seg\n' \$MINS \$SECS
        echo '=============================='
        echo ''
        printf '%s | %s | %d min %d seg\n' \"\$(date '+%Y-%m-%d %H:%M')\" \"\$VM_NAME\" \$MINS \$SECS >> ~/FromTermEcosystem/notes/speedrun-records.md 2>/dev/null
        echo '  Récord guardado en notes/speedrun-records.md'
        break
      fi
      sleep 2
    done
  ) &

  virsh console $VM_NAME
  echo ''
  echo 'Conexión terminada.'
  exec bash
"

sleep 1
screen -Dr "arch-speedrun"
