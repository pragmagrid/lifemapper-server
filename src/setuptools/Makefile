REDHAT.ROOT = $(CURDIR)/../../
-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

version.mk:
	cat ../version.mk version.mk.in > version.mk

PY.PATH = /opt/python/bin/$(PYTHONVER)

SEDSPEC += \
        -e 's%@ARCHIVENAME@%$(ARCHIVENAME)%g'  \
        -e 's%@VERSION@%$(VERSION)%g'

build:
	unzip  $(ARCHIVENAME)-$(VERSION).zip
	(\
        cd $(ARCHIVENAME)-$(VERSION);   \
        module load opt-python;         \
        $(PY.PATH) setup.py build;      \
        module unload opt-python;           \
	)

install::
	(\
        cd $(ARCHIVENAME)-$(VERSION);   \
        module load opt-python;         \
        $(PY.PATH) setup.py $@ --root=$(ROOT)/; \
        module unload opt-python;           \
	)

clean::
	rm -rf $(ARCHIVENAME)-$(VERSION) version.mk

