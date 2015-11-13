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
SCRIPTS = solr.txt solr


SEDSPEC += \
        -e 's%@SOLR_DATA@%$(SOLR_DATA)%g' \
        -e 's%@SOLRDIR@%$(SOLRDIR)%g' \
        -e 's%@SOLR_PORT@%$(SOLR_PORT)%g' 

version.mk:
	cat ../version.mk version.mk.in > version.mk

solr.txt: solr.txt.in
	$(SED) $(SEDSPEC) $^ > $@

solr: solr.in
	$(SED) $(SEDSPEC) $^ > $@

build: $(SCRIPTS)

install::
	mkdir -p $(ROOT)/$(SOLRDIR)
	tar -xzf  $(ARCHIVENAME)-$(VERSION).$(TARBALL_POSTFIX)  -C  $(ROOT)/$(SOLRDIR) --strip 1
	mkdir -p $(ROOT)/$(SOLRDIR)/etc
	mkdir -p $(ROOT)/$(EXPORTDIR)/data
	mkdir -p $(ROOT)/$(EXPORTDIR)/logs
	mkdir -p $(ROOT)/etc/rc.d/init.d
	cp $(ROOT)/$(SOLRDIR)/server/solr/solr.xml $(ROOT)/$(EXPORTDIR)/data
	cat $(ROOT)/$(SOLRDIR)/bin/solr.in.sh solr.txt > $(ROOT)/$(SOLRDIR)/etc/solrenv.sh
	cat $(ROOT)/$(SOLRDIR)/server/resources/log4j.properties  | sed -e "s#solr.log=.*#solr.log=\$${solr.solr.home}/../logs#" > $(ROOT)/$(SOLRDIR)/etc/log4j.properties
	$(INSTALL) -m 755 solr $(ROOT)/etc/rc.d/init.d

clean::
	rm -rf $(ARCHIVENAME)-$(VERSION) 
	rm -rf version.mk 
	rm -rf $(SCRIPTS) 
