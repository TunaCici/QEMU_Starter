#!/usr/bin/env bash

set -x

function print_msg() {
    local msg="$1"
    local symbol="$2"

    printf "[%s] " "$timestamp"
    
    if [ "$symbol" == "x" ]; then
        printf "[\e[32m%s\e[0m] %s\n" "OK" "$msg"
    elif [ "$symbol" == "*" ]; then
        printf "[\e[33m%s\e[0m] %s\n" "ACTION" "$msg"
    elif [ "$symbol" == "!" ]; then
        printf "[\e[31m%s\e[0m] %s\n" "ERROR" "$msg"
    else
        printf "[%s] %s\n" "$symbol" "$msg" 2> stderr
    fi
}

#
# Host Settings
#

QEMU_BIN=qemu-system-aarch64

ISO_PATH="../ISOs/ubuntu-22.04.1-live-server-arm64.iso"
DISK_PATH="./disk0.qcow2"

EFI_FLASH_PATH="../Firmwares/edk2-aarch64-code.fd"
EFI_VARS_PATH="../Firmwares/efi-vars.raw"

# END Host Settings

#
# Guest Settins
#

NAME="-name QEMU_Starter"
MACHINE="-machine virt"
ACCELERATOR="-accel hvf"

CPU="-cpu host"
SMP="-smp 2"

MEMORY="-m 4G"

EFI_FLASH="-drive if=pflash,format=raw,readonly=on,file=${EFI_FLASH_PATH}"
EFI_VARS="-drive if=pflash,format=raw,file=${EFI_VARS_PATH}"

DISK_0="-drive media=cdrom,file=${ISO_PATH}"
DISK_1="-drive id=hd0,format=qcow2,if=virtio,file=${DISK_PATH}"

# @TODO: Store them inside an array (?)
NETWORK_DEV_0="-device virtio-net-device,netdev=net0 -netdev user,id=net0"
NETWORK_DEV_1=""
NETWORK_DEV_2=""

# @TODO: Store them inside an array (?)
DEVICE_0="-device usb-ehci"
DEVICE_1="-device usb-kbd"
DEVICE_2="-device usb-mouse"
DEVICE_3="-device virtio-gpu"

EXTRA_0="-nographic"
EXTRA_1=""

# END Guest Settings

function check_qemu ()
{
  if [[ -x "$(command -v ${QEMU_BIN})" ]]; then
    print_msg "Found ${QEMU_BIN}" "x"
    ${QEMU_BIN} --version
  else
    print_msg "${QEMU_BIN} not found on the system! Make sure it is installed" "!"
    exit -1
  fi
}

check_qemu

# Launch the machine
${QEMU_BIN} ${NAME} ${MACHINE} ${ACCELERATOR} ${CPU} ${SMP} ${MEMORY} ${EFI_FLASH} ${EFI_VARS} ${DISK_0} ${DISK_1} ${NETWORK_DEV_0} ${DEVICE_0} ${DEVICE_1} ${DEVICE_2} ${DEVICE_3} ${EXTRA_0} ${EXTRA_1}

