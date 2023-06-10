# Motivation

You might expect that with the _invention_ of the internet, the access to the information has became extremely easy. Although, it is true that we have _overwhelming_ amount of information available, the ease of access to them is still _pretty bad_.[^99] This is particularly evident when it comes to technical documentation for _complex software systems_ like QEMU. [^100]

The information from the official QEMU documentation and communities like Stack OverFlow is pretty fragmented and _somewhat lacking. It is very  hard for someone to just _search for something_ and find the answers. They might have to go through bajillion different pages in order to find what they are looking for. This can be extremely frustrating for the newcomers. I, _for one_ felt this way and wanted to change this by combining all of them here to help others like me. Some might even call this a _guide_ or simply a _pseudo-wiki_.

However, I am well aware that there is a possibility that I might create more _information pollution_ by doing so. For that, I intend to contribute to other _popular_ Wikis like [QEMU Wiki](https://wiki.qemu.org/Main_Page) and [Wikibooks](https://en.wikibooks.org/wiki/QEMU). I know that it is not an _easy task_ but it's worth a shot. (a.k.a #insert-it-aint-much-but-its-honest-work-meme-here)

> **Extremely Important Note:** This pseudo-wiki is intended for beginners and newcomers to QEMU. If you are an advanced user, you might the information here 'not satisfying', 'lacking' and straight up 'wrong'. For those people, I want to remind them that this is a **beginner-friendly** guide and not an advanced one. So, set-up your expectations according to that.

Now, enough formality. Let me start by saying: "This pseudo-wiki welcomes all adventurers seeking knowledge and excitement in the world of QEMU! While it may seem challenging at first, the journey will be worth it [and fun], teaching you valuable lessons along the way <3" 

# Quick Access

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
- [Tools/Binaries](#toolsbinaries)
  - [qemu-img](#qemu-img)
  - [qemu-system-x86_64](#qemu-system-x86_64)
  - [qemu-system-aarch64](#qemu-system-aarch64)
- [Configurations](#configurations)
  - [Machine](#machine)
  - [CPU](#cpu)
  - [Memory](#memory)
  - [Disks](#disks)
  - [Devices](#devices)
  - [BIOS \& UEFI](#bios--uefi)
- [Networking](#networking)
- [Combining it All Together](#combining-it-all-together)
- [Shortcuts \& Key Bindings](#shortcuts--key-bindings)
- [Example VM-1: ArchLinux](#example-vm-1-archlinux)
- [Example VM-2: macOS](#example-vm-2-macos)

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

By default, QEMU emulates everything and that includes the CPU. Emulating a CPU is extremely hard and brings lots of overheads ([tho it's a fascinating thing!](http://www.emulator101.com/a-quick-introduction-to-a-cpu.html)). The emulated machine is, naturally, slow and becomes unpractical to use.

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

> The above steps are taken directly from Microsoft's official guide. [^38]

# Installation

The following sections gives a step-by-step tutorial on how to install QEMU and it's utilities. Note that you need an active internet connection to download some packages.

## GNU/Linux

Each distro uses different package managers. In the following sections only the most 'popular' distros are given. However, they are all very similar and you should be able to adapt them to your own distro/package-manager.

> Tested on ArchLinux (19 May 2023), Ubuntu 22.04 LTS, Windows 11 22H2 and macOS 13.3.

### ArchLinux (pacman)

The below commands should be run as the `root` user. Proceed with caution!

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

# Output will look similar to this
> resolving dependencies...
> looking for conflicting packages..

> Packages (41) edk2-aarch64-202302-1 ....
>               ...
>               qemu-full-8.0.0-1
>
> Total Download Size:      105.25 MiB
> Total Installed Size:     785.45 MiB
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

💚 If the above commands **worked** then congrats, you successfully installed QEMU! 💚 \
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

# Output will look similar to this
> ...
> The following NEW packages will be installed:
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

💚 If the above commands **worked** then congrats, you successfully installed QEMU! 💚 \
🔴 If you ran into any **problems** feel free to contact me or create an issue. 🔴

## Windows 10/11

There are fundamentally two ways to 'natively' install QEMU on Windows platforms: `MSYS2` or `Installers`. We will use the latter one, as it's easier and more straightforward.

> The `binaries/installers` are provided by Stefan Weil [^39]

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

> You might get an error like _'qemu-img' is not recognized as an internal or external command,..._ Make sure that your `PATH` variable is set-up correctly.

💚 If the above commands **worked** then congrats, you successfully installed QEMU! 💚 \
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

💚 If the above commands **worked** then congrats, you successfully installed QEMU! 💚 \
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

# Tools/Binaries

There are many `tools` provided by QEMU that are used to create, configure and 'launch' machines. I call them tools, _but in fact_, all they are all `binaries`. For simplicity sakes, assume that a `tool` is just a `binary` executable.

It would be unpractical to list and explain all of them here. For that, only the most popular and used `tools` are listed. _Who knows, maybe I will document other ones in the future:)_

> If your `shell` supports _completions_, then you can list most of the QEMU tools by typing `qemu-` and pressing `Tab`!

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

## qemu-system-aarch64

Similar to [qemu-system-x86_64](#qemu-system-x86_64), but for the `AARCH64` architecture. Meaning most of the configuration settings between  `qemu-system-aarch64` and the `qemu-system-x86_64` will be the same. The only difference is going to be the availability of `-machine` and `-cpu` options.

All of the things in this pseudo-wiki applies to both  `qemu-system-aarch64` and  `qemu-system-x86_64`. So, you can follow without worrying about which one to use.

> I will make use of both of them throughout this entire pseudo-wiki. But, feel free to use whichever one you prefer!

If you're feeling ready for the main event, let's begin!

# Configurations

Like every machine in the real-world, every QEMU machine can be different. The CPU architecture, memory size, devices, disks, displays and so on. Each of these settings can be customized. For example, you can create a QEMU machine with `Cortex A72 CPU`, `8GiB RAM` and devices like `USB-Storage`, `Intel E1000 Network Card`, `AHCI HDD`, `UART`, `Console`... QEMU is greatly configurable. You have many devices and options to choose from!

> You can basically create your own machine. Just like building a custom computer!

QEMU is capable of emulating many devices and CPUs![^45] However, as you know already, emulation is expensive! If your intention is to have a performant, _maybe even near-native_, machines then using emulated devices is not a good choice. Especially emulating a CPU architecture.

To achieve good performance QEMU needs to act like a `Virtual Machine` with the help of configurations like `Accelerators` and `Virtio` devices. Now, at this exact point we are faced with two options:

- **Use QEMU as an Emulator:** In this approach, QEMU emulates all the hardware devices and the CPU architecture. This is the _default mode_ of operation and is suitable for compatibility with a wide range of guest operating systems and architectures. However, the performance might not be optimal due to the overhead of emulation.
- **Use QEMU as a Virtual Machine:** In this approach, QEMU is _configured_ to take advantage of Accelerators, such as `KVM` or leverage hardware device virtualization (aka. `virtIO`). `VirtIO` devices are paravirtualized devices that offer efficient communication between the guest and host OS.[^46] By using these technologies, QEMU can achieve significantly better performance and reduce the emulation overhead.

> More on `virtIO` devices later. They are pretty cool and useful!
> You can also configure QEMU to be `half emulator` and `half virtualizor`. For example, using `KVM` in combination with the `Intel E1000 Network Card`.

How you configure your QEMU machine will depend on your specific needs. If performance is a priority, utilizing QEMU with `Accelerators` and `virtIO` devices is highly recommended. Now, enough talking. Let's go over the configurations! 

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

- **q35:** Represents a modern PC (Available on `qemu-system-x86_64`) [^47]
- **virt:** Represents a machine _suitable_ for virtualization (Available on `qemu-system-aarch64`) [^48]

## CPU

Usage (type `-cpu help` to get a list of all CPUs)
```bash
$ qemu-system-x86_64 -cpu [target],[features]
```

Specifies which the CPU to be emulated. Defines the CPU architecture (ARMv8, x86...), ABI, layout (NUMA), core count, caches, registers, and feature flags. For example `Cortex A53`, will define an `ARMv8-A` CPU with `2 Cores @ 2.00GHz` and `L1-2-3 Caches`. The exact numbers and CPu features depends on your QEMU version and the type of machine you use.

Additionally, you can set some CPUID feature flags. Each CPU has different features that can be enabled/disabled. The `code snippet` at the start will also list all available CPUID flags. For example, to define a `Intel Core i7-8700K` CPU with  `AVX (Advanced Vector Extensions)` use:

```bash
$ qemu-system-x86_64 -cpu SandyBridge,+avx
```

> The official QEMU documentations doesn't _really_ help you on how CPUID flags can be used or implemented. If you know a good source on this, feel free to contact me!

Which CPU and CPUID flags should you choose can be, _again_, confusing. If you are confused use the following CPU:

- **host:** Passes the host CPU model features, model, stepping, exactly to the guest. (Requires an `Hypervisor`) [^49]

### Core Count (vCPU / SMP)

The `-cpu [target]` option in QEMU defines a default core count (vCPU). However, you may want to increase it to improve performance. To do so, you can combine the `-cpu` option with `-smp`. For example, to define a `Cortex A53 CPU` with `8 Cores`, use `-smp 8`:

```bash
$ qemu-system-aarch64 -cpu cortex-a53 -smp 8
```  

**S**ymmetric **M**ulti**P**rocessing (SMP) is used to specify the number of virtual CPUs (vCPUs) for the QEMU machine.[^50] Increasing the core count can **enhance** the performance of your guest OS, _provided that your host CPU has enough cores_. Therefore, it is highly recommended to specify the `-smp` option in your QEMU `virtual` machines.

### Accelerator

The `-accel [hypervisor]` option in QEMU defines the Hypervisor to be used. This uses [Hardware Acceleration (Optional)](#hardware-acceleration-optional) to speed up the `-cpu` substantially. Refer to the previous sections for more information about accelerators and Hypervisors.

In order to use the `-accel` option, the compatible `-cpu` option needs to be defined. Also, the `qemu-system-*` you are using MUST be similar to your host's architecture. For example, `qemu-system-x86_64` can only be used with `-accel` option if your host CPU is also x86_64.

Here's a quick checklist to see if your guest machine can be used with `-accel` option or not.

- **host machine supports it:** Refer to [Hardware Acceleration (Optional)](#hardware-acceleration-optional)
- **guest cpu supports it:** Currently only the `-cpu host` is available.[Citation needed]

If you pass both of these, then you can safely use the `-accel` option. By the way, this is also knows as virtualization. It is a big topic, I know. Refer to previous sections for more info on this.

The `-accel [hypervisor]` needs to know which Hypervisor to use. Here's the current list of Hypervisors supported by QEMU:

- `kvm`: On GNU/Linux systems (a.k.a Linux-KVM)
- `whpx`: On Windows 10/11 systems (a.k.a Hyper-V)
- `hvf`: On Apple macOS systems (a.k.a Hypervisor.Framework)

> Again, refer to [Hardware Acceleration (Optional)](#hardware-acceleration-optional) for more information on them.

An example usage of `-accel [hypervisor]`:
```bash
$ qemu-system-aarch64 -cpu host -smp 4 -accel hvf
```  

## Memory

Usage (type `-m help` for more information):
```bash
$ qemu-system-x86_64 -m [size]
```

Specifies the amount of memory (RAM) allocated to the guest. The amount of memory is immediately allocated. Meaning, if you specify a `4GiB RAM` than that fixed amount of memory is given to the guest and does NOT dynamically shrinks/grows.

The important thing to note here is that the amount of memory you specify **should be within the limits of your host system's available physical memory**. Allocating excessive memory to the virtual machine may impact the performance of both the host and the guest.

The default `[size]` unit is `Mebibyte (MiB)`. Meaning `-m 1024` will be equal `1024 MiB (1GiB)`. You can, however, specify the memory size using `suffixes` like `k, M, G, T`. They, _in order_, refer to `kibibyte`, `Mebibyte`, `Gibibyte` and `Tebibyte`. 

An example machine with `4GiB` would use:
```bash
$ qemu-system-x86_64 -m 4G
```

## Disks

Usage (for `help` refer to [QEMU Source Code](https://github.com/qemu/qemu/blob/master/docs/qdev-device-use.txt)):
```bash
$ qemu-system-x86_64 -drive [option],[option],[...]
```

Specifies a new drive. Generally defines a storage device, such as a disk image, that can be attached to the machine. It allows you to configure the storage options and provide access to files or block devices within the machine. You can specify more than one drives.

> Sound complicated? Well, think of this options as an `SSD`, `HDD` or any type of `Storage` device that is attached to the machine.

As you can see from the _Usage_, `-drive` has many options. The exact list of options depends on your QEMU version and `qemu-system`. However, most of the time you will using just a few of them. Here is a list of the **most commonly used** `-drive` options.

_**Important Note:** Most of the time you will be using multiple options. For example, `file=[option]`, is commonly used in combination with `format=[option]`. Which options should you use depends on entirely your needs._

### `file=[option]`

Specifies the `path` to the disk image file. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=/home/mike/machines/disks/archlinux0.img
```
index: Specifies the index or position of the drive attachment.
media: Specifies the type of media, such as disk, CD-ROM, etc.
snapshot: Enables snapshot mode for the drive.

### `format=[option]`

Specifies the format of the disk image. Commonly used formats include `raw`, `qcow2`, `vmdk`, etc. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=archlinux0.qcow2,format=qcow2
```

> If not specified, QEMU will **try** to guess the `file` format. It is recommended to specify a `format` just in case.
> Refer to [qemu-img](#qemu-img) for more information on formats.

### `if=[option]`

Specifies the interface type of the storage device. The guest must include the necessary driver. Commonly used interfaces include `IDE`, `SCSCI`, `VIRTIO`, `PFLASH` etc. An example usage would be:
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

Specifies if the drive should be marked as **readonly**. This is generally used with `CD-ROM` medias or `PFLASH` drives as to protect the drive. You can set this value to `on` to mark that drive as readonly. An example usage would be:
```bash
$ qemu-system-x86_64 -drive file=efi.fd,format=raw,if=pflash,readonly=on
```

> If not specified, the drive will be both **readable** and **writable**.


Now, there are many possibilities with the `-drive`. You can have specify many drives, ROMs, storage devices and etc. It might be confusing to decide which option to use and where. So, I wrote some of the most common use cases to help you decide.

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

Usage (type `-device help` to get a list of all devices)
```bash
$ qemu-system-x86_64 -device [target],[option]
```

Specifies the device to be used in the machine, along with any additional options. QEMU provides virtual/emulated hardware devices to the guest machine, allowing it to interact with the external world, just like if it were running on real hardware. [^51].

> The sentence above is taken almost **as is** from the QEMU Wikibooks page.

Just like in a real hardware, QEMU machines can also have external devices connected to them. For example, `USB`, `Network Card`, `VGA`, `Sound Card` and many more! There are many options that you can choose here, and each have it's own options as well. It would be a VERY LONG GUIDE if I were to explain each of them here. For that, I will explain only the most used ones here.

**Useful Information**
You can add `help` as an option to any `-device` targets to get a list of all available options! It is a great way to learn more about that device. Here's an example:
```bash
$ qemu-system-x86_64 -device sd-card,help 

# Output
> sd-card options:
>   drive=<str>            - Node name or ID of a block device to use as a backend
>   spec_version=<uint8>   -  (default: 2)
>   spi=<bool>             -  (default: false)
```

### VirtIO

**Virt**ual **I**nput/**O**utput, `virtIO`, devices are special type of devices that are tailored for virtual machines. Formally, `virtIO` is not a device but a specification. [^52] The main purpose here is to simplify the virtual devices, and _naturally_ making them efficient and high-performant. There are many devices specified within `virtIO` specification. We simply call them `virtIO` devices.

Here are some of the most commonly used ones:

- **Networking `virto-net`** [^53]
- **Storage `virtio-scsi`** [^54]
- **Block `virto-blk`** [^55]
- **GPU `virtio-gpu`** [^56]
- **Console `virtio-console`** [^57]
- **Serial `virto-serial`** [^58]

Unlike other devices in QEMU (`Intel E1000 Network Card`), the above `virtIO` devices are very minimal. This is because most of the operations like setup and maintenance is handled by the host. This makes `virtIO` very simple and straightforward to use within the guest.

`virtIO` devices are pretty cool. If you are interested about how they work and implemented check out Oracle's [Introduction to VirtIO](https://blogs.oracle.com/linux/post/introduction-to-virtio). For now, all we need to know is that _they are special devices designed to be used in virtual machines_.

> Each `virtIO` device deserve its own writing. I will only talk about _some_ of them here. If you want to learn more, check out the _references_ linked in the above list.

### Input Devices

Input devices in QEMU refer to the devices that allow users to interact with the guest machine by providing input. These devices include `keyboards`, `mouse`, and other `input peripherals`. Here's some of the most commonly used input devices.

- `usb-kbd`: An emulated generic USB keyboard.
- `usb-mouse`: An emulated generic USB mouse.
- `usb-serial`: An emulated USB serial device for serial communication.
- `usb-tablet`: An emulated USB tablet for touch inputs. (_pretty cool imo_)
- `virtio-keyboard`: Virtual keyboard that uses the `VirtIO` specification.
- `virtio-mouse`: Virtual mouse that uses the `VirtIO` specification.
- `virtio-serial`: Virtual serial communication that uses the `VirtIO` specification.
- `virtio-tablet`: Virtual table for touch inputs that uses the `VirtIO` specification.

There are many more _Input devices_ that can be specified in QEMU. But most of the time you will only be using the ones above. The importing to note here is the difference between the `usb-*` and `virtio-*` devices. Essentially, **both** achieves the same thing. The only difference is their implementation (_guest driver and host device_).

If you want an efficient input device, then simply use `virtio-*` devices. However, if you really need `usb-*` devices (when developing/testing drivers), then use that as you wish.

An example usage:
```bash
$ qemu-system-x86_64 ... -device usb-kbd -device usb-mouse ...
```

To learn more about an _Input device_ use `-device [target],help`:
```bash
$ qemu-system-x86_64 -device usb-kbd,help

# Output
> usb-kbd options:
>  attached=<bool>
>  display=<str>
>  msos-desc=<bool>       - on/off (default: true)
>  pcap=<str>
>  port=<str>
>  serial=<str>
>  usb_version=<uint32>   -  (default: 2)
```

### Network Devices

Network devices in QEMU provides the guest machine with a Network Interface Controller (NIC).[^59]. These NIC devices enables the guest machine to connect to various types of networks. Refer to the [Networking](#networking) for more information on how _Networking_ is handled within QEMU.

 Here are some of the most commonly used network devices:

- `e1000`: Emulates an Intel 8254x-based Gigabit Ethernet NIC.
- `rtl8139`: Emulates a Realtek RTL8139-based Ethernet NIC. (_very popular_)
- `virtio-net`: A virtual NIC using the `VirtIO` specification.
- `usb-net`: Emulates a generic USB NIC.

These network devices offer different network connectivity options for the guest machine. You can choose the appropriate device based on your requirements and needs. Generally `rtl8139` and `e1000` is used when developing/testing Ethernet drivers. And `virtio-net` is used [heavily] within virtual machines and various cloud solutions.

An example usage:
```bash
$ qemu-system-x86_64 ... -device rtl8139,mac=52:54:00:12:34:56,netdev=mynetdev ...
```

> The `netdev=[name]` is very important in here. Please, refer to [Networking](#networking).

To learn more about a _Network device_ use `-device [target],help`:
```bash
$ qemu-system-x86_64 -device rtl8139,help

# Output
> rtl8139 options:
>  acpi-index=<uint32>    -  (default: 0)
>  addr=<int32>           - Slot and optional function number, example: 06.0 or 06 (default: -1)
> ...
>  mac=<str>              - Ethernet 6-byte MAC Address, example: 52:54:00:12:34:56
> ...
>  netdev=<str>           - ID of a netdev to use as a backend
>  ...
```

### Storage Devices

Storage devices in QEMU facilitate the storage and retrieval of data between the guest and host machine. They allow the guest machine to access and manage storage resources (like a real-world storage device). 

Here are some of the most commonly used storage devices in QEMU:

- `scsi-hd`: Emulates a SCSI disk device (SSD/HDD).
- `scsi-cd`: Emulates a SCSI CD/DVD device.
- `ide-hd`: Emulates an IDE hard disk device (SSD/HDD).
- `ide-cd`: Emulates an IDE CD/DVD device.
- `nvme`: Emulates an NVMe (Non-Volatile Memory Express) storage device.
- `usb-storage`: Emulates a generic USB storage device.
- `sd-card`: Emulates a generic SD card device.
- `virtio-blk`: A virtual block device that uses `VirtIO` specification.
- `virtio-scsi`: A virtual storage device uses the SCSI protocol and the `VirtIO` specification.

You might be confused, because we already have `-drive` to give storage access to the guest machine (Refer to [Disks](#disks)). Why do we have another way to add a storage device? You are totally right, the difference between a `-device [storage_dev]` and a `-drive` is somewhat blurry. But they DO have different purposes.

The storage devices (`-device [storage_dev]`) gives the guest machine just an interface. The _storage_ part of if does not exist until you specify one using the `-drive`. This might be useful when developing/testing a driver. Now, let's go over an example to understand this better.

Assume that I have a disk image called `disk0.qcow2`. I have two options to expose that to my QEMU machine.

- **Using only `-drive`:** The simplest way. Just do `... -drive file=disk0.qcow2,format=qcow2,if=virtio`
- **Using both `-device` and `-drive`:** The more _controlled way_. Do `-device virtio-blk,drive=mydrive` and `-drive file=disk0.qcow2,format=qcow2,id=mydrive`

As you can see I can use `-device` to add a _Storage device_ and ADDITIONALLY use `-drive` to expose my disk image using the **drive** identifier. However, I can choose NOT to use `-device` and simply use `-drive` by specifying the `if=[target]`. With QEMU, you are free to choose whichever you want! 

> In other words, `-device` specifies the device model rather than directly exposing a disk image.

An example usage:
```bash
$ qemu-system-x86_64 ... -device nvme,drive=my-ubuntu-drive ...
```

To learn more about a _Storage device_ use `-device [target],help`:
```bash
$ qemu-system-x86_64 -device virtio-blk,help

# Output
> virtio-blk options:
>  ...
>  drive=<str>                - Node name or ID of a block device to use as a backend
>  ...
>  physical_block_size=<size> - A power of two between 512 B and 2 MiB (default: 0)
>  vectors=<uint32>           -  (default: 4294967295)
>  ...
```

### Display Devices

Display devices in QEMU handle the graphical output of the guest machine. When configured with a _display device_, a window is shown on the host machine. Thru that window, the guest machine can display graphics, _and if possible_, accept inputs such as mouse clicks and touch inputs. 

> QEMU makes use of host's windowing system when displaying GUI elements. `Win32` on Windows[^60], `AppKit` on macOS[^61] and `GTK` on GNU/Linux[^62].

By default, a QEMU machine is launched with a `qxl-vga` _display device_. However, you can disable this via configurations like `-nographic`. This way you will be **disabling the display** and other host GUI elements!

> Disabling the display might be useful if you don't intent to interact with the guest via a GUI (e.g. mouse clicks). For example, servers and headless computers choose to use SSH and/or VNC instead of an actual _display device_.

Here's some of the most commonly used _Displays_:

- `vga`: Emulates a very simple and generic VGA display.
- `bochs-display`: Emulates a generic VGA display. Similar to `vga`.
- `virtio-vga`: A virtual VGA display device using the `VirtIO` specification.
- `virtio-gpu`: A virtual GPU display device using the `VirtIO` specification. Similar to `virtio-vga`.
- `qxl-vga`: Emulates a QXL VGA display. Provides accelerated graphics capabilities for virtual machines. Good for Windows.
- `ramfb`: Emulates a framebuffer device backed by host RAM. Provides a simple display output. 

Most of the time you will be fine using the default _display device_, `qxl-vga`. If your intention is to use QEMU to do some 'heavy' GPU stuff (DirectX, Vulkan, Tensor), just don't. That's why other emulation/virtualization services exist (e.g. [Parallels](https://www.parallels.com), [Crossover](https://www.codeweavers.com/crossover),[VMWare Workstation](https://www.vmware.com/products/workstation-pro.html)). Maybe in the future QEMU will be mature enough for this type of stuff.

> There are some amazing people out there working on 3D acceleration and decent GPU support to QEMU. I highly suggest you to check them out! [Mesa3D VirGL](https://docs.mesa3d.org/drivers/virgl.html), [ArchLinux Guest Graphics Acceleration](https://wiki.archlinux.org/title/QEMU/Guest_graphics_acceleration), [Kraxel Display Devices in QEMU](https://www.kraxel.org/blog/2019/09/display-devices-in-qemu/)

An example usage:
```bash
$ qemu-system-x86_64 ... -device virtio-gpu,xres=1920,yres=1080 ...
```

To learn more about a _Display device_ use `-device [target],help`:
```bash
$ qemu-system-x86_64 -device virtio-gpu,help

# Output
> virtio-gpu-pci options:
>  acpi-index=<uint32>    -  (default: 0)
>  addr=<int32>           - Slot and optional function number, example: 06.0 or 06 (default: -1)
>  ...
>  virtio-backend=<child<virtio-gpu-device>>
>  virtio-pci-bus-master-bug-migration=<bool> - on/off (default: false)
>  ...
>  xres=<uint32>          -  (default: 1280)
>  yres=<uint32>          -  (default: 800)
```

### Sound Devices

Sound devices in QEMU handle the audio output and input of the guest machine. These are basically _Sound cards_ that you connect to the guest machine.
By default, QEMU chooses the good-old `ac97`, which emulates the `AC'97` audio controller.[^63]

Alternatively, you can use the `hda` (Intel High Definition Audio) sound device. This provides support for modern audio controllers and improved audio quality compared to `ac97`.[^64] So, you probably want to use `hda` all the time. Unless, of course, you want to support legacy devices or just want to do some developing/testing.

There are also many more _Sound devices_ that QEMU can emulate.[^65] Here's a list of the most used ones:

- `ac97`: Emulates the AC'97 audio controller.
- `intel-hda`: Emulates the Intel High Definition Audio (HDA) controller.
- `hda-output`: Represents a HDA output device. Emulates a playback-only audio device using the HDA controller.
- `hda-micro`: Represents a HDA input device. Emulates a recording-only audio device using the HDA controller.
- `hda-duplex`: Represents a HDA I/O device. Emulates **both** playback and recording audio device using the HDA controller.
- `ich9-intel`: Emulates the Intel ICH9 HD Audio controller.
- `usb-audio`: Represents a USB audio device. Emulates a USB audio controller, allowing **both** audio playback and recording.

Although, there seems to be many options to choose from, you rarely use anything other than `hda`. It is the most common one both in real-world and in QEMU as well. You might be confused as to why there is `intel-hda` AND `hda-*`. The `intel-hda` in and on itself does NOT provide neither audio playback or recording. It is just an audio controller. You MUST add `hda-output`, `hda-micro` or `hda-duplex` in order to get audio working on your QEMU machine.

> My recommendation is to just use `intel-hda` AND `hda-duplex`, unless you want to develop/test something else. Most guest OS's has `hda` drivers out-of-box (e.g. Windows, GNU/Linux).[^66]

An example usage:
```bash
$ qemu-system-x86_64 ... -device intel-hda -device hda-duplex ...
```

To learn more about a _Sound device_ use `-device [target],help`:
```bash
$ qemu-system-x86_64 -device hda-duplex,help

# Output
> hda-duplex options:
>  audiodev=<str>         - ID of an audiodev to use as a backend
>  cad=<uint32>           -  (default: 4294967295)
>  debug=<uint32>         -  (default: 0)
>  mixer=<bool>           -  (default: true)
>  use-timer=<bool>       -  (default: true)
```

### USB Devices

**U**niversel **S**erial **B**us, USB, devices in QEMU is used for all kinds of purposes. QEMU can emulate a PCI UHCI, OHCI, EHCI or XHCI USB controller.[^67] How these devices can be used is up to the guest machine.

So far, we have seen some USB devices such as `usb-kbd`, `usb-storage` or `usb-audio`. These are all your typical USB devices, used for different purposes. There are many more USB devices that QEMU can also emulate. Here's some of the most popular ones.

- `usb-host`: Allows you to **pass through** a USB device connected from host to guest. [^68]
- `usb-hub`: Emulates a generic USB hub with multiple USB ports. [^69]
- `nec-usb-xchi`:  Emulates an NEC USB eXtensible Host Controller Interface (xHCI) controller. Supports USB 3.0. [^70][^71]
- `usb-ehci`: Emulates a USB 2.0 Enhanced Host Controller Interface (EHCI) controller. [^72]
- `usb-storage`: Represents a USB storage device (e.g. flash drive, external hard drive).
- `usb-mtp`: Emulates a USB Media Transfer Protocol (MTP) device. [^73]
- `usb-net`: Emulates a generic USB network adapter (e.g. Android/iPhone network sharing /w USB).[^74]
- `usb-kbd`: _Refer to [Input Devices](#input-devices)_
- `usb-mouse`: _Refer to [Input Devices](#input-devices)_
- `usb-serial`: _Refer to [Input Devices](#input-devices)_
- `usb-wacom-tablet`: Emulates a USB Wacom tablet device. [^75]
- `usb-audio`: _Refer to [Sound Devices](#sound-devices)_

As you can see, there are many USB device that QEMU can emulate. It is pretty amazing IMO! You can learn more about USB emulation in QEMU from it's official documentation page: [USB emulation](https://qemu-project.gitlab.io/qemu/system/devices/usb.html).

> The USB pass through (`usb-host`) is an extremely useful feature of QEMU. I have personally used it to pass my [Crazyflie 2.1 drone's USB dongle](https://www.bitcraze.io/products/crazyradio-pa/) from the macOS host machine to Ubuntu guest machine!

> You can learn more about it here on [KVM - Assigning Host USB to Guest VM](https://www.linux-kvm.org/page/USB_Host_Device_Assigned_to_Guest)

An example usage:
```bash
$ qemu-system-x86_64 ... -device usb-host,hostbus=3,hostport=10 ...
```

To learn more about an _USB device_ use `-device [target],help`:
```bash
$ qemu-system-x86_64 -device usb-hub,help

# Output
> usb-hub options:
>  attached=<bool>
>  msos-desc=<bool>       - on/off (default: true)
>  pcap=<str>
>  port-power=<bool>      -  (default: false)
>  port=<str>
>  ports=<uint32>         -  (default: 8)
>  serial=<str>
```

## BIOS & UEFI

**B**asic **I**nput/**O**utput **S**ystem (BIOS) and **U**nifed **E**xtensiable **F**irmware **I**nterface (UEFI) are essential components that provide the necessary initialization process for machines.[^76][^77] They are basically the 'first' program that loads when a machine powers up.

These 'programs' are generally stored on a machine's Read-only Memory (ROM). Their main function is to initialize and configure hardware components, perform a Power-On Self-Test (POST), and provide the necessary interfaces for booting the operating system.[^78]. They, in turn, give controls to other programs (a.k.a `bootloaders`) like GRUB2, SysLinux, MS-DOS.

> BIOS and UEFI are two different firmware that tries to solve the same problems.

QEMU, _by default_, uses a BIOS called [SeaBios](https://en.wikipedia.org/wiki/SeaBIOS). It is a pretty good option and most can be used with most bootloaders.[^79] And naturally, every guest machine is loaded with the `SeaBios` and you don't have to do anything. However, you might want, _or need_,  to use UEFI instead.

> UEFI is the modern replacement of BIOS. And naturally, we want to use UEFI whenever possible;)

### OVMF

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

### UEFI on QEMU

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

# Networking

QEMU provides a _very_ flexible networking infrastructure that allows you to configure various modes (e.,g. `Shared`, `Bridged`) and options for networking between the guest and the host machine.[^82] Generally, you will be creating your own **V**irtual **L**ocal **A**rea **N**etworks (VLANs).[^83] 

> Networking in QEMU, might seem scary but don't worry, it is fairly easy to do so when you learn the basics. Most of the 'complex' stuff will be abstracted from you.

Before diving into **HOW-TO**s, lets go over some networking basic in QEMU.

The networking in QEMU can be categorized into two parts `front end` and `back end`, and there are four different modes available for network connectivity.[^84]

## Front End

This part represents the virtual network device that is provided to the guest using the `-device` option (e.g. `Emulated NIC`, `virtio-net`). Please refer to [Network Devices](#network-devices) for more information on this. 

Usage (as a reminder):
```bash
$ qemu-system-x86_64 ... -device rtl8139,mac=52:54:00:12:34:56,netdev=mynetdev ...
```

Note the `netdev=mynetdev` option above. It specifies the **back end** network identifier that the **front end** device is going to connect.

## Back End

On the other hand, back end represents the **network backend** that interacts with the [front end] emulated NIC (e.g. puts packets onto the host's network). You can also think if this part as the one that _listens to the front end handles network packets (e.g. `TCP/IP`)_ and talks with the host machine. It's like a 'proxy server' for emulators![^85]

> For more information on this topic refer to official QEMU documentation on [Networking Basics](https://wiki.qemu.org/Documentation/Networking#Network_Basics).

To configure the back end, we use the `-netdev` option followed by the TYPE of the network backend and its parameters.

Defining a back end:
```bash
$ qemu-system-x86_64 ... -netdev type=[TYPE],id=[NAME],...
```

The `id=[NAME]` options, _as you might've guessed_, is the back end network identifier. The front end device is going to use this `id` to connect to the back end. The `type=[TYPE]` defines the TYPE of network to be used. Now, there are many back end TYPEs out there, however I will only go over some of the most used ones: `user` and `tap`.[^86]

### `user`

The user-mode networking, is the default networking back end and is the easiest one to use. It is implemented using "SLIRP", which provides a full TCP/IP stack within QEMU and uses that stack to implement a virtual NAT'd network. [^87]

> Shameless plug: [More [ELI5] information on NAT](https://medium.com/@tunacici7/linux-networking-eli5-part-1-networks-interfaces-b912826d699b)

Most of the time it is enough to just use `user`. It is enabled by default and you don't have to do many configurations to use it.[^88] However, according to the official [QEMU documentations](https://wiki.qemu.org/Documentation/Networking#User_Networking_(SLIRP)), it has the following limitations:

- there is a lot of overhead so the performance is poor
- in general, ICMP traffic does not work (so you cannot use ping within a guest)
- the guest is not directly accessible from the host or the external network

Some of the above limitations can be overcomed (e.g. via [port-forwarding](https://wiki.archlinux.org/title/QEMU#QEMU's_port_forwarding)), but other things like _relatively 'poor' performance_ is unavoidable. The only [network mode](#modes) available with `user` is the [Shared Network](#shared-network).

### `tap`

The tap backend utilizes the [TUN/TAP](https://en.wikipedia.org/wiki/TUN/TAP). It offers very good performance and can be configured to create virtually any type of network mode (e.g. [Bridged](#bridged)). Unfortunately, it requires configuration of that network mode in the host which tends to be different depending on the operating system you are using. Generally speaking, it also requires that you have **root privileges**.[^89]

> The sentence above is taken almost **as is** from the official QEMU documentation page.

TAP network overcomes all of the limitations of user-mode networking, but requires some configurations depending on the networking mode.[^90].

## Modes

Here are some of the most used network modes that can be configured in QEMU.[^91]

### Shared Network (Default)
In the shared network mode, the back end acts as a Network Addres Translation (NAT) gateway between the guest machine and the external network.[^92] The back end network assigns private IP addresses to the guest machines and performs the translation of network traffic between the guest and the external network (e.g. the Internet).[^93]

To create a shared network using `-netdev`:
```bash
$ -netdev type=user,id=my-shrd-net
```

You can then, connect it to your front end `-device`:
```bash
$ qemu-system-aarch64 -netdev type=user,id=my-shrd-net -device virtio-net-device,netdev=my-shrd-net ...
```

> This is the _default_ network mode in QEMU. It is the easiest to use and it basically _Just Works_™.

### Bridged

In the bridged network mode, the back end is connected directly to the host's physical network interface (e.g. `eth0`). This allows the guest machine to appear as a separate node on the network (e.g. your home network), with its own IP address assigned by the router's DHCP server. The guest can communicate with other nodes on the network and can be accessed by other devices.[^94]

> **Warning (_from [ArchLinux Wiki](https://wiki.archlinux.org/title/QEMU#Tap_networking_with_QEMU)_):** If you bridge together a guest [network] device and some host interface, such as `eth0`, your machines will appear directly on the external network, which will expose them to possible attack. ... a better solution might be to use [Host Only](#host-only) networking mode and set up NAT. 

This mode can be useful if you want:

- **full network access:** Guest machines will have their own IP addresses on the external network, enabling them to communicate with other devices.
- **quickly develop/test drivers:** Guest machine's network `-device` will act like a real NIC. This makes testing drivers or operating systems quick and easy.

To set up a bridged network in QEMU, the process can vary slightly depending on your host OS. Sadly, I won't be explaining that here (due to complexity). I will only give links to other useful guides I found on the internet here for you to follow. Maybe in the future I can expand on them a bit more.

> Reminder, you can always contribute and help me/others <3

#### GNU/Linux

- **extremecoders-re's GitHub Gist:** [Setting up Qemu with a tap interface](https://gist.github.com/extremecoders-re/e8fd8a67a515fee0c873dcafc81d811c)
- **Linux KVM's Documentation:** [Public Bridge](https://www.linux-kvm.org/page/Networking#Public_Bridge)

#### Windows 10/11

- **OpenVPN's TAP Drivers:** [Managing Windows TAP Drivers](https://community.openvpn.net/openvpn/wiki/ManagingWindowsTAPDrivers)

> There seems to be NO ACTUL GUIDES on this. I was not able to found anything useful.. Sorry.

#### macOS 11+ (Big Sur)

- **SoBytes's Article:** [Creating a qemu bridge network on macos](https://www.sobyte.net/post/2022-10/mac-qemu-bridge/)
- **Carl Montari's Article:** [Qemu with Bridged Interfaces on MacOS](https://www.montanari.io/posts/2020/qemu_with_bridged_interfaces_on_macos/)
- **andriytk'S GitHub Gist:** [Configure NAT-network for QEMU on macOS Mojave](https://gist.github.com/andriytk/bd3def8c30cbd474490280436c779027)

### Host Only

In the host-only mode, the back end provides network connectivity **only** between the guest machine and the host machine. The guest machines can communicate with each other and with the host, but they are **isolated** from the external network.

The **isolation** this mode brings is great for security since the guest doesn't have any access to the external network. It is actually **similar** to [Bridged](#bridged) in terms of how it is configured and used. From the [ArchLinux's Wiki](https://wiki.archlinux.org/title/QEMU#Host-only_networking):

> If the bridge is given an IP address and traffic destined for it is allowed,**but no real interface (e.g. `eth0`) is connected to the bridge**, then the virtual machines will be able to talk to each other and the host system. However, they will not be able to talk to anything on the external network, provided that you do not set up IP masquerading on the physical host. This configuration is called [Host Only](#host-only) networking...

This mode can be useful if you want:

- **isolated network environment**: Guest machine(s) does not have access to the external network (e.g. Internet).

The setup is very similar to [Bridged](#bridged). Just follow the instructions there, but do NOT assign an interface to your bridge. After that, you will have host-only networking!

# Combining it All Together

It might be challenging to digest all that QEMU has to offer.. Don't be scared [of it]. The more you use it, the more comfortable you'll feel. Know that the information that we've gone though is A LOT. Pat yourself in the back if you have made this far! Take your time and familiarize yourself with QEMU. And when you fell ready, continue reading.

> If you read this and think that I have made a mistake somewhere or you want me to touch a specific topic PLEASE do so. Any type of feedback (good or bad) is welcome!

Now, it might be hard to know exactly where to start. How do we ACTUALLY start using QEMU? That's the question you probably have right now. Let's answer that and more, together.

## How to actually use QEMU?

Simple answer: Go to this repo's [`/Machines`](https://github.com/TunaCici/QEMU_Starter/tree/main/Machines) folder and start using the scripts there.

Long answer: First ask yourself this: 'Do I really need QEMU or a simple VM?'. Depending on the answer, either use a VM (e.g. VirtualBox) or start configuring your QEMU machine. Let me explain the rest.

### Self-Check

QEMU is cool and a great **tool** to get things done. However, it's NOT a simple and quick virtual machine. Don't get me wrong, it can be a VM if you configure. But the time you spend on that might as well be spent on doing something else, like actually getting things done. So, ask yourself 'Do I really need to use QEMU?'

> Reminder that QEMU is an **excellent** tool to learn new things. So, the question above does not apply to adventurers <3

### Design

Now, after that _boring AF_ talk let's get to work. In the [Configurations](#configurations) part, we have seen that QEMU has lot's of options to configure. And it's great. This means you can have machine that matches most, _if not all_, your needs.

Before you start using QEMU straightaway, **think and design what you want your machine to be**. I can only give some guidance here and not actual steps to follow. Think about these things (in order):

- **OS/Kernel**: Which operating system you want to use? (e.g. GNU/Linux, Windows, Your Own?!)
- **System to emulate**: Which system do you need? (e.g. i368, x86_64, ARM, AARC64, PowerPC)
- **Machine type**: What is your target machine? (e.g. Raspi3, virt, q35, pc, custom)
- **CPU to use**: Do you want to override your machine's CPU? (e.g. host, EPYC, Skylake, Cortex-A72)
- **Core count**: How many CPU cores do you want? (e.g. 2, 4, 8)
- **Memory size**: Amount of memory to allocate. (e.g. 512MiB, 4GiB, 16GiB)
- **Devices to use**: I/O, Display, Storage etc. (e.g. virtio-kbd, qxl-vga, nvme)
- **Networking needs**: What is your network needs? (e.g. simple internet access, custom VLAN)

Although the above list doesn't cover everythings, it is a pretty good way to start desigining your QEMU machine. Remember that, QEMU is a tool (also a great way to learn new stuff). So, decide on your needs and then start designing!

> These are the steps I generally follow before doing something with QEMU. It is totally personal and you might follow a different approach >.<

### Configure

After thinking about what you want from your QEMU machine, you can launch your QEMU machine simply by running a series of `commands` and `arguments`. However, I, _and many others,_ highly suggest you to **create a launch script**. It doesn't need to be something exotic and 'professional'. Just write your commands there and start it from the terminal.

### Launch Scripts

I hear you asking, "There are too many arguments. Which one should I write first?". The thing is, it does not matter. You may specify your `-cpu` last or first. QEMU does not care. BUT! I suggest you to type the **most general** ones first and others last. Let me give you an example script.

```bash
#/usr/bin/env bash

qemu-system-x86_64 -machine virt -cpu virt -m 4G -device usb-kbd -device usb-mouse
```

You can see that I specified the `-machine` option first as it is a more general option. Then, I specify things like `-memory` size and `-device`s to use. I suggest that you do the same, since it is more intuitive and easy to follow.

An even better way to do things would be to define shell varibles. Instead of just cramping everything into a one giant command, use variables. Here's an example.

```bash
#/usr/bin/env bash

MACHINE="-machine virt"
CPU="-cpu virt"
MEMORY="-m 4G"
DEVICES="-device usb-kbd -device usb-mouse"

qemu-system-x86_64 ${MACHINE} ${CPU} ${MEMORY} ${DEVICES} $*
```

See that I define everything inside variables. This way I can just define a new `-device` or change my `-m` size without modifying the _giant-ass_ launch command. Note that the last argument `$*` is a [special shell variable](https://www.javatpoint.com/shell-script-parameters) that passes all the command-line arguments to the QEMU as a single string. (e.g. In `./launch_qemu.sh <args>`, the `$*` will evaluate to `<args>`)

> Again, this is what I do to configure my QEMU and create a launch script. It is personal and you may want to use something else. It's totaly okay! Go wild.

The reasons I want you to use a **launch script** and **shell variables** is this. Look at the below command:

```bash
/Applications/UTM.app/Contents/XPCServices/QEMUHelper.xpc/Contents/MacOS/QEMULauncher.app/Contents/MacOS/QEMULauncher /Applications/UTM.app/Contents/Frameworks/qemu-aarch64-softmmu.framework/Versions/A/qemu-aarch64-softmmu -L /Applications/UTM.app/Contents/Resources/qemu -S -qmp tcp:127.0.0.1:4000,server,nowait -nodefaults -vga none -spice unix=on,addr=/Users/BestUserNameLeft/Library/Group Containers/WDNLXAD4W8.com.utmapp.UTM/C6D43025-8BF5-4B87-A5F5-A8155C6B9DBE.spice,disable-ticketing=on,image-compression=off,playback-compression=off,streaming-video=off,gl=off
 -device virtio-ramfb -cpu host -smp cpus=4,sockets=1,cores=4,threads=1 
 -machine virt, -accel hvf -accel tcg,thread=multi,tb-size=1536 -drive if=pflash,format=raw,unit=0,file=/Applications/UTM.app/Contents/Resources/qemu/edk2-aarch64-code.fd,readonly=on -drive if=pflash,unit=1,file=/Users/BestUserNameLeft/Library/Containers/com.utmapp.UTM/Data/Documents/Windows.utm/Images/efi_vars.fd 
 -boot menu=on -m 6144 -device intel-hda -device hda-duplex -name Windows -device nec-usb-xhci,id=usb-bus -device usb-tablet,bus=usb-bus.0 -device usb-mouse,bus=usb-bus.0 
 -device usb-kbd,bus=usb-bus.0 -device qemu-xhci,id=usb-controller-0 -chardev spicevmc,name=usbredir,id=usbredirchardev0 -device usb-redir,chardev=usbredirchardev0,id=usbredirdev0,bus=usb-controller-0.0 -chardev spicevmc,name=usbredir,id=usbredirchardev1 -device usb-redir,chardev=usbredirchardev1,id=usbredirdev1,bus=usb-controller-0.0 -chardev spicevmc,name=usbredir,id=usbredirchardev2 -device usb-redir,chardev=usbredirchardev2,id=usbredirdev2,bus=usb-controller-0.0 -device nvme,drive=drive0,serial=drive0,bootindex=0 
 -drive if=none,media=disk,id=drive0,file=/Users/BestUserNameLeft/Library/Containers/com.utmapp.UTM/Data/Documents/Windows.utm/Images/windows-11-arm64.qcow2,discard=unmap,detect-zeroes=unmap -device usb-storage,drive=cdrom0,removable=true,bootindex=1,bus=usb-bus.0 -drive if=none,media=cdrom,id=cdrom0 -device virtio-net-pci,mac=9E:E1:25:9D:E7:99,netdev=net0 -netdev vmnet-bridged,id=net0,ifname=en0 -device virtio-serial -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 -
 chardev spicevmc,id=vdagent,debug=0,name=vdagent -device virtserialport,chardev=charchannel1,id=channel1,name=org.spice-space.webdav.0 -chardev spiceport,name=org.spice-space.webdav.0,id=charchannel1 -uuid C6D43025-8BF5-4B87-A5F5-A8155C6B9DBE -rtc base=localtime -device virtio-rng-pci
```

It is crazy right?! This is the default QEMU command that is used by [UTM](https://mac.getutm.app). It looks complicated and hard to follow. Yes it is efficient, as in it is one-line. But, it is very hard for humans to underrstand and change something. That's why you, _hopefuly a human being_, need to have an easy-to-understand **launch script**.

> By the way, [UTM](https://mac.getutm.app) is an amazing thing. You can use it to create pure QEMU machine very easily. It is a great way to learn how complex QEMU machines are configured!

As for you, I have created some example launch scripts that I personally use. Check out the [`/Machines`](https://github.com/TunaCici/QEMU_Starter/tree/main/Machines) folder to explore them! There is a `README` for you to use as a quick-start. Feedback is always appreciated 💚!

# Shortcuts & Key Bindings

QEMU defines some shortcuts for you to control the guest machine. Here are some of the ones I found to be useful.

> When launched with a display windows, QEMU offers some basic controls on the taskbar. Be sure to check that out as well.

- **Release mouse (Display only):** GNU/Linux & Windows: `CTRL + ALT + G`, macOS: `control + option + G`
- **Switch to guest (Display only)** GNU/Linux & Windows: `CTRL + ALT + 1`, macOS: `control + option + 1`
- **Switch to QEMU Monitor (Display only)** GNU/Linux & Windows: `CTRL + ALT + 2`, macOS: `control + option + 2`
- **Toggle between guest & QEMU Monitor (`-nographic` only)** All systems: `CTRL + A` then `C`
- **Terminate machine (`-nographic` only):** All systems: `CTRL + A` then `X`

> QEMU Monitor is an amazing feature that QEMU offers. It is an advanced topic that is targeted to developers. For this reasons, I won't be explaining it here. Maybe down the road I will... If you are really curious, check out the official documentation [QEMU Monitor](https://qemu-project.gitlab.io/qemu/system/monitor.html).

# Example VM-1: ArchLinux

ArxhLinux is a simple and lightweight Linux distribution which follows a rolling release-model for it's packages.[^95]. The official wiki has an amazing [Installation guide](https://wiki.archlinux.org/title/Installation_guide) that I suggest anyone who is interested to at least check out.

I will be explaining how to build a very simple QEMU _ArxhLinux x86_64_ virtual machine on my ArchLinux host machine (/w `Intel i5 6600K`). This is not a through step-by-step tutorial and you can just deviate anytime you want.

> This machine can be found at [`/Machines`](https://github.com/TunaCici/QEMU_Starter/tree/main/Machines) as a basic shell script.

**Step 1 - Acquire an installation image**

The 'best' place is Arch Linux's [Downloads](https://archlinux.org/download/) page. 

Alternatively use `wget`:
```bash
$ wget https://geo.mirror.pkgbuild.com/iso/2023.06.01/archlinux-2023.06.01-x86_64.iso
```

**Step 2 - Design a QEMU machine**

Here are the basic machine specs I have decided to use:

- Machine: `q35`
- CPU: `host`
- vCORE: `2`
- Accelerator: `KVM`
- Memory: `4G`
- UEFI/BIOS: `edk2`
- I/O: `usb-ehci, usb-kbd, usb-mouse`
- Network (Front end): `virtio-net-device`
- Network (Back end): `user`
- Storage: `nvme`
- Display: `virtio-gpu`,
- Sound: `intel-hda` and `hda-duplex`
- Drive-1: `cdrom` (for the installation image)
- Drive-2: `qcow2` size of `32G` (for the `nvme` storage)

**Step 3 - Launch the machine**

To simplify things I am gonna define some path variables. The `EFI_FLASH_PATH` and `EFI_VARS_PATH` are your UEFI firmware and variables files. (e.g. `/usr/share/edk2-ovmf/x64/QEMU.fd`). The `ISO_PATH` is the installation image you acquired from _Step 1_. And the `DISK_PATH` is the disk image that you create using `qemu-img`. Don't forget define these variables before running the command below.

Run the following command (append `-nographic` if you want no display):
```bash
$ qemu-system-x86_64 -machine q35 -cpu host -smp 2 -accel kvm -m 4G -drive if=pflash,format=raw,readonly=on,file=${EFI_FLASH_PATH} -drive if=pflash,format=raw,file=${EFI_VARS_PATH} -device usb-ehci -device usb-kbd -device usb-mouse -device virtio-net-device,netdev=net0 -netdev user,id=net0 -device nvme,drive=hd0,serial=super-fast-boi -device virtio-gpu,xres=1280,yres=720 -device intel-hda -drive id=cd0,media=cdrom,file=${ISO_PATH} -drive id=hd0,if=none,format=qcow2,file=${DISK_PATH}
```

![ArchLinux Starting](/Media/arch_grub_screen.png)

**Common Problem 1:** Could not access KVM kernel module: No such file or directory

This error eccours when your host machine does not have the KVM kernel module loaded. There are copule of reasons for that:

- a) The Linux kernel is not built with KVM.
- b) `Intel VT-x` or `AMD-V` is not enabled in the UEFI settings.
- c) Your CPU does not supports hardware virtualization.

To fix this refer to [Hardware Acceleration (Optional)](#hardware-acceleration-optional). Or si

**Common Problem 2:** UEFI Shell Appears Instead of the OS/Bootloader

When you first launch a QEMU machine with `EDK2` your firmware settings might be incorrect. This can result in a _boot order_ that you might not want (e.g. OS/Bootloader not launching). To correctly setup your UEFI firmware settings **Press `ESC`** during the first boot screen (a.k.a TianaCore screen). OR **Type `exit`** to the UEFI shell if you are using the `-nographic` option. 

![UEFI Shell](/Media/uefi_shell.png)

On the _UEFI firmware settings_ screen you can customize your boot order OR simply launch a drive. Feel free to explore the settings, you might find something useful to you. 

# Example VM-2: macOS

Creating a QEMU _macOS_ guest machine is a bit tricky. I am nowhere near smrat enough to achieve it. There are also legal considirations as Apple VM's are only supported on Parallels and XCode Virtual Machines. So, I won't be personally explaining how to do that here. Although, it is very much possible to do so.

Check out [Dhiru Kholia's amazing GitHub repository](https://github.com/kholia/OSX-KVM) on how to run _macOS_ on QEMU with KVM. It is an interesting work.


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
[^47]: https://wiki.qemu.org/Features/Q35
[^48]: https://www.qemu.org/docs/master/system/arm/virt.html
[^49]: https://qemu-project.gitlab.io/qemu/system/qemu-cpu-models.html
[^50]: https://en.wikipedia.org/wiki/Symmetric_multiprocessing
[^51]: https://en.wikibooks.org/wiki/QEMU/Devices
[^52]: https://www.oasis-open.org/committees/virtio/
[^53]: https://projectacrn.github.io/latest/developer-guides/hld/virtio-net.html
[^54]: https://www.qemu.org/2021/01/19/virtio-blk-scsi-configuration/
[^55]: https://projectacrn.github.io/latest/developer-guides/hld/virtio-blk.html
[^56]: https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-3200007
[^57]: https://projectacrn.github.io/latest/developer-guides/hld/virtio-console.html
[^58]: https://fedoraproject.org/wiki/Features/VirtioSerial
[^59]: https://en.wikipedia.org/wiki/Network_interface_controller
[^60]: https://learn.microsoft.com/en-us/windows/win32/apiindex/windows-api-list#user-interface
[^61]: https://developer.apple.com/documentation/appkit
[^62]: https://www.gtk.org
[^63]: https://en.wikipedia.org/wiki/AC%2797
[^64]: https://en.wikipedia.org/wiki/Intel_High_Definition_Audio
[^65]: https://computernewb.com/wiki/QEMU/Devices/Sound_cards
[^66]: https://github.com/torvalds/linux/blob/master/sound/pci/hda/hda_intel.c
[^67]: https://qemu-project.gitlab.io/qemu/system/devices/usb.html
[^68]: https://www.linux-kvm.org/page/USB_Host_Device_Assigned_to_Guest
[^69]: https://www.kraxel.org/blog/2018/08/qemu-usb-tips/
[^70]: https://en.wikipedia.org/wiki/NEC
[^71]: https://en.wikipedia.org/wiki/Extensible_Host_Controller_Interface
[^72]: http://www.intel.com/content/www/us/en/io/universal-serial-bus/ehci-specification.html
[^73]: https://en.wikipedia.org/wiki/Media_Transfer_Protocol
[^74]: https://en.wikipedia.org/wiki/Ethernet_over_USB
[^75]: https://www.wacom.com/en-us
[^76]: https://en.wikipedia.org/wiki/BIOS
[^77]: https://en.wikipedia.org/wiki/UEFI
[^78]: https://en.wikipedia.org/wiki/Power-on_self-test
[^79]: https://en.wikipedia.org/wiki/SeaBIOS#Development
[^80]: https://github.com/tianocore/tianocore.github.io/wiki/OVMF
[^81]: https://mac.getutm.app
[^82]: https://kb.parallels.com/4948
[^83]: https://en.wikipedia.org/wiki/VLAN
[^84]: https://wiki.qemu.org/Documentation/Networking#Network_Basics
[^85]: https://en.wikipedia.org/wiki/Proxy_server
[^86]: https://wiki.archlinux.org/title/QEMU#Networking
[^87]: https://wiki.qemu.org/Documentation/Networking#User_Networking_(SLIRP)
[^88]: https://wiki.archlinux.org/title/QEMU#User-mode_networking
[^89]: https://wiki.qemu.org/Documentation/Networking#Tap
[^90]: https://gist.github.com/extremecoders-re/e8fd8a67a515fee0c873dcafc81d811c
[^91]: https://www.linux-kvm.org/page/Networking
[^92]: https://en.wikipedia.org/wiki/Network_address_translation
[^93]: https://wiki.archlinux.org/title/QEMU#User-mode_networking
[^94]: https://wiki.archlinux.org/title/QEMU#Bridged_networking_using_qemu-bridge-helper
[^95]: https://wiki.archlinux.org/title/Arch_Linux
[^96]: Reserved.
[^97]: Reserved.
[^98]: Reserved.
[^99]: https://en.wikipedia.org/wiki/Information_overload
[^100]: https://news.ycombinator.com/item?id=19736528
