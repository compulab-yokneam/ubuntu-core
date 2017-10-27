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

clean:
	make --debug=b -f gadget.mk clean
	make --debug=b -f kernel.mk clean
	make --debug=b -f uim.mk clean
	rm -f $(GADGETSNAP) $(KERNELSNAP) $(UIMSNAP) $(IMAGE)

gadget:
	make --debug=b -f gadget.mk

kernel:
	make --debug=b -f kernel.mk

uim:
	make --debug=b -f uim.mk

.PHONY: build gadget kernel uim clean
