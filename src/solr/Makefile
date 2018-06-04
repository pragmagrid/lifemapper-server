# $Id$
#
# @Copyright@
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

EXPORTDIR=$(subst share,state/partition1,$(SOLRDATA))
SCRIPTS = solr.txt solr solr-index


SEDSPEC += \
        -e 's%@LMHOME@%$(LMHOME)%g' \
        -e 's%@SOLRDATA@%$(SOLRDATA)%g' \
        -e 's%@SOLRDIR@%$(SOLRDIR)%g' \
        -e 's%@SOLRUSER@%$(SOLRUSER)%g' \
        -e 's%@SOLR_PORT@%$(SOLR_PORT)%g' \
        -e 's%@LMURL@%$(LMURL)%g' \
        -e 's%@ARCHIVENAME@%$(ARCHIVENAME)%g' \
        -e 's%@JTS@%$(JTS)%g' \
        -e 's%@JTSDIR@%$(JTSDIR)%g' \
        -e 's%@TARBALL_POSTFIX@%$(TARBALL_POSTFIX)%g' \
        -e 's%@VERSION@%$(VERSION)%g'

version.mk:
	cat ../version.mk version.mk.in > version.mk

solr.txt: solr.txt.in
	$(SED) $(SEDSPEC) $^ > $@

solr: solr.in
	$(SED) $(SEDSPEC) $^ > $@

solr-index: solr-index.in
	$(SED) $(SEDSPEC) $^ > $@

prepSrc.sh: prepSrc.sh.in
	$(SED) $(SEDSPEC) $^ > $@
	chmod 755 $@

prep: prepSrc.sh
	rm -rf version.mk
	make version.mk
	make prepSrc.sh
	./prepSrc.sh

build: $(SCRIPTS)

install::
	mkdir -p $(ROOT)/$(SOLRDIR)
	tar -xzf  $(ARCHIVENAME)-$(VERSION).$(TARBALL_POSTFIX)  -C  $(ROOT)/$(SOLRDIR) --strip 1 --exclude docs --exclude contrib	

	mkdir -p $(ROOT)/$(EXPORTDIR)/logs

	mkdir -p $(ROOT)/$(EXPORTDIR)/data
	cp $(ROOT)/$(SOLRDIR)/server/solr/solr.xml $(ROOT)/$(EXPORTDIR)/data

	mkdir -p $(ROOT)/$(SOLRDIR)/etc
	cat $(ROOT)/$(SOLRDIR)/bin/solr.in.sh solr.txt | sed -e "s%SOLR_HEAP%#SOLR_HEAP%" \
	    > $(ROOT)/$(SOLRDIR)/etc/solrenv.sh
	cat $(ROOT)/$(SOLRDIR)/server/resources/log4j.properties  | sed -e "s#solr.log=.*#solr.log=\$${solr.solr.home}/../logs#" > $(ROOT)/$(SOLRDIR)/etc/log4j.properties

	mkdir -p $(ROOT)/$(JTSDIR)
	cp  $(JTS)  $(ROOT)/$(JTSDIR)/
   
	mkdir -p $(ROOT)/etc/rc.d/init.d
	$(INSTALL) -m 755 solr $(ROOT)/etc/rc.d/init.d

	mkdir -p $(ROOT)/$(LMHOME)/rocks/bin
	$(INSTALL) -m 755 solr-index  $(ROOT)/$(LMHOME)/rocks/bin

clean::
	rm -rf $(ARCHIVENAME)-$(VERSION) 
	rm -rf version.mk  prepData.sh
	rm -rf $(SCRIPTS) 
