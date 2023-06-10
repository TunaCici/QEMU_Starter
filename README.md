![QEMU Starter](/Media/qemu_starter_header.png)

# Motivation

You might expect that with the _invention_ of the internet, the access to the information has became extremely easy. Although, it is true that we have _overwhelming_ amount of information available, the ease of access to them is still _pretty bad_.[^1] This is particularly evident when it comes to technical documentation for _complex software systems_ like QEMU. [^2]

The information from the official QEMU documentation and communities like Stack OverFlow is pretty fragmented and _somewhat lacking. It is very hard for someone to just _search for something_ and find the answers. They might have to go through bajillion different pages in order to find what they are looking for. This can be extremely frustrating for the newcomers. I, _for one_ felt this way and wanted to change this by combining all of them here to help others like me. Some might even call this a _guide_ or simply a _pseudo-wiki_.

However, I am well aware that there is a possibility that I might create more _information pollution_ by doing so. For that, I intend to contribute to other _popular_ Wikis like [QEMU Wiki](https://wiki.qemu.org/Main_Page) and [Wikibooks](https://en.wikibooks.org/wiki/QEMU). I know that it is not an _easy task_ but it's worth a shot. (a.k.a #insert-it-aint-much-but-its-honest-work-meme-here)

> **Extremely Important Note:** This pseudo-wiki is intended for beginners and newcomers to QEMU. If you are an advanced user, you might the information here 'not satisfying', 'lacking' and straight up 'wrong'. For those people, I want to remind them that this is a **beginner-friendly** guide and not an advanced one. So, set-up your expectations according to that.

Now, enough formality. Let me start by saying: "This pseudo-wiki welcomes all adventurers seeking knowledge and excitement in the world of QEMU! While it may seem challenging at first, the journey will be worth it [and fun], teaching you valuable lessons along the way <3"

# Quick Access

- [Motivation](#motivation)
- [Quick Access](#quick-access)
- [Terminology](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md#terminology)
- [What is QEMU?](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md#what-is-qemu)
  - [Who is QEMU For?](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md#who-is-qemu-for)
  - [Who is QEMU Not For?](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md#who-is-qemu-not-for)
  - [Emulation](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md#emulation)
  - [Virtualization](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md#virtualization)
- [Requirements](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#requirements)
  - [Main Packages](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#main-packages)
  - [Hardware Acceleration (Optional)](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#hardware-acceleration-optional)
- [Installation](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#installation)
  - [GNU/Linux](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#gnulinux)
  - [Windows 10/11](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#windows-1011)
  - [macOS 11+ (Big Sur)](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_1_Installation.md#macos-11-big-sur)
- [Hello World](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_2_HelloWorld.md#hello-world)
- [Tools/Binaries](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_2_HelloWorld.md#toolsbinaries)
  - [qemu-img](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_2_HelloWorld.md#qemu-img)
  - [qemu-system-x86_64](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_2_HelloWorld.md#qemu-system-x86_64)
  - [qemu-system-aarch64](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_2_HelloWorld.md#qemu-system-aarch64)
- [Configurations](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_3_Basics.md#configurations)
  - [Machine](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_3_Basics.md#machine)
  - [CPU](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_3_Basics.md#cpu)
  - [Memory](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_3_Basics.md#memory)
  - [Disks](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_3_Basics.md#disks)
  - [Devices](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_4_Devices.md#devices)
  - [BIOS \& UEFI](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_5_UEFI-BIOS.md#bios--uefi)
- [Networking](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_6_Networking.md#networking)
  - [Front End](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_6_Networking.md#front-end)
  - [Back End](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_6_Networking.md#back-end)
  - [Modes](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_6_Networking.md#modes)
- [Combining it All Together](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_7_Practice.md#combining-it-all-together)
- [Shortcuts \& Key Bindings](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_7_Practice.md#shortcuts--key-bindings)
- [Example VM-1: ArchLinux](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_7_Practice.md#example-vm-1-archlinux)
- [Example VM-2: macOS](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_7_Practice.md#example-vm-2-macos)

# Getting Started

Everything is split into multiple parts and each of them is isolated from each other. This way, you can just open up the one you need at that moment. The sections are full of references and links for you to follow. If you want to learn more about a specific topic, you can just open it up, explore and come back.

When ready, start here: [0. Introduction](https://github.com/TunaCici/QEMU_Starter/blob/main/Documents/README_0_Intro.md) \
The whole thing is also available as a single AIO file: [All-in-One](https://github.com/TunaCici/QEMU_Starter/blob/main/README_AIO.md)

> Good luck and have fun <3

[^1]: https://en.wikipedia.org/wiki/Information_overload
[^2]: https://news.ycombinator.com/item?id=19736528
