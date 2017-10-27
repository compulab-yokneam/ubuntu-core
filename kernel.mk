BRANCH := v4.1.15-cl-som-imx7-4.0
SRC_URI := https://github.com/compulab-yokneam/cl-som-imx7.git
DIR := kernel
KERNEL := $(DIR)/cl-som-imx7
RAMDISK:= $(DIR)/prime/ramdisk.img 
INITRD:= $(DIR)/prime/initrd.img
SNAP:= $(DIR)/cl-som-imx7-kernel_4.1.15-1_armhf.snap
OUTPUT_DIR := $(PWD)

all: build

clean: snapclean
	cd $(DIR); snapcraft clean kernel -s pull

ramclean:
	if [ -f $(RAMDISK) ]; then \
	dd if=$(RAMDISK) of=$(INITRD) skip=64 bs=1; \
	rm -rf $(RAMDISK); \
	fi
	
snapclean:
	rm -f $(SNAP)

$(SNAP):
	cd $(DIR); snapcraft --target-arch armhf snap
	
$(RAMDISK):
	mkimage -A arm -O Linux -T ramdisk -d $(INITRD) $(RAMDISK)
	cp $(RAMDISK) $(INITRD)

ramdisk: $(RAMDISK) snapclean
	cd $(DIR); snapcraft --target-arch armhf snap

snap:	$(SNAP) ramdisk
	mv $(SNAP) $(OUTPUT_DIR)

build: snap

.PHONY: build snap clean
