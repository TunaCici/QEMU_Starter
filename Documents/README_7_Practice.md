**Previous Part** [6. Networking](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_6_Networking.md)

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

- **Release mouse (Display only)** GNU/Linux & Windows: `CTRL + ALT + G`, macOS: `control + option + G`
- **Switch to guest (Display only)** GNU/Linux & Windows: `CTRL + ALT + 1`, macOS: `control + option + 1`
- **Switch to QEMU Monitor (Display only)** GNU/Linux & Windows: `CTRL + ALT + 2`, macOS: `control + option + 2`
- **Toggle between guest & QEMU Monitor (`-nographic` only)** All systems: `CTRL + A` then `C`
- **Terminate machine (`-nographic` only)** All systems: `CTRL + A` then `X`

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

Creating a QEMU _macOS_ guest machine is a bit tricky. I am nowhere near smrat enough to achieve it. There are also legal considirations as Apple VM's are only supported on Parallels and XCode Virtual Machines.[^96] So, I won't be personally explaining how to do that here. Although, it is very much possible to do so.

Check out [Dhiru Kholia's amazing GitHub repository](https://github.com/kholia/OSX-KVM) on how to run _macOS_ on QEMU with KVM. It is an interesting work.

[^95]: https://wiki.archlinux.org/title/Arch_Linux
[^96]: https://developer.apple.com/documentation/virtualization/running_macos_in_a_virtual_machine_on_apple_silicon
