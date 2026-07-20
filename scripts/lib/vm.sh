# shellcheck shell=bash
# ==========================================================
# VM Helpers — FromTermEcosystem
# ==========================================================
# Uso: source scripts/lib/vm.sh
# ==========================================================

VM_DIR="${VM_DIR:-$HOME/FromTermEcosystem/scripts}"

vm_create() {
    local name="$1"
    local ram="${2:-2048}"
    local vcpus="${3:-1}"
    local disk_size="${4:-10}"
    local os_variant="${5:-generic}"
    local disk_path="$VM_DIR/${name}.qcow2"
    local iso_path="$VM_DIR/${name}.iso"

    if [ ! -f "$iso_path" ]; then
        echo "ISO no encontrado: $iso_path"
        return 1
    fi

    virt-install \
        --name "$name" \
        --ram "$ram" \
        --vcpus "$vcpus" \
        --disk path="$disk_path",size="$disk_size",bus=sata \
        --cdrom "$iso_path" \
        --os-variant "$os_variant" \
        --network network=default \
        --graphics none \
        --console pty,target_type=serial
}

vm_destroy() {
    local name="$1"
    virsh destroy "$name" 2>/dev/null || true
    virsh undefine --nvram "$name" 2>/dev/null || true
}

vm_console() {
    local name="$1"
    virsh console "$name"
}

vm_list() {
    virsh list --all
}

vm_start() {
    virsh start "$1"
}

vm_shutdown() {
    virsh shutdown "$1"
}

vm_ip() {
    local name="$1"
    virsh domifaddr "$name" 2>/dev/null | grep ipv4 | awk '{print $4}' | cut -d/ -f1
}
