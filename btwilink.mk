DIR := btwilink
SNAP:= $(DIR)/cl-som-imx7-btwilink_1.1_armhf.snap
OUTPUT_DIR := $(PWD)

all: build

clean: snapclean
	cd $(DIR); snapcraft clean

snapclean:
	rm -f $(SNAP)

$(SNAP):
	cd $(DIR); snapcraft snap

snap:	$(SNAP)
	mv $(SNAP) $(OUTPUT_DIR)

build: snap

.PHONY: build snap clean
