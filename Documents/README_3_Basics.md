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

Additionally, you can set some CPUID feature flags. Each CPU has different features that can be enabled/disabled. The `code snippet` at the start will also list all available CPUID flags. For example, to define a `Intel Core i7-8700K` CPU with `AVX (Advanced Vector Extensions)` use:

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

- **General Drive (SSD/HDD):** Use this type for large storage devices. (e.g. Install OS, Backup files)
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

[^45]: https://qemu-project.gitlab.io/qemu/system/device-emulation.html
[^46]: https://blogs.oracle.com/linux/post/introduction-to-virtio
[^47]: https://wiki.qemu.org/Features/Q35
[^48]: https://www.qemu.org/docs/master/system/arm/virt.html
[^49]: https://qemu-project.gitlab.io/qemu/system/qemu-cpu-models.html
[^50]: https://en.wikipedia.org/wiki/Symmetric_multiprocessing
