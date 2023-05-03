# QEMU_Starter
Guides, tutorials and example scripts that aims to help new QEMU users.

# Requirements
Each Architecture, OS or Distro has its own requirements.

## macOS 13.0 (Ventura)
 ```bash
$ brew install qemu
```

## GNU/Linux - Debian (ARM64)
```bash
$ sudo apt install qemu qemu-efi-aarch64
```
## GNU/Linux - Debian (x86_64)
```bash
file @TODO: Find it. 
```

# UEFI Locations
Possible locations for EFI files on AARCH64 and x86_64 systems.

## macOS 13.0 (Ventura)
```bash
$ file /opt/homebrew/Cellar/qemu/*.*/share/qemu/edk2-aarch64-code.fd 
```

## GNU/Linux - Debian (ARM64)
```bash
$ file /usr/share/qemu-efi-aarch64/QEMU_EFI.fd
```

## GNU/Linux - Debian (x86_64)
```bash
file @TODO: Find it. 
```

