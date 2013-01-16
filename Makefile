###############################
# Makefile for Tsar 
#
# Last Modified: 4-15-2010
###############################


# Source code directories
SRC_BASE=./src/
SRC_INCLUDE=./include/

all:	
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..

	@echo ""
	@echo "*** Compile finished ***"
	@echo ""
	@echo "If the compile finished without any errors, you should"
	@echo "find client and server binaries in the src/ subdirectory."
	@echo ""

nsca:
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..

send_nsca:
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..

install:
	@echo ""
	@echo "Read the README file for information on installing the"
	@echo "client and server binaries."
	@echo ""

clean:
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..
	rm -f core
	rm -f *~ */*~

