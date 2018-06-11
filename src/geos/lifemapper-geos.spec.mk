# This file is called from the generated spec file.
# It can also be used to debug rpm building.
# 	make -f lifemapper-geos.spec.mk build|install

ifndef __RULES_MK
build:
	make ROOT=/state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.buildroot build

install:
	make ROOT=/state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.buildroot install
endif
