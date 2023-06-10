**Previous Section** [4. Devices, VirtIO and more](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_4_Devices.md)

# BIOS & UEFI

**B**asic **I**nput/**O**utput **S**ystem (BIOS) and **U**nifed **E**xtensiable **F**irmware **I**nterface (UEFI) are essential components that provide the necessary initialization process for machines.[^76][^77] They are basically the 'first' program that loads when a machine powers up.

These 'programs' are generally stored on a machine's Read-only Memory (ROM). Their main function is to initialize and configure hardware components, perform a Power-On Self-Test (POST), and provide the necessary interfaces for booting the operating system.[^78]. They, in turn, give controls to other programs (a.k.a `bootloaders`) like GRUB2, SysLinux, MS-DOS.

> BIOS and UEFI are two different firmware that tries to solve the same problems.

QEMU, _by default_, uses a BIOS called [SeaBios](https://en.wikipedia.org/wiki/SeaBIOS). It is a pretty good option and most can be used with most bootloaders.[^79] And naturally, every guest machine is loaded with the `SeaBios` and you don't have to do anything. However, you might want, _or need_, to use UEFI instead.

> UEFI is the modern replacement of BIOS. And naturally, we want to use UEFI whenever possible;)

## OVMF

**O**pen **V**irtual **M**achine **F**irmware, `OVMF`, is an EDK II based project to enable UEFI support for Virtual Machines. `OVMF` contains sample UEFI firmware for QEMU and KVM. [^80]. It is an amazing project with amazing people behind it! I won't talk about it here for obvious reasons. If you want to learn more visit their GitHub repository [OVMF - FAQ](https://github.com/tianocore/tianocore.github.io/wiki/OVMF-FAQ)

Starting from QEMU version 1.6, _which was release on December 3 2013_, the `OVMF` project comes pre-installed with many QEMU installations (e.g. Windows). However, package managers like `pacman` does NOT include it! So, you have to manually install `OVMF` firmwares.

> By time time I'm writing this, your package manager might be updated to also include OVMF packages.

To install the `OVMF` UEFI firmwares (_if you don't have it already_):

**GNU/Linux**

```bash
# For 'apt' based distros (e.g. Debian, Ubuntu)
$ apt install qemu-efi-aarch64

# For 'pacman' or 'yay' based distros (e.g. ArchLinux)
$ pacman -S edk2-ovmf
```

**Windows 10/11**

Comes pre-installed with the `MSI Installer`.

**macOS 13.0 (Ventura)**

Comes pre-installed with `Homebrew`.

Each CPU architecture (e.g. aarch64, x86_64) has different `OVMF` firmware. You can see which ones are installed on your system by checking their file locations. Their locations can be found under this repositorie's `/Firmwares` folder. Access it here [Firmwares](https://github.com/TunaCici/QEMU_Starter/tree/main/Firmwares)

## UEFI on QEMU

To enable UEFI on a QEMU machine we have to provide two things: `UEFI firmware` and `UEFI variables`. In this section I will explain how to do that, but you should know that most of the stuff here is taken from Joonas's article on [UEFI, PC boot process and UEFI with QEMU](https://joonas.fi/2021/02/uefi-pc-boot-process-and-uefi-with-qemu/) and [Arch Linux Wiki](https://wiki.archlinux.org/title/QEMU#Booting_in_UEFI_mode).

> I highly encourage you to read Joonas's writing. It is totally amazing and will give you a much better context on what we are doing here.

**Step 1 - Providing the UEFI firmware itself**

This is as easy as adding a `-drive` to your guest machine. The important thing here is the `-drive` is of type `pflash` and is read-only.

```bash
$ qemu-system-aarch64 ... -drive if=pflash,format=raw,readonly=on,file=${EFI_FLASH_PATH} ...

# The EFI_FLAS_PATH can be obtained from the previous section
```

**Step 2 - Providing the UEFI variables**

The UEFI firmware itself is readonly. We can do some configurations on it like the `Boot Order`, `Secure Boot` and `Hardware Configurations`. UEFI needs to save them _somewhere_ so that they can be accessed after a power reset. This _somewhere_ is basically a `-drive` called UEFI variables.

The UEFI variables is nothing special. It is a basic image with a _very-specific_ size of 64MiB. So, we need to create a raw image!

Create a raw image with size 64MiB (_Windows users can skip this_):

```bash
$ dd if=/dev/zero of=efi-vars.raw bs=1M count=64
```

Windows users can just retrieve it from the QEMU installation directory:

```powershell
$ ls 'C:\Progam Files\qemu\share\edk2-arm-vars.fd'

# Replace 'arm' with 'i386' if your guest machine is x86_64
```

Now, provide the UEFI variables image:

```bash
$ qemu-system-aarch64 ... -drive if=pflash,format=raw,file=${EFI_VARS_PATH} ...

# The EFI_VARS_PATH is the path of the image we've just crated
```

**Step 3 - Enjoy the UEFI (Optional) 💚**

Your guest machine should now boot with the UEFI firmware. To test it, just launch your machine and check if **TianaCore** appears on the boot screen.

**Next Section** [6. Networking](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_6_Networking.md)

[^76]: https://en.wikipedia.org/wiki/BIOS
[^77]: https://en.wikipedia.org/wiki/UEFI
[^78]: https://en.wikipedia.org/wiki/Power-on_self-test
[^79]: https://en.wikipedia.org/wiki/SeaBIOS#Development
[^80]: https://github.com/tianocore/tianocore.github.io/wiki/OVMF
