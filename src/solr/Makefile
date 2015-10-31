# $Id$
#
# @Copyright@
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../
-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

EXPORTDIR=$(subst share,state/partition1,$(SOLR_DATA))


SEDSPEC += \
        -e 's%@SOLR_DATA@%$(SOLR_DATA)%g' \
        -e 's%@SOLR_PORT@%$(SOLR_PORT)%g' 

version.mk:
	cat ../version.mk version.mk.in > version.mk

solr.txt: solr.txt.in
	$(SED) $(SEDSPEC) $^ > $@

build: solr.txt

install::
	mkdir -p $(ROOT)/$(SOLRDIR)
	tar -xzf  $(ARCHIVENAME)-$(VERSION).$(TARBALL_POSTFIX)  -C  $(ROOT)/$(SOLRDIR) --strip 1
	mkdir -p $(ROOT)/$(EXPORTDIR)
	mkdir -p $(ROOT)/$(EXPORTDIR)/data
	mkdir -p $(ROOT)/$(EXPORTDIR)/logs
	cp $(ROOT)/$(SOLRDIR)/server/solr/solr.xml $(ROOT)/$(EXPORTDIR)/data
	cat $(ROOT)/$(SOLRDIR)/bin/solr.in.sh solr.txt > $(ROOT)/$(EXPORTDIR)/solr.in.sh
	cat $(ROOT)/$(SOLRDIR)/server/resources/log4j.properties  | sed -e "s#solr.log=.*#solr.log=\$${solr.solr.home}/../logs#" > $(ROOT)/$(EXPORTDIR)/log4j.properties

clean::
	rm -rf $(ARCHIVENAME)-$(VERSION) version.mk solr.txt
