DIR := uim
SNAP:= $(DIR)/cl-som-imx7-uim_1.1_all.snap
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
