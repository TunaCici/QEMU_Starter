# Motivation

You might expect that with the _invention_ of the internet, the access to the information has became extremely easy. Although, it is true that we have _overwhelming_ amount of information available, the ease of access to them is still _pretty bad_.[^99] This is particularly evident when it comes to technical documentation for _complex software systems_ like QEMU. [^100]

The information from the official QEMU documentation and communities like Stack OverFlow is pretty fragmented and _somewhat lacking. It is very hard for someone to just \_search for something_ and find the answers. They might have to go through bajillion different pages in order to find what they are looking for. This can be extremely frustrating for the newcomers. I, _for one_ felt this way and wanted to change this by combining all of them here to help others like me. Some might even call this a _guide_ or simply a _pseudo-wiki_.

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
  - [Front End](#front-end)
  - [Back End](#back-end)
  - [Modes](#modes)
- [Combining it All Together](#combining-it-all-together)
- [Shortcuts \& Key Bindings](#shortcuts--key-bindings)
- [Example VM-1: ArchLinux](#example-vm-1-archlinux)
- [Example VM-2: macOS](#example-vm-2-macos)

# Getting Started

Everything is split into multiple parts and each of them is isolated form each other. This way, you can just open up the one you need at that moment. The sections are full of references and links for you to follow. If you want to learn more about a specific topic, you can just open it up, explore and come back. 

When ready, start here: <GH_LINK_HERE>

The whole thing is also available as a single AIO file: <GH_LINK_HERE>

> Good luck and have fun <3

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
