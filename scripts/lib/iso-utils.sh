# shellcheck shell=bash
# ==========================================================
# ISO Utilities — FromTermEcosystem
# ==========================================================
# Uso: source scripts/lib/iso-utils.sh
# ==========================================================

ISO_DIR="${ISO_DIR:-$HOME/FromTermEcosystem/scripts}"
TMP_DIR="${TMP_DIR:-$HOME/FromTermEcosystem/tmp}"

iso_mount() {
    local iso="$ISO_DIR/$1"
    local mnt="${2:-/mnt/iso}"

    if [ ! -f "$iso" ]; then
        echo "ISO no encontrado: $iso"
        return 1
    fi

    sudo mkdir -p "$mnt"
    sudo mount -o loop "$iso" "$mnt"
    echo "Montado en $mnt"
}

iso_umount() {
    local mnt="${1:-/mnt/iso}"
    sudo umount "$mnt"
    echo "Desmontado $mnt"
}

iso_label() {
    local iso="$ISO_DIR/$1"
    if [ ! -f "$iso" ]; then
        echo "ISO no encontrado: $iso"
        return 1
    fi
    blkid "$iso" | grep -o 'LABEL="[^"]*"' | cut -d'"' -f2
}

iso_extract_kernel() {
    local iso_name="$1"
    local iso="$ISO_DIR/$iso_name"
    local mnt="/mnt/iso-$$"

    if [ ! -f "$iso" ]; then
        echo "ISO no encontrado: $iso"
        return 1
    fi

    mkdir -p "$TMP_DIR" "$mnt"
    sudo mount -o loop "$iso" "$mnt"

    # Buscar vmlinuz e initramfs (estructura Arch)
    local vmlinuz_src
    local initrd_src
    vmlinuz_src=$(find "$mnt" -name 'vmlinuz-linux' -type f 2>/dev/null | head -1)
    initrd_src=$(find "$mnt" -name 'initramfs-linux.img' -type f 2>/dev/null | head -1)

    if [ -n "$vmlinuz_src" ] && [ -n "$initrd_src" ]; then
        cp "$vmlinuz_src" "$TMP_DIR/vmlinuz-linux"
        cp "$initrd_src" "$TMP_DIR/initramfs-linux.img"
        echo "Kernel extraído a $TMP_DIR/"
    else
        echo "No se encontró vmlinuz/initramfs en el ISO"
    fi

    sudo umount "$mnt"
    rmdir "$mnt"
}
