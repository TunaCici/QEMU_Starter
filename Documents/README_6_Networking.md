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

Most of the time it is enough to just use `user`. It is enabled by default and you don't have to do many configurations to use it.[^88] However, according to the official [QEMU documentations](<https://wiki.qemu.org/Documentation/Networking#User_Networking_(SLIRP)>), it has the following limitations:

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

> This is the _default_ network mode in QEMU. It is the easiest to use and it basically *Just Works*™.

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
