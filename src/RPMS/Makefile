#
## $Id$
#
## @Copyright@
## @Copyright@
#
## $Log$
#
 
REDHAT.ROOT     = $(CURDIR)/../../
MAKE.iscontrib  = 1
-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

NOARCH = noarch

rpm:: build
	-cp *.$(NOARCH).rpm $(REDHAT.RPMS)/$(NOARCH)/
	-cp *.$(ARCH).rpm $(REDHAT.RPMS)/$(ARCH)/

build:
	mkdir -p $(REDHAT.RPMS)/$(NOARCH)/
	mkdir -p $(REDHAT.RPMS)/$(ARCH)/
