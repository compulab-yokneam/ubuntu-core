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

### Full build

In order to build the whole OS image, you just need to issue the following:
```
~/ubuntu-core$ make
```

The output file should be named `cl-som-imx7.img`.

You can then simply flash it using `pv` and `dd`.

```
~/ubuntu-core$ pv cl-som-imx7.img | sudo dd of=/dev/sdX bs=1M
```

### Gadget build

If you just wish to build the `gadget`:
```
~/ubuntu-core$ make gadget
```

### Kernel build

If you just wish to build the `kernel`:
```
~/ubuntu-core$ make kernel
```

### Image generation

If you re-built the `kernel` or the `gadget` manually, you can simply generate the image:
```
~/ubuntu-core$ make image
```
### Prepare for the very 1-st boot
#### Get core revision version
This command generates a string command that has to get issued in the device U-Boot at the very 1-st device boot.
```
~/ubuntu-core$ awk '(/core/)&&($0="setenv core_rev="$2)' seed.manifest
```
#### Update boot environent
Copy the generated string and paste it while in U-Boot prompt.
```
CL-SOM-iMX7 # setenv core_rev=3323; saveenv
```
Update the device `bootcmd`
```
CL-SOM-iMX7 # setenv bootcmd 'mmc dev 0; load mmc 0 ${loadaddr} boot.scr; source ${loadaddr}'
CL-SOM-iMX7 # saveenv; reset
```
Let the device boot up and evaluate Ubuntu Core.
