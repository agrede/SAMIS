PACKAGE = SAMISGUI
VERSION = 1.2.0
RELEASE_DIR = ../bin
SOURCE_DIR = .
MAIN_FILE = $(SOURCE_DIR)/samis_gui.m

FILES = `./octdep.pl samis_gui.m` \
	$(SOURCE_DIR)/constants/master.json \
	$(SOURCE_DIR)/materialStacks/rapptureDefault.json

all:

install:
	for i in $(FILES) ; do \
	  cp $$i $(RELEASE_DIR) ; \
	done

clean:
