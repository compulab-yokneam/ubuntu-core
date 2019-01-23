DIR := btwilink
SNAP_AMD:= $(DIR)/cl-som-imx7-btwilink_1.1_amd64.snap
SNAP:= $(DIR)/cl-som-imx7-btwilink_1.1_armhf.snap
OUTPUT_DIR := $(PWD)

all: build

clean: snapclean
	cd $(DIR); snapcraft clean

snapclean:
	rm -f $(SNAP)

$(SNAP):
	cd $(DIR); snapcraft snap
	mv $(SNAP_AMD) $(SNAP)

snap:	$(SNAP)
	mv $(SNAP) $(OUTPUT_DIR)

build: snap

.PHONY: build snap clean
