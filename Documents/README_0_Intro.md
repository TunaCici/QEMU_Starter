# Terminology

There are some terminologies that you must familiarize yourself with. Here are the most important ones. Do note that these definitions are not 100% formal and only gives an abstract view.

```plain
Host: The OS/machine running the emulation/virtualization.
Guest: The virtualized/emulated machine that runs on the host operating system.
```

> The terms 'operating system' and 'machine' are sometimes used interchangeably. (e.g. 'Windows machine' == 'Windows The Operating System') This is done intentionally to simplify the phrases used in this pseudo-wiki.

# What is QEMU?

**Q**uick **EMU**lator (QEMU) is a generic Free and Open-Source machine emulator and virtualizer[^1]. It was first developed by the genius `Fabrice Bellard` and is now maintained by the contributors all over the world. [^2]

QEMU can fully emulate CPUs, Instruction Sets, I/O Devices and other common hardware devices. It supports virtualization with near-native performance using accelerators such as Linux's `KVM`, Apple's `Hypervisor.Framework` and Microsoft's `Hyper-V`. [^3]

With those features QEMU can be used for:

- **Software Dev**.: Run and test your software on different OSes and platforms.
- **OS & Driver Dev.**: Develop operating systems and/or drivers without the actual hardware. (x86_64, ARM64, PowerPC)
- **Virtual Machines**: Run multiple OSes with near-native performance.
- **Embedded Systems**: Emulate the target hardware and test your software without using the real hardware.
- **Legacy Softwares**: Run legacy or unsupported application. (Classic Macintosh, Windows 95)
- **Security Research**: Fiddle with malwares and explore vulnerabilities in an isolated environment.

## Who is QEMU For?

Basically: it Depends™. QEMU is an extremely versatile tool. It has a very steep learning curve. If you have the time, dedication and are looking for an emulator or a virtualizer then QEMU is exactly for you!

> Anyone who is looking for an adventure and want to learn more about software & hardware is welcome! QEMU is rather hard at first but in the end it will all be worth it and it will teach you a lot <3

## Who is QEMU Not For?

Anyone who is looking for a Quick™ and headache-free experience to create Virtual Machines and/or Emulated Systems.

> If you are looking for an easy-to-use virtual machine QEMU is not the place. There are other great tools out there in the wild (ex. VirtualBox[^4], VMWare[^5], Parallels[^6], UTM[^81]).

## Emulation

Emulation [in computers] is the method of imitating a software, hardware or a system (CPU, I/O, Network, ARM64, PlayStation etc.) An emulator, on the other hand, is the tool that handles the emulation (Ex. QEMU).

With QEMU we can achieve different kinds of emulations: [^7]

- **Architecture/CPU Emulation**: It can emulate different CPU architectures on different machines using `Tiny Code Generator (TCG)`. (Ex. ARM64 on x86_64) [^8]
- **User-Mode Emulation**: Allows running binaries compiled for different CPU architectures. (Ex. ELF-AARCH64 on GNU/Linux x86_64) [^9] [Further_Explanation_Needed]
- **Device Emulation**: Many of the popular real-world and virtual devices be emulated by QEMU. (Ex. USB, Network Cards, NVMe etc.) [^10]
- **Full-System Emulation**: The full emulation of a system including CPU, Memory, I/O and etc. (Ex. GNU/Linux, MS-DOS, PowerPC, Raspberry Pi) [^11]

## Virtualization

Virtualization [in computers] is the method of creating isolated versions of a software or a system (e.g. GNU/Linux, Windows) by virtualizing the host's hardware.

> This is different than emulation, because the software/system run directly on the host CPU rather than going thru a translation (e.g. `TCG`). Thus, less overhead and more performance.

> We can't directly compare emulation and virtualization, because they are two different methods for different purposes. For simplicity's sake you can think of `virtualization` as software/system centric and `emulation` as more machine/hardware centric.

There are two kinds of virtualizations:[^12] [^13]

- **Full Virtualization**: The software/system is fully isolated and virtualized (OS/Kernel, hardware and etc.). (Guest doesn't know it is being virtualized) [^14]
- **Paravirtualization**: The software/system is partially isolated (Only the applications are). (Guest does know that it is being virtualized) [^15]

> You can think of `Full Virtualization` as running Ubuntu like in a normal computer and `Paravirtualization` as running Docker containers.

The virtualization happens using the help of `Hypervisors`. Since the software/system is isolated it requires a layer to interact with the real hardware. This layer is provided by the `Hypervisors`. They provide the guest a virtualized hardware platform to run on. [^16]

> Virtualization wouldn't be possible without an `Hypervisor`. [^17]

Each host OS provides their own `Hypervisor` layers:

- **KVM**: Provided by the GNU/Linux as a kernel module. [^18]
- **Hypervisor.Framework**: Provided by Apple for the macOS. [^19]
- **Hyper-V**: Provided by Microsoft for Windows systems. [^20]

QEMU supports `Full Virtualization` on almost every platform via the `Hypervisors` specified above. This allows it to be used as a virtual machine.

> Shameless Plug: [Additional [ELI5] Info on Emulation/Virtualization](https://medium.com/@tunacici7/virtualization-vs-emulation-4ab2afdb1b90)

**Next Part** [1. Hardware Acceleration, Requirements & Installation](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md)

[^1]: https://www.qemu.org/docs/master/about/index.html
[^2]: https://en.wikipedia.org/wiki/Fabrice_Bellard
[^3]: https://en.wikipedia.org/wiki/QEMU#Accelerator
[^4]: https://www.virtualbox.org
[^5]: https://www.vmware.com/products/workstation-player.html
[^6]: https://www.parallels.com
[^7]: https://en.wikipedia.org/wiki/QEMU#Operating_modes
[^8]: https://wiki.qemu.org/Documentation/TCG
[^9]: https://qemu.readthedocs.io/en/latest/user/main.html
[^10]: https://qemu.readthedocs.io/en/latest/system/device-emulation.html
[^11]: https://qemu.readthedocs.io/en/latest/system/index.html#
[^12]: https://en.wikipedia.org/wiki/Virtualization#Hardware_virtualization
[^13]: https://www.youtube.com/watch?v=fgrV-mu6JQw
[^14]: https://en.wikipedia.org/wiki/Full_virtualization
[^15]: https://en.wikipedia.org/wiki/Paravirtualization
[^16]: https://en.wikipedia.org/wiki/Hypervisor
[^17]: https://ubuntu.com/blog/containerization-vs-virtualization
[^18]: https://www.linux-kvm.org/page/Main_Page
[^19]: https://developer.apple.com/documentation/hypervisor
[^20]: https://en.wikipedia.org/wiki/Hyper-V
[^81]: https://mac.getutm.app
