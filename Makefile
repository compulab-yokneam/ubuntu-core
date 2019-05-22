GADGETSNAP:= cl-som-imx7-gadget_16.04-1_armhf.snap
KERNELSNAP:= cl-som-imx7-kernel_4.9.11-1_armhf.snap
UIMSNAP:= cl-som-imx7-uim_1.1_all.snap
BTWILINKSNAP:= cl-som-imx7-btwilink_1.1_all.snap
IMAGE:= cl-som-imx7.img

all: build

build: kernel gadget uim btwilink image

$(IMAGE): kernel gadget uim btwilink
	ubuntu-image snap --debug --image-size 512M \
	--snap $(GADGETSNAP) \
	--snap $(KERNELSNAP) \
	model/cl-som-imx7.model 

image: $(IMAGE)

fix:
	bash ./tools/fix_image_core

cleanfiles:
	rm -f $(GADGETSNAP) $(KERNELSNAP) $(UIMSNAP) $(BTWILINKSNAP) $(IMAGE)

clean: cleanfiles
	make -f gadget.mk clean
	make -f kernel.mk clean
	make -f uim.mk clean
	make -f btwilink.mk clean

gadget:
	make -f gadget.mk

kernel:
	make -f kernel.mk

uim:
	make -f uim.mk

btwilink:
	make -f btwilink.mk

.PHONY: build gadget kernel uim btwilink clean
