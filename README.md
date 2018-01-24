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
CL-SOM-iMX7 # setenv boot_media mmc
CL-SOM-iMX7 # setenv bootcmd 'mmc dev 0; load mmc 0 ${loadaddr} boot.scr; source ${loadaddr}'
CL-SOM-iMX7 # saveenv; reset
```
##### usb
```
CL-SOM-iMX7 # setenv boot_media usb
CL-SOM-iMX7 # setenv bootcmd 'usb start; load usb 0 ${loadaddr} boot.scr; source ${loadaddr}'
CL-SOM-iMX7 # saveenv; reset
```
Let the device boot up and evaluate Ubuntu Core.

### A known build issue
#### [Snapcraft issue during initrd driver generation](https://bugs.launchpad.net/snapcraft/+bug/1739400)
#### Fix
```
--- /usr/lib/python3/dist-packages/snapcraft/plugins/kernel-orig.py	2018-01-12 11:15:04.330170492 +0200
+++ /usr/lib/python3/dist-packages/snapcraft/plugins/kernel.py	2018-01-12 11:16:39.941153876 +0200
@@ -237,7 +237,7 @@

         with tempfile.TemporaryDirectory() as temp_dir:
             subprocess.check_call([
-                'unsquashfs', self.os_snap, os.path.dirname(initrd_path)],
+                'unsquashfs', self.os_snap, os.path.dirname(initrd_path), 'boot'],
                 cwd=temp_dir)

             tmp_initrd_path = os.path.join(
```
