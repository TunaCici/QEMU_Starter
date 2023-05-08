# QEMU_Starter
Guides, tutorials and example scripts that aims to help new QEMU users.

# Terminology
@TODO: List some of the most common terminologies used when dealing with QEMU, emulators and virtual machines. Also add definitions >.<

# What is QEMU?
Quick EMUlator (QEMU) is a generic Free and Open-Source machine emulator and virtualizer[^1].
@TODO: Briefly talk about why it is neede, who uses it, how to use it and talk a bit about emulation and virtualization.

## Emulation
@TODO: Talk about emulation in general and then associate it with QEMU.

## Virtualization
@TODO: Talk about virtualization in general and how it is handled in QEMU.

### KVM, Hyperviser.framework and Hyper-V
@TODO: Talk about these hyperviseres. Intel VT-X and AMD-V should be mentioned as well.

## Operation Modes
@TODO: QEMU can be in different modes. Full-system-emulation, user-mode-emulation, virtualization, Xen. Talk about them briefly.

# Requirements
Each Architecture, OS or Distro has its own requirements.

## GNU/Linux - Debian (ARM64 | x86_64)
@TODO: General steps to follow on Debian.

```bash
$ sudo apt install qemu qemu-utils qemu-efi-aarch64 qemu-system-arm
```

## macOS 13.0 (Apple Silicon)
 ```bash
$ brew install qemu
```

# EFI Locations
@TODO: Move this section somewhere else.
Possible locations for EFI files on AARCH64 and x86_64 systems.

## GNU/Linux - Debian (ARM64 | x86_64)
```bash
$ file /usr/share/qemu-efi-aarch64/QEMU_EFI.fd
```

## macOS 13.0 (Ventura)
```bash
$ file /opt/homebrew/Cellar/qemu/*.*/share/qemu/edk2-aarch64-code.fd 
```

# Hello World
@TODO: Give a step-by-step tutorial on how to launch a QEMU machine with a generic Linux kernel image. (both ARM64 and x86_64)

Kernel Image
```bash
# http://ftp.debian.org/debian/dists/stable/main/installer-arm64/current/images/netboot/debian-installer/arm64/
```

Launch Command
```bash
$ qemu-system-aarch64 -machine virt -cpu cortex-a53 -kernel installer-linux -nographic
```

# Basic Configurations
@TODO: Talk about some common QEMU configurations. Give examples from the Hello World and the upcoming configurations.

## Machine
@TODO: Give information about the '-machine' argument.

## CPU
@TODO: Give information about the '-cpu' and '-smp' arguments. Maybe even talk about -numa and such(?)

## Memory
@TODO: Give information about the '-memory' argument.

## Devices[^2]
@TODO: Give information about the '-device' argument. There are tons of different devices (for ex. virtio). Find a way talk about all of them without boring the reader.

## Display
@TODO: Give information about the '-display', '-serial' and '-nographic' arguments.

## BIOS & UEFI
@TODO: Give information about the '-bios' argument. Also talk about the OVMF project.

## Accelerator
@TODO: Give information about the '-accel' argument. Talk about KVM, Hypervisor.framework and Hyperviser-V.

# Example 1: Ubuntu 22.04 ARM64
@TODO: Give an average configration that creates an example Ubuntu machine.

# Example 2: Arch Linux ARM64
@TODO: Give an average configration that creates an example machine that is able to boot ArchLinux.

# Example 3: Windows 11 ARM64
@TODO: Give an average configration that create an example Windows machine.

[^1]: https://www.qemu.org/docs/master/about/index.html
[^2]: https://blogs.oracle.com/linux/post/introduction-to-virtio
