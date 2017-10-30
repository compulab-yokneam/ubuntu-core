DIR := kernel
SNAP:= $(DIR)/cl-som-imx7-kernel_4.1.15-1_armhf.snap
OUTPUT_DIR := $(PWD)

all: build

clean: snapclean
	cd $(DIR); snapcraft clean

snapclean:
	rm -f $(SNAP)

$(SNAP):
	cd $(DIR); snapcraft --target-arch armhf snap
	
snap:	$(SNAP)
	mv $(SNAP) $(OUTPUT_DIR)

build: snap

.PHONY: build snap clean
