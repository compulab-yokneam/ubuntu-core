# Ubuntu Core

This repository contains every needed to build your own Snappy Ubuntu Core OS image for **CompuLab cl-som-imx7** platforms.

## Prebuit image
Please try a prebult image prior to creating the entire buld environment.
A prebuld image location is at:  [ubuntu-core-bin](https://github.com/compulab-yokneam/ubuntu-core-bin/tree/master#ubuntu-core-bin)

## Build requirements

First of all, it is highly recommended to build from **Ubuntu 16.04** or later. Although there are solutions for different OS flavours, some tools are limited to Ubuntu for now.

Then you need to install the following packages in order to build Ubuntu Core.
```
~$ sudo apt update
~$ sudo apt install -y build-essential u-boot-tools lzop gcc-arm-linux-gnueabihf pv
~$ sudo apt install -y snap snapcraft
~$ sudo snap install ubuntu-image --devmode --edge
```

You can check that the `snap` is working on your host machine by listing the available packages:
```
~$ snap list
Name          Version             Rev   Developer  Notes
core          16-2.28.5           3247  canonical  core
ubuntu-image  1.1+snap3           78    canonical  classic
```

## Build procedure

### Getting the source code

Simply clone this repository:
```
~$ git clone https://github.com/compulab-yokneam/ubuntu-core.git
~$ cd ubuntu-core
```

### [Create device model file](./model#model-assertion)

### Full build

In order to build the whole OS image, just issue the following:
```
~/ubuntu-core$ make
```
The output file should be named `cl-som-imx7.img`.

### Fix `core` revision number
```
~/ubuntu-core$ make fix
```

### Create bootable media
Supported devices: `sd/mmc` `usb`

Make use of `pv` and `dd` in order to flash the image onto a boot device

```
~/ubuntu-core$ pv cl-som-imx7.img | sudo dd of=/dev/sdX bs=1M
```

### Prepare for the very 1-st boot
#### Update the device `bootcmd`
##### sd/mmc
```
setenv boot_media mmc; setenv dev 0
setenv bootcmd 'mmc dev ${dev}; load mmc ${dev} ${loadaddr} boot.scr; source ${loadaddr}'
saveenv; reset
```
##### usb
```
setenv boot_media usb
setenv bootcmd 'usb start; load usb 0 ${loadaddr} boot.scr; source ${loadaddr}'
saveenv; reset
```
### How to install the image onto the eMMC
#### Prerequirements 
* Prepare an `NFS` server with a `configured NFS export`.
* Copy the `cl-som-imx7.img` into the `configured NFS export`.
* Make sure that the `cl-som-imx7` device and the `NFS server` connsected to the same `LAN`.
* Make use of the 1-st NIC of the `CompuLab SB-SOM` board. It is the `P21` connector.
#### Make the device bootup onto the `initramfs`
```
setenv core_rev 1234; setenv boot_media mmc; setenv dev 0
mmc dev ${dev}; load mmc ${dev} ${loadaddr} boot.scr; source ${loadaddr}
```
* As soon as `(initramfs)` turns out, issue:
```
dhclient eth0
mkdir /media
mount -o nolock nfs-server-ip:/path/to/nfs-export /media
dd if=/media/cl-som-imx7.img of=/dev/mmcblk2
```
* Wait for the `dd` success status with information about coppied blocks:
```
1048576+0 records in
1048576+0 records out
```
* Reboot the devie & stop in `U-Boot`.
* Update the device `bootcmd`:
```
setenv boot_media mmc; setenv dev 1
setenv bootcmd 'mmc dev ${dev}; load mmc ${dev} ${loadaddr} boot.scr; source ${loadaddr}'
saveenv; reset
```

Let the device boot up and evaluate Ubuntu Core.

### Install snap packages
#### Docker
```
sudo snap install docker
```
#### BlueZ
```
sudo snap install bluez
```
#### CompuLab packages
* Copy the packages files to the device: cl-som-imx7-btwilink_1.1_all.snap, cl-som-imx7-uim_1.1_all.snap
* Use the following commands for installation:
```
sudo snap install cl-som-imx7-btwilink_1.1_all.snap --devmode
sudo snap install cl-som-imx7-uim_1.1_all.snap --devmode
```
### Validate installed snap packages
* Issue `snap list` in order to display a summary of snaps installed in the current system:
```
snap list
Name                  Version     Rev   Tracking  Publisher   Notes
bluez                 5.47-3      167   stable    canonical✓  -
cl-som-imx7-btwilink  1.1         x1    -         -           devmode
cl-som-imx7-gadget    16.04-1     x1    -         -           gadget
cl-som-imx7-kernel    4.9.11-1    x1    -         -           kernel
cl-som-imx7-uim       1.1         x1    -         -           devmode
core                  16-2.39.3   7274  stable    canonical✓  core
core18                20190709    1069  stable    canonical✓  base
docker                18.06.1-ce  387   stable    canonical✓  -
snapd                 2.39.2      3652  stable    canonical✓  snapd

```
