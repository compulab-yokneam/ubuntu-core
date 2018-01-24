GADGET_DIR := gadget
MANIFEST:= snaps.manifest  

all: build

clean:
	rm -rf $(GADGET_DIR)/boot-assets $(GADGET_DIR)/uboot.conf $(GADGET_DIR)/uboot.env

u-boot:
	@if [ ! -d $(GADGET_DIR)/boot-assets ] ; then mkdir $(GADGET_DIR)/boot-assets; fi
	cp $(GADGET_DIR)/boot $(GADGET_DIR)/boot-assets/boot.src
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot script" -d $(GADGET_DIR)/boot $(GADGET_DIR)/boot-assets/boot.scr
	@if [ -f $(MANIFEST) ] ; then \
	awk '(/core/)&&($$0="core_rev="$$2)' $(MANIFEST) > $(GADGET_DIR)/boot-assets/boot.env; \
	fi

preload: u-boot
	mkenvimage -r -s 8192 -o $(GADGET_DIR)/uboot.env $(GADGET_DIR)/uboot.env.in
	@if [ ! -f $(GADGET_DIR)/uboot.conf ]; then ln -s uboot.env $(GADGET_DIR)/uboot.conf; fi

snappy: preload
	snapcraft --target-arch armhf pack gadget

build: u-boot preload snappy

.PHONY: build
