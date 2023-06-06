#!/usr/bin/env bash

#
# Host
#

QEMU_BIN=qemu-system-aarch64

if [[ -x "$(command -v ${QEMU_BIN})" ]]; then
    echo "[x] Found ${QEMU_BIN}"
    ${QEMU_BIN} --version
else
    echo "[!] ${QEMU_BIN} not found on the system! Make sure it is installed"
    exit -1
fi

# END Host

#
# Guest
#

# 0. Meta
NAME="-name QEMU_Starter_ArchLinux"

# 1. Machine selection
MACHINE="-machine virt"

# 2. CPU override
CPU="-cpu host"
SMP="-smp 2"
ACCELERATOR="-accel hvf"

# 3. Memory override
MEMORY="-m 4G"

# 4. BIOS/UEFI settings
EFI_FLASH_PATH="../Firmwares/edk2-aarch64-code.fd"
EFI_VARS_PATH="../Firmwares/efi-vars.raw"

EFI_FLASH_DRV="-drive if=pflash,format=raw,readonly=on,file=${EFI_FLASH_PATH}"
EFI_VARS_DRV="-drive if=pflash,format=raw,file=${EFI_VARS_PATH}"

# 5. Device selection
# 5.1. Input
INPUT_DEV="-device usb-ehci -device usb-kbd -device usb-mouse"

# 5.2. Network
NETWORK_DEV="-device virtio-net-device,netdev=net0 -netdev user,id=net0"

# 5.3 Storage
STORAGE_DEV="-device nvme,drive=hd0,serial=super-fast-boi"

# 5.4. Display
DISPLAY_DEV="-device virtio-gpu,xres=1280,yres=720"

# 5.5. Sound
SOUND_DEV="-device intel-hda"

# 5.6. Misc
MISC_DEV=""

# 6. Drive settings (a.k.a disk images)
ISO_PATH="../ISOs/archboot-2023.05.03-15.04-aarch64.iso"
DISK_PATH="./example.qcow2"

CD_DRV="-drive id=cd0,media=cdrom,file=${ISO_PATH}"
MAIN_DRV="-drive id=hd0,if=none,format=qcow2,file=${DISK_PATH}"

# END Guest

# Launch the machine
set -x

${QEMU_BIN} ${NAME} ${MACHINE} ${CPU} ${SMP} ${ACCELERATOR} ${MEMORY} \
    ${EFI_FLASH_DRV} ${EFI_VARS_DRV} ${INPUT_DEV} ${NETWORK_DEV} ${STORAGE_DEV} ${DISPLAY_DEV} ${SOUND_DEV} ${MISC_DEV} \
    ${CD_DRV} ${MAIN_DRV} $*
