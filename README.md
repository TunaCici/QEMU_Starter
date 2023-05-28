# Motivation

This guide welcomes all adventurers seeking knowledge and excitement in the world of QEMU! While it may seem challenging at first, the journey will be worth it [and fun], teaching you valuable lessons along the way <3

# Quick Access

@TODO: This is too long.. :( What should I do?

- [Motivation](#motivation)
- [Quick Access](#quick-access)
- [Terminology](#terminology)
- [What is QEMU?](#what-is-qemu)
  - [Who is QEMU For?](#who-is-qemu-for)
  - [Who is QEMU Not For?](#who-is-qemu-not-for)
  - [Emulation](#emulation)
  - [Virtualization](#virtualization)
- [Requirements](#requirements)
  - [Main Packages](#main-packages)
  - [Hardware Acceleration (Optional)](#hardware-acceleration-optional)
- [Installation](#installation)
  - [GNU/Linux](#gnulinux)
  - [Windows 10/11](#windows-1011)
  - [macOS 11+ (Big Sur)](#macos-11-big-sur)
- [Hello World](#hello-world)
- [Tools](#tools)
  - [qemu-img](#qemu-img)
  - [qemu-system-x86_64](#qemu-system-x86_64)
- [Configurations](#configurations)
  - [Machine](#machine)
  - [CPU](#cpu)
  - [Memory](#memory)
  - [Disks](#disks)
  - [Devices](#devices41)
  - [Display](#display)
  - [BIOS \& UEFI](#bios--uefi)
  - [Accelerator](#accelerator)
- [Example VM-1: Ubuntu 22.04](#example-vm-1-ubuntu-2204)
- [Example VM-2: ArchLinux](#example-vm-2-archlinux)
- [Example VM-3: Windows 11](#example-vm-3-windows-11)

# Terminology

There are many terminologies used in the guide. Here are some of the most important ones. Do note that these definitions are not 100% formal and only gives an abstract view.

```plain
Machine: The real-world hardware that the host runs on.
Host: The OS/machine running the emulation/virtualization. (Ex. MacOS/MacBook)
Guest: The virtualized/emulated software that runs on the host operating system. (Ex. Windows XP)
```

# What is QEMU?

Quick EMUlator (QEMU) is a generic Free and Open-Source machine emulator and virtualizer[^1]. It was first developed by the genius `Fabrice Bellard` and is now maintained by the contributers all over the world. [^2]

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

Anyone who is looking for a Quick™ and headache-free experince to create Virtual Machines and/or Emulated Systems.

> If you are looking for an easy-to-use virtual machine QEMU is not the place. There are other great tools out there in the wild (ex. VirtualBox[^4], VMWare[^5], Parallels[^6]).

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

There are two kinds of virtualizations: [^12] [^13]

- **Full Virtualization**: The software/system is fully isolated and virtualized (OS/Kernel, hardware and etc.). (Guest doesn't know it is being virtualized) [^14]
- **Paravirtualization**: The software/system is partially isolated (Only the applications are). (Guest does know that it is being virtualized) [^15]

> You can think of `Full Virtualization` as running Ubuntu like in a normal computer and `Paravirtualization` as running Docker containers.

The virtualization happens using the help of `Hypervisors`. Since the software/system is isolated it requires a layer to interact with the real hardware. This layer is provided by the `Hypervisors`. They provide the guest a virtualized hardware platfrom to run on. [^16]

> Virtualization wouldn't be possible without an `Hypervisor`. [^17]

Each host OS provides their own `Hypervisor` layers:

- **KVM**: Provided by the GNU/Linux as a kernel module. [^18]
- **Hypervisor.Framework**: Provided by Apple for the macOS. [^19]
- **Hyper-V**: Provided by Microsoft for Windows systems. [^20]

QEMU supports `Full Virtualization` on almost every platform via the `Hypervisors` specifed above. This allows it to be used as a virtual machine.

> Shameless Plug: [Additional [ELI5] Info on Emulation/Virtualization](https://medium.com/@tunacici7/virtualization-vs-emulation-4ab2afdb1b90)

# Requirements

Since QEMU is Free and Open Source, the source code can be cloned and built on any machine and platform. You can `manually` choose to do that. But since that is more advanced [and not suitable for beginner] we won't do it. Instead, we'll focus on pre-built `binary` packages.

> The complete guide on how to build from source can be found on QEMU's Wiki page.
> [^21] [^22] [^23]

The most commonly used platforms (`GNU/Linux`, `Windows` and `macOS`) have pre-built binary packages that we can use to `automatically` install QEMU.

## Main Packages

There are many binaries that QEMU provides for us. Only the most used/popular will be explained in this guide. More of them can be added in the future, and you are free to contribute;)

Here is the list of common QEMU binaries/packages [^24]:

- **qemu-img** [^25]: The CLI for creating, modifying, and converting disk images.
- **qemu-system-x86_64** [^26]: Full system emulator for the x86_64 architecture.
- **qemu-system-aarch64** [^27]: Full system emulator for the aarch64 architecture.
- **qemu-x86_64** [^28]: User-mode emulator for the x86_64 architecture.
- **qemu-arm** [^28:]: User-mode emulator for the ARM architecture.
- **qemu-nbd** [^30]: Network block device driver for QEMU.
- **qemu-kvm** [^31]: Linux hypervisor that allows QEMU to run virtual machines with full hardware acceleration.
- **qemu-storage-daemon** [^32]: Daemon/service that provides storage services to QEMU guests.
- **qemu-trace-stap** [^33]: The CLI tool that can be used to trace QEMU execution (for devs.).

> The availability of the binaries/packages listed above can vary from platform to platform but they generally don't effect how QEMU is installed and used >.<

## Hardware Acceleration (Optional)

By default, QEMU emulates everything and that includes the CPU. Emulating a CPU is extremely hard and brings lots of overheads ([tho it's a fascinating thing!](http://www.emulator101.com/a-quick-introduction-to-a-cpu.html)). The emulated machine is, naturally, slow and becames unpractical to use.

> Hardware acceleration is not necessary to use QEMU. Though it is **highly recommended!** as it speeds up the machine by a factor of 10x or more..

Luckily, QEMU supports hardware acceleration using `Hypervisor`s. The host operating system is the one responsible for providing a `Hypervisor`. Also, recall that, each platform had different `Hypervisor`s. And depending on your platform, they should be _'installed/enabled'_ before QEMU can use them.

> There is also the `Xen` hypervisor and it's amazing! But it's out of this guide's scope :(

`Hypervisor`s makes use of, naturally, the underlying hardware's capabilities. Your CPU **must** support '_hardware-accelerated virtualization_'! Without it, the `Hypervisor` wouldn't work. Each CPU manufacturer has their own way of implementing '_hardware-accelerated virtualization_'.

Intel calls their `Intel VT-x` [^34], AMD calls `AMD-V` [^35] and Apple calls `not-specified` [^19]. It is your responsible to find out if your CPU supports it and then enable it! But here's some starting points:

> **In GNU/Linux**: Use the `lscpu` command [^36] [^37] \
> **In Windows 10/11**: Launch `Task Manager` and check out the CPU section. [^38] \
> **In macOS (Apple Silicon | Intel)**: Enabled by default! 💚

### GNU/Linux (KVM)

**K**ernel-based **V**irtual **M**achine (KVM) is the `Hypervisor` used in GNU/Linux platforms. [^18] Your Linux kernel needs to be built with KVM module. Most distros include KVM, so you probably need not to worry about it.

Run the below command to **check** if KVM module is installed:

```bash
$ lsmod | grep kvm

# Output should look like this
> kvm_intel         458752  0
> kvm              1327104  1 kvm_intel
> irqbypass          16384  1 kvm
```

Alternatively, use `cpu-checker`'s command `kvm-ok`:

```bash
$ sudo kvm-ok

# Output should look like this
> INFO: /dev/kvm exists
> KVM acceleration can be used
```

💚 If the above commands **worked** then congrats your Linux kernel has KVM installed! 💚 \
🔴 If you ran into any **problems**, check out [ArchLinux Wiki KVM](https://wiki.archlinux.org/title/KVM). You probably need to switch to another kernel built with KVM. 🔴

### Windows 10/11 (Hypervisor-V)

**V**iridian, Hypervisor-V, is the `Hypervisor` used in Windows 10/11 platforms. [^20]. By default, it is probably disabled on your system. Follow the steps below to **install/enable** it.

**Step 1** \
Select `Start`, enter `Windows features`, and select `Turn Windows features on or off` from the list of results. \
**Step 2** \
In the `Windows Features` window that just opened, find `Virtual Machine Platform` and select it. \
**Step 3** \
Select **OK**. You might need to **restart** your PC. \
**Step 4** \
Launch `Task Manager`, switch to `Performance` tab and check the value of `Virtualization`.

💚 If the `Virtualization` is **Enabled** then congrats your Windows 10/11 is ready! 💚 \
🔴 If it is **Disabled** or not showing up, try Google.. Sorry :( 🔴

> The above steps are taken directly from Microsoft's offical guide. [^38]

# Installation

The following sections gives a step-by-step tutorial on how to install QEMU and it's utilities. Note that you need an active internet connection to download some packages.

## GNU/Linux

Each distro uses different package managers. In the following sections only the most 'popular' distros are given. However, they are all very similiar and you should be able to adapt them to your own distro/package-manager.

> Tested on ArchLinux (19 May 2023), Ubuntu 22.04 LTS, Windows 11 22H2 and macOS 13.3.

### ArchLinux (pacman)

The below commands should be run as the `root` user. Proceed with cauiton!

**Step 1 - Update your sources**

```bash
$ pacman -Syy

# Output will look like this
> :: Synchronizing package databases...
> core          154.3 KiB   304 KiB/s 00:01 [###########] 100%
> extra        1766.3 KiB  6.23 MiB/s 00:00 [###########] 100%
> community       7.4 MiB  9.62 MiB/s 00:01 [###########] 100%
```

**Step 2 - Install the `qemu-full` package** \
This will install everything QEMU has to offer. EFI, GUI, user-mode emulation and etc.

```bash
$ pacman -S qemu-full

# Output will look similiar to this
> resolving dependecies...
> looking for conflicting packages..

> Packages (41) edk2-aarch64-202302-1 ....
>               ...
>               qemu-full-8.0.0-1
>
> Total Download Size:      105.25 MiB
> Total INstalled Size:     785.45 MiB
>
> :: Proceed with installation? [Y/n] y
```

**Step 3 - Proceed with `y` and wait for `pacman` to finish**

```bash
# Grab some coffee or an energy drink in the mean time >.<
```

**Step 4 - Check if `qemu-full` is installed**

```bash
$ qemu-img --version

# Output will look like this
> qemu-img version 8.0.0
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

$ qemu-system-x86_64 --version

# Output will look like this
> QEMU emulator version 8.0.0
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

$ qemu-aarch64 --version

# Output will look like this
> qemu-aarch64 version 8.0.0
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

💚 If the above commands **worked** then congrats, you successfuly installed QEMU! 💚 \
🔴 If you ran into any **problems** feel free to contact me or create an issue. 🔴

### Ubuntu/Debian (apt)

The below commands should be run as either as `root` user or using `sudo`. Proceed with caution!

**Step 1 - Update the repositories**

```bash
$ apt update

# Output will look like this
> Get:1 http://us.archive.ubuntu,com/ubuntu...
> ...
> Get:15 http://us.archive.ubuntu.com/ubuntu...
> Fetched 3.300 kB in 3s (1.297 kb/s)
> Reading package lists... Done
> ...
> All packages are up to date.
```

**Step 2 - Install the `qemu-system`, `qemu-user` and `qemu-utils` packages**

```bash
$ apt install qemu-system qemu-user qemu-utils

# Output will look similiar to this
> ...
> The folowing NEW packages will be installed:
>   ibverbs-providers ipxe-qemu ...
>   ...
>   qemu-system-x86 qemu-user qemu-utils seabios
> 0 upgraded 44 newly installed, ...
> Need to get 122 MB of archives.
> After this operation 880 MB of additional disk space will be used.
> Do you want to continue [Y/n] y
```

**Step 3 - Proceed with `y` and wait for `apt` to finish**

```bash
# Grab some coffee or an energy drink in the mean time >.<
```

**Step 4 - Check if `qemu-system`, `qemu-user` and `qemu-utils` is installed**

```bash
$ qemu-img --version

# Output will look like this
> qemu-img version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.8)
> Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers

$ qemu-system-x86_64 --version

# Output will look like this
> QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.8)
> Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers

$ qemu-aarch64 --version

# Output will look like this
> qemu-aarch64 version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.8)
> Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
```

💚 If the above commands **worked** then congrats, you successfuly installed QEMU! 💚 \
🔴 If you ran into any **problems** feel free to contact me or create an issue. 🔴

## Windows 10/11

There are fundemantally two ways to 'natively' install QEMU on Windows platforms: `MSYS2` or `Installers`. We will use the latter one, as it's easier and more straightforward.

> The `binaries/installers` are provided by Stefen Weil [^39]

**Step 1 - Download the `Installer` from QEMU's File Servers** \
For Windows 32-Bit: https://qemu.weilnetz.de/w32 \
For Windows 64-Bit: https://qemu.weilnetz.de/w64 \
Alternatively (Both): https://www.qemu.org/download/#windows

> The file we are looking for looks like this: `qemu-w64-setup-20230424.exe`

**Step 2 - Follow The Setup Wizard**

Simply follow the instructions on the `Installer`. Make sure to select **ALL** components when installing.

Also, **DO NOT FORGET** the install location! We will use it on the next step.

```bash
# Your selected components should look like this
> [X] QEMU
> [X] Tools
> [X] System emulation
> [X] Desktop icons
> [X] DLL Library
> [X] Documentation
> [X] Program Group
```

**Step 3 - Add QEMU to Environment `PATH` Variable**

Right now QEMU is installed. However, we need to it to the `PATH` variable. So that we can access `qemu-system`, `qemu-img` and other QEMU related binaries.

- Select **Start**, enter `Environment`, and select `Edit the system environment variables` from the list of results.

- In the `System Properties` window that just opened, find `Environment Variables` and select it.

- In the `Environment Variables` window that just opened, find `Path` under the `System variables` tab and select it.

- In the `Edit environment variable` window that just opened, select `New` and enter the QEMU's installation path.

- After all that select `OK`, and `OK` again to **save & exit**.

> By default, the QEMU installation path is `C:\Program Files\qemu`.

**Step 4 - Check if `QEMU` is installed**

Now, launch a `Terminal` window and test if QEMU is installed and `PATH` variable is correctly set-up.

```powershell
$ qemu-img.exe --version

# Output will look like this
> qemu-img version 8.0.0 (v8.0.0-12024-gd6b71850be-dirty)
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

$ qemu-system-x86_64.exe --version

# Output will look like this
> QEMU emulator version 8.0.0 (v8.0.0-12024-gd6b71850be-dirty)
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

> Unfortunately, QEMU does not support user-mode emulation on Windows 10/11 yet.[^40]

> You might get an error like _'qemu-img' is not recognized as an internal or extarnel command,..._ Make sure that your `PATH` variable is set-up correctly.

💚 If the above commands **worked** then congrats, you successfuly installed QEMU! 💚 \
🔴 If you ran into any **problems** feel free to contact me or create an issue. 🔴

## macOS 11+ (Big Sur)

The most common way to install QEMU on macOS is via `brew`. The installation process is rather straightforward. Just follow the below steps.

**Step 1 - Install `brew` if you don't already have it. Otherwise skip!** \

Follow the instructions here: https://brew.sh

**Step 2 - Install `qemu` using `brew`**

```zsh
$ brew install qemu

# Output will look like this
> ...
> ==> Fetching qemu
> ==> Downloading https://ghcr.io/v2/homebrew/core/qemu/manifests/8.0.0
> ...
> ==> Installing qemu
> ==> Pouring qemu--8.0.0.arm64_ventura.bottle.tar.gz
> 🍺  /opt/homebrew/Cellar/qemu/8.0.0: 162 files, 527.4MB
> ...
```

**Step 3 - Check if `qemu` is installed**

```zsh
$ qemu-img --version

# Output will look like this
> qemu-img version 8.0.0
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

$ qemu-system-aarch64 --version

# Output will look like this
> QEMU emulator version 8.0.0
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

> Unfortunately, QEMU does not support user-mode emulation on macOS yet.[^40]

💚 If the above commands **worked** then congrats, you successfuly installed QEMU! 💚 \
🔴 If you ran into any **problems** feel free to contact me or create an issue. 🔴


# Hello World

Generally you want to launch a QEMU machine with an operating system like ArchLinux. But, before doing that, we need to learn a bit more. Be patient we will get there! For now, let's run a simple "Hello World" QEMU machine by launching a Linux kernel image. 

## Kernel Images

Every Linux kernel is built differently depending on the platform/needs. We will use a more "generic" kernel image taken from Debian's repositories.

> You can choose to build your own kernel or find another Linux kernel image (Oracle, ArchLinux and etc.). Though, the Debian kernel used here is pretty good and generic.

**Step 1 - Download the Linux Kernel**

Head over to Debian's FTP repo and download the Linux `kernel` image for ARM64 machines. \
Repository: http://ftp.debian.org/debian/dists/stable/main/installer-arm64/current/images/netboot/debian-installer/arm64/

Alternatively, on GNU/Linux or macOS, use `wget`:

```bash
$ wget http://ftp.debian.org/debian/dists/stable/main/installer-arm64/current/images/netboot/debian-installer/arm64/linux
```

Alternatively, on Windows 10/11, use `Invoke-WebRequest`:

```powershell
$ Invoke-WebRequest http://ftp.debian.org/debian/dists/stable/main/installer-arm64/current/images/netboot/debian-installer/arm64/linux -OutFile linux
```

**Step 2 - Launch `qemu-system-aarch64`**

Run the below command to launch a QEMU machine with `-nographic` options:

```bash
$ qemu-system-aarch64 -machine virt -cpu cortex-a53 -kernel linux -nographic
```

The QEMU machine should now start by loading/launching the Linux kernel! The logs on the terminal you [hopefully] see are from the Linux kernel. 

Our "Hello World" machine ends with a _kernel panic_ telling us it couldn't find a _root filesystem_ to mount.

> The `-nographic` is pretty self-explanatory. With that option, QEMU machine connects to terminals stdio and does not launch with a GUI.

**Step 3 - Terminate the machine**

Press `CTRL + A` followed by `X` to terminate the machine.

**Step 4 - Launch `qemu-system-aarch64` /w Display (Optional)**

Intuitively, you want your machines to have a display. In **Step 2** we disabled this behaviour with the  `-nographic` option. But, normally QEMU launches with a display. If you have a desktop environment (like many people) you can launch QEMu with a display!

Run the below command to launch a QEMU machine with a display:

```bash
$ qemu-system-aarch64 -machine virt -cpu cortex-a53 -kernel linux
```

By default, the QEMU displays the `QEMU Monitor`[^41]. Don't worry about it too much, we are not there yet! Let's switch consoles.

Press `CTRL + ALT + 2` to switch to the Linux kernel. Now, we can see the same logs that we have seen in **Step 2**!

![QEMU Display](/Media/display_hello_world.png)

**Step 5 - Terminate the machine /w Display (Optional)**

QEMU traps your mouse inside the display. Release it by pressing `CTRL + ALT + G`. Then, just close the QEMU window to terminate it!


💚 If the Linux kernel ended with a **panic** then congrats! 💚 \
🔴 If the QEMU somehow **failed to launch**, feel free to contact me or create an issue. 🔴

# Tools

There are many `tools` provided by QEMU that are used to create, configure and 'launch' machines. I call them tools, _but in fact_, all they are all `binaries`. For simplicity sakes, assume that a `tool` is just a `binary` executable.

It would be unpractical to list and explain all of them here. For that, only the most popular and used `tools` are listed. _Who knows, maybe I will document other ones in the future:)_

> If your `shell` supports _completions_, then you can list most of the QEMU tools by typing `qemu-` and presing `Tab`!

## qemu-img

Allows you to create, convert and modify disk images.[^42] It supports wide variety of image formats such as: `VDI`, `VMDK`, `raw` and `qcow2`. The latter format is special to QEMU machines. It's an abbreviation of **Q**EMU **C**opy-**o**n-**W**rite **2**. 

`qcow2` images initially takes a very tiny space on your disk `~200KB`, but it dynamically grows as the guest OS writes data on it. This way your QEMU machine /w 500GiB disk space does not actually take 500GiB. It's amazing isn't it!

Now, let's go over some of the main usages of `qemu-img`.

**Create**

Create new disk images using the command below:
```bash
$ qemu-img create [options]
```

Example:
```bash
$ qemu-img create -f qcow2 disk0.qcow2 64G  
```

The above example creates a disk image with file type `qcow2` and size `64G` named `disk0.qcow2`. This is the most trivial usage of `qemu-img`.

**Convert**

Different virtual machines use different disk image formats. Popular ones like `VirtualBox` uses `VDI` and VMWare uses `VMDK`. Although, QEMU supports both formats, `qcow2` is the preferred one. So, you can use `qemu-img` to convert from supported formats to `qcow2` and vice-versa.

> I don't think I need to explain how useful this can be >.<

Convert between disk image formats using the command below:
```bash
$ qemu convert [options]
```

Example:
```bash
$ qemu-img convert -f vdi -O qcow2 disk0.vdi disk0.qcow2
```

The above example simply converts a VirtualBox image `-f vdi` to `-O qcow2`.  

**Inspect**

You might want to inspect and get some information about your disk images. This can be useful for developers and some curious people.

> There are many _commands_ that we can use to inspect an image. `info` is just one of them.

Get [basic] information about an image using the command below:
```bash
$ qemu-img info [options]
```

Example:
```bash
$ qemu-img info disk0.qcow2 

# Output can look like this
> image: disk0.qcow2
> file format: qcow2
> virtual size: 8 GiB (8589934592 bytes)
> disk size: 196 KiB
> cluster_size: 65536
> Format specific information:
>     compression type: zlib
>     ...
>     corrupt: false
> Child node '/file':
>     ...
```

## qemu-system-x86_64

The main and one of the most used `binary` in QEMU. `qemu-system-x86_64` is used to run emulated/virtualized machines. Most of the time you will be using this to launch your machines. [^43]

> The `qemu-system-*` is a prefix that is used by many other `binaries`. It is generally followed by an architecture name like: `aarch64` and `riscv64`. _Each of them has different options and configurations._ [^44]

Extremely simplified usage of `qemu-system-x86_64`:
```bash
$ qemu-system-x86_64 [options] [disk_image]
```

When you want to launch a machine, you need to specify options. For a starter, this can be overwhelming. You might find yourself asking questions like:

- What are those options?
- Which options should I specify?
- What are the important ones?
- What happens if I don't specify one?
- Why are we still here?
- Where can I find happiness?

To answer them, we need to go over the **most used** ones. From there, you will get an overall idea how to launch machines using `qemu-system-x86_64`.

Just to give an idea here is an example usage:

```bash
$ qemu-system-x86_64 \
  # Hardware Acceleration (Hypervisor)
  -accel kvm

  # System Specs
  -name MyFirstQemu \
  -m 2G \
  -cpu host \
  -smp 2 \
  
  # Disks
  -drive if=none,file=${INSTALL_IMAGE_PATH},format=qcow2,id=hd0 \
  -device virtio-blk-device,drive=hd0,serial="main_disk" \ 
  -cdrom ${VM_DISK_PATH} \
  
  # Devices
  -device usb-ehci  \
  -device usb-kbd \
  -usb \

  # Network
  -device virtio-net-device,netdev=net0 \
  -netdev user,id=net0 \

  # Display
  -device virtio-gpu \
  -vga none \

  # Serial & Terminal
  -serial stdio
```

If you're feeling ready for the main event, let's begin!

# Configurations

Like every machine in the real-world, every QEMU machine can be different. The CPU architecture, memory size, devices, disks, displays and so on. Each of these settings can be customized. For example, you can create a QEMU machine with `Cortex A72 CPU`, `8GiB RAM` and devices like `USB-Storage`, `Intel E1000 Network Card`, `AHCI HDD`, `UART`, `Console`... QEMU is greatly configurable. You have many devices and options to choose from!

> You can basically create your own machine. Just like building a custom computer!

QEMU is capable of emulating many devices and CPUs![^45] However, as you know already, emulation is expensive! If your intention is to have a performant, _maybe even near-native_, machines then using emulated devices is not a good choice. Espacially emulating a CPU architecture.

To achive good performance QEMU needs to act like a `Virtual Machine` with the help of configurations like `Accelerators` and `Virtio` devices. Now, at this exact point we are faced with two options:

- **Use QEMU as an Emulator:** In this approach, QEMU emulates all the hardware devices and the CPU architecture. This is the _default mode_ of operation and is suitable for compatibility with a wide range of guest operating systems and architectures. However, the performance might not be optimal due to the overhead of emulation.
- **Use QEMU as a Virtual Machine:** In this approach, QEMU is _configured_ to take advantage of Accelerators, such as `KVM` or leverage hardware device virtualization (aka. `virtio`). `Virtio` devices are paravirtualized devices that offer efficient communication between the guest and host OS.[^46] By using these technologies, QEMU can achieve significantly better performance and reduce the emulation overhead.

> You can also configure QEMU to be `half emulator` and `half virtualizor`. For example, using `KVM` in combination with the `Intel E1000 Network Card`.

How you configure your QEMU machine will depend on your specific needs. If performance is a priority, utilizing QEMU with `Accelerators` and `Virtio` devices is highly recommended. Now, enough talking. Let's go over the configurations! 

_**Important Note:** Some `qemu-system`s might have additional configurations. However, the ones explained in this guide should be more than enough. If you want to learn more, be sure to check the given references!_

## Machine

Usage (type `-machine help` to get a list of all targets):
```bash
$ qemu-system-x86_64 -machine [target]
```

Specifies which machine to be emulated. Defines some base values such as the CPU, memory and devices. For example the machine `pc-i440fx` represents a classic PC based on the `Intel 440FX` chipset. The specific default values can vary depending on the machine type and _version_. In the case of the `pc-i440fx` machine type, the default configuration includes an Intel Pentium processor, 128MB of RAM, and other standard PC components.

Another good example would be the `raspi3b` machine. This machine, as you might have guessed, represents a `Raspberry Pi 3b` that has `Cortex A53 (4 cores)` and `1GiB RAM`.
> More about `raspi3b` here: https://www.qemu.org/docs/master/system/arm/raspi.html

_**Important Note:** Any of the default values can be overridden! It is pretty common to do so. This means you can have a `raspi3b` with `16GiB RAM`!_

Which machine should you choose can be confusing. There might be too many options. If you are confused use either of the following machines:

- **q35:** Represents a modern PC (Available on `qemu-system-x86_64`) [^TODO:https://wiki.qemu.org/Features/Q35]
- **virt:** Represents a machine _suitable_ for virtualization (Available on `qemu-system-aarch64`) [^TODO:https://www.qemu.org/docs/master/system/arm/virt.html]

## CPU

Usage (type `-cpu help` to get a list of all CPUs)
```bash
$ qemu-system-x86_64 -cpu [target],[features]
```

Specifies which the CPU to be emulated. Defines the CPU architecture (ARMv8, x86...), ABI, layout (NUMA), core count, caches, registers, and feature flags. For example `Cortex A53`, will define an `ARMv8-A` CPU with `2 Cores @ 2.00GHz` and `L1-2-3 Caches`. The exact numbers and CPu features depends on your QEMU version and the type of machine you use.

Additionally, you can set some CPUID feature flags. Each CPU has different features that can be enbaled/disabled. The `code snippet` at the start will also list all avaialble CPUID flags. For example, to define a `Intel Core i7-8700K` CPU with  `AVX (Advanced Vector Extensions)` use:

```bash
$ qemu-system-x86_64 -cpu SandyBridge,+avx
```

> The official QEMU documentations doesn't _really_ help you on how CPUID flags can be used or implemented. If you know a good source on this, feel free to contact me!

Which CPU and CPUID flags should you choose can be, _again_, confusing. If you are confused use the following CPU:

- **host:** Passes the host CPU model features, model, stepping, exactly to the guest. (Requires an `Hypervisor`) [^TODO:https://qemu-project.gitlab.io/qemu/system/qemu-cpu-models.html]

> https://www.qemu.org/docs/master/system/i386/cpu.html

### Core Count (vCPU / SMP)

The `-cpu [target]` option in QEMU defines a default core count (vCPU). However, you may want to increase it to improve performance. To do so, you can combine the `-cpu` option with `-smp`. For example, to define a `Cortex A53 CPU` with `8 Cores`, use `-smp 8`:

```bash
$ qemu-system-aarch64 -cpu cortex-a53 -smp 8
```  

**S**ymmetric **M**ulti**P**rocessing (SMP) is used to specify the number of virtual CPUs (vCPUs) for the QEMU machine.[^TODO:https://en.wikipedia.org/wiki/Symmetric_multiprocessing] Increasing the core count can **enhance** the performance of your guest OS, _provided that your host CPU has enough cores_. Therefore, it is highly recommended to specify the `-smp` option in your QEMU `virtual` machines.

## Memory

Usage (type `-m help` for more information):
```bash
$ qemu-system-x86_64 -m [size]
```

Specifies the amount of memory (RAM) allocated to the guest. The amount of memory is immediately allocated. Meaning, if you specify a `4GiB RAM` than that fixed amount of memory is given to the guest and does NOT dynamically shrinks/grows.

The important thing to note here is that the amount of memory you specify **should be within the limits of your host system's available physical memory**. Allocating excessive memory to the virtual machine may impact the performance of both the host and the guest.

The default `[size]` unit is `Mebibyte (MiB)`. Meaning `-m 1024` will be equal `1024 MiB (1GiB)`. You can, however, specify the memory size using `suffixes` like `k, M, G, T`. They, _in order_, refer to `kibibyte`, `Mebibyte`, `Gigibyte` and `Tebibyte`. 

An example machine with `4GiB` would use:
```bash
$ qemu-system-x86_64 -m 4G
```

## Disks

Usage (for `help` refer to [QEMU Source Code](https://github.com/qemu/qemu/blob/master/docs/qdev-device-use.txt)):
```bash
$ qemu-system-x86_64 -drive [option],[option],[...]
```

Specifies a new drive. Generally defines a storage device, such as a disk image, that can be attached to the machine. It allows you to configure the storage options and provide access to files or block devices within the machine. You can specifiy more than one drives.

> Sound complicated? Well, think of this options as an `SSD`, `HDD` or any type of `Storage` device that is attached to the machine.

As you can see from the _Usage_, `-drive` has many options. The exact list of options depends on your QEMU version and `qemu-system`. However, most of the time you will using just a few of them. Here is a list of the **most commonly used** `-drive` options.

_**Important Note:** Most of the time you will be using multiple options. For example, `file=[option]`, is commonly used in combination with `format=[option]`. Which options should you use depends on entirely your needs._

### `file=[option]`

Specifies the `path` to the disk image file. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=/home/mike/machines/disks/archlinux0.img
```
index: Specifies the index or position of the drive attachment.
media: Specifies the type of media, such as disk, cdrom, etc.
snapshot: Enables snapshot mode for the drive.

### `format=[option]`

Specifies the format of the disk image. Commonly used formats include `raw`, `qcow2`, `vmdk`, etc. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=archlinux0.qcow2,format=qcow2
```

> For more information to [qemu-img](#qemu-img).

### `if=[option]`

Specifies the interface type of the storage device. The guest must include the necessary driver. Commonly used interfaces include `IDE`, `SCSCI`, `VIRTIO`, `PFLASH`etc. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=archlinux0.qcow2,format=qcow2,if=virtio
```

### `index=[option]`

Specifies the index or position of the drive. The order of drive is important if you have multiple drives specified. Generally, `Bootloaders` will try to boot the first drive. The `index` order depends entirely on your needs. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=archlinux0.qcow2,format=qcow2,if=virtio,index=1 \
                     -drive file=ubuntu0.qcow2,format=qcow2,if=virtio,index=2

```

### `media=[option]`

Specifies the media type of the drive. Commonly used options include `cdrom`, `disk`, etc. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=windows11_setup.img,format=raw,if=virtio,index=1,media=cdrom

```

### `readonly=[option]`

Specifies if the drive should be marked as **readonly**. This is generally used with `cdrom` medis or `PFLASH` drives as to protect the drive. You can set this value to `on` to mark that drive as readonly. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=efi.fd,format=raw,if=pflash,readonly=on
```

> If not specified, the drive will be both **readable** and **writable**.


Now, there are many possibilities with the `-drive`. You can have specifiy many drives, roms, storage devices and etc. It might be confusing to decide which option to use and where. So, I wrote some of the most common use cases to help you decide.

- **General Drive (SSD/HDD):**  Use this type for large storage devices. (e.g. Install OS, Backup files) 
- **Optical Drive (CD/DVD):** Use this for installation images. (e.g. ubuntu-arm64.iso, archboot.aarch64.iso)
- **Flash ROM:** Use this for readonly drives. (e.g. EFI)

Here's a simple usage:
```bash
# Flash ROM
-drive file=edk2-aarch64-code.fd,format=raw,if=pflash,readonly=on,index=1

# Optical Drive (CD/DVD)
-drive file=ubuntu-arm64.iso,format=raw,media=cdrom,index=2

# General Drive (SSD/HDD)
-drive file=disk0.qcow2,format=qcow2,if=virtio,index=3
-drive file=disk1.vdi,format=vdi,if=virtio,index=4
```

> Refer to [qemu-img](#qemu-img) on how to _create disk images_. You can also obtain images from the internet!

## Devices

@TODO: Give information about the '-device' argument. There are tons of different devices (for ex. virtio). Find a way talk about all of them without boring the reader.

## Display

@TODO: Give information about the '-display', '-serial' and '-nographic' arguments.

## BIOS & UEFI

@TODO: Give information about the '-bios' argument. Also talk about the OVMF project.

### EFI Locations

@TODO: Move this section somewhere else.
Possible locations for EFI files on AARCH64 and x86_64 systems.

#### GNU/Linux - Debian (ARM64 | x86_64)

```bash
$ file /usr/share/qemu-efi-aarch64/QEMU_EFI.fd
```

#### macOS 13.0 (Ventura)

```bash
$ file /opt/homebrew/Cellar/qemu/*.*/share/qemu/edk2-aarch64-code.fd
```

## Accelerator

@TODO: Give information about the '-accel' argument. Talk about KVM, Hypervisor.framework and Hyperviser-V.

# Shortcuts / Key Bindings

@TODO: While running with `-nographic` QEMU can be controlled via the QEMU Shell and key binding. Talk about them here.

# Example VM-1: Ubuntu 22.04

@TODO: Give an average configration that creates an example Ubuntu machine.

# Example VM-2: ArchLinux

@TODO: Give an average configration that creates an example machine that is able to boot ArchLinux.

# Example VM-3: Windows 11

@TODO: Give an average configration that create an example Windows machine.

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
[^21]: https://wiki.qemu.org/Hosts/Linux
[^22]: https://wiki.qemu.org/Hosts/W32
[^23]: https://wiki.qemu.org/Hosts/Mac
[^24]: https://archlinux.org/packages/extra/x86_64/qemu-full/
[^25]: https://qemu.readthedocs.io/en/latest/tools/qemu-img.html
[^26]: https://www.qemu.org/docs/master/system/target-i386.html
[^27]: https://www.qemu.org/docs/master/system/target-arm.html
[^28]: https://www.qemu.org/docs/master/user/main.html
[^30]: https://qemu.readthedocs.io/en/latest/tools/qemu-nbd.html
[^31]: https://wiki.qemu.org/Features/KVM
[^32]: https://qemu.readthedocs.io/en/latest/tools/qemu-storage-daemon.html
[^33]: https://qemu.readthedocs.io/en/latest/tools/qemu-trace-stap.html
[^34]: https://en.wikipedia.org/wiki/X86_virtualization#Intel_virtualization_(VT-x)
[^35]: https://en.wikipedia.org/wiki/X86_virtualization#AMD_virtualization_(AMD-V)
[^36]: https://www.cyberciti.biz/faq/linux-xen-vmware-kvm-intel-vt-amd-v-support/
[^37]: https://wiki.archlinux.org/title/KVM
[^38]: https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1
[^39]: https://www.qemu.org/download/#windows
[^40]: https://qemu.readthedocs.io/en/latest/user/main.html#supported-operating-systems
[^41]: https://en.wikibooks.org/wiki/QEMU/Monitor
[^42]: https://qemu.readthedocs.io/en/latest/tools/qemu-img.html
[^43]: https://www.qemu.org/docs/master/system/invocation.html
[^44]: https://www.qemu.org/docs/master/system/targets.html
[^45]: https://qemu-project.gitlab.io/qemu/system/device-emulation.html
[^46]: https://blogs.oracle.com/linux/post/introduction-to-virtio
