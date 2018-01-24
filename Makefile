GADGETSNAP:= cl-som-imx7-gadget_16.04-1_armhf.snap
KERNELSNAP:= cl-som-imx7-kernel_4.1.15-1_armhf.snap
UIMSNAP:= cl-som-imx7-uim_1.1_armhf.snap
IMAGE:= cl-som-imx7.img

all: build

build: kernel gadget uim image

$(IMAGE): kernel gadget uim
	ubuntu-image -c edge --debug --image-size 512M \
	--extra-snaps snapweb \
	--extra-snaps $(GADGETSNAP) \
	--extra-snaps $(KERNELSNAP) \
	--extra-snaps $(UIMSNAP) \
	model/cl-som-imx7.model 

image: $(IMAGE)

fix:
	bash ./tools/fix_image_core

cleanfiles:
	rm -f $(GADGETSNAP) $(KERNELSNAP) $(UIMSNAP) $(IMAGE)

clean: cleanfiles
	make -f gadget.mk clean
	make -f kernel.mk clean
	make -f uim.mk clean

gadget:
	make -f gadget.mk

kernel:
	make -f kernel.mk

uim:
	make -f uim.mk

.PHONY: build gadget kernel uim clean
