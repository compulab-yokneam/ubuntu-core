# Ubuntu Core

This repository contains every needed to build your own Snappy Ubuntu Core OS image for **CompuLab cl-som-imx7** platforms.

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
~/ubuntu-core$ IMAGE=cl-som-imx7.img ./tools/fix_image_core
```

### Create bootable media
Make use of `pv` and `dd` in order to flash the image onto an sd/mmc card

```
~/ubuntu-core$ pv cl-som-imx7.img | sudo dd of=/dev/sdX bs=1M
```

### Prepare for the very 1-st boot
#### Update the device `bootcmd`
```
CL-SOM-iMX7 # setenv bootcmd 'mmc dev 0; load mmc 0 ${loadaddr} boot.scr; source ${loadaddr}'
CL-SOM-iMX7 # saveenv; reset
```
Let the device boot up and evaluate Ubuntu Core.
