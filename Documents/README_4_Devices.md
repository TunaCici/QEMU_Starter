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
- `nec-usb-xchi`: Emulates an NEC USB eXtensible Host Controller Interface (xHCI) controller. Supports USB 3.0. [^70][^71]
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
