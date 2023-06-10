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

Intuitively, you want your machines to have a display. In **Step 2** we disabled this behaviour with the `-nographic` option. But, normally QEMU launches with a display. If you have a desktop environment (like many people) you can launch QEMu with a display!

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

Similar to [qemu-system-x86_64](#qemu-system-x86_64), but for the `AARCH64` architecture. Meaning most of the configuration settings between `qemu-system-aarch64` and the `qemu-system-x86_64` will be the same. The only difference is going to be the availability of `-machine` and `-cpu` options.

All of the things in this pseudo-wiki applies to both `qemu-system-aarch64` and `qemu-system-x86_64`. So, you can follow without worrying about which one to use.

> I will make use of both of them throughout this entire pseudo-wiki. But, feel free to use whichever one you prefer!

If you're feeling ready for the main event, let's begin!

[^41]: https://en.wikibooks.org/wiki/QEMU/Monitor
[^42]: https://qemu.readthedocs.io/en/latest/tools/qemu-img.html
[^43]: https://www.qemu.org/docs/master/system/invocation.html
[^44]: https://www.qemu.org/docs/master/system/targets.html
