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
