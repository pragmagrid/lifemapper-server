# $Id$
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.6 (Emerald Boa)
# 		         version 6.1 (Emerald Boa)
# 
# Copyright (c) 2000 - 2013 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

version.mk:
	cat ../version.mk version.mk.in > version.mk

PY.PATH = /opt/python/bin/$(PYTHONVER)
EXPORTDIR=$(subst share,state/partition1,$(DATADIR))/test


SEDSPEC += \
        -e 's%@PKGROOT@%$(PKGROOT)%g' \
        -e 's%@PYBIN@%$(PY.PATH)%g' \
        -e 's%@DATADIR@%$(DATADIR)%g' \
        -e 's%@LMDISK@%$(LMDISK)%g' \
        -e 's%@LMHOME@%$(LMHOME)%g' \
        -e 's%@LMWEB@%$(LMWEB)%g' \
        -e 's%@SMTPSERVER@%$(SMTPSERVER)%g' \
        -e 's%@TEMPDIR@%$(TEMPDIR)%g'  \
        -e 's%@VERSION@%$(VERSION)%g' \
        -e 's%@PATCH_VERSION@%$(PATCH_VERSION)%g' \
        -e 's%@UPDATE_1@%$(UPDATE_1)%g' \
        -e 's%@UPDATE_2@%$(UPDATE_2)%g'

SCRIPTS = buildLmLuceneIndex.sh \
          checkLmWeb.cron \
          config.ini \
          deleteOldAnonymous.cron \
          runAllSQLScripts.sql  \
          runUpdateDBScripts.sql \
          lmLucene.py

          
buildLmLuceneIndex.sh: $(ARCHIVENAME)/LmWebServer/lucene/buildLmLuceneIndex.sh.in
	$(SED) $(SEDSPEC) $^ > $(ARCHIVENAME)/LmWebServer/lucene/$@
	chmod 755 $(ARCHIVENAME)/LmWebServer/lucene/buildLmLuceneIndex.sh

checkLmWeb.cron: $(ARCHIVENAME)/LmWebServer/scripts/checkLmWeb.cron.in
	$(SED) $(SEDSPEC) $^ > $(ARCHIVENAME)/LmWebServer/scripts/$@
	chmod 755 $(ARCHIVENAME)/LmWebServer/scripts/checkLmWeb.cron

config.ini: $(ARCHIVENAME)/config/config.ini.in
	$(SED) -i $(SEDSPEC) $^ 
	cat $^ > $(ARCHIVENAME)/config/$@

deleteOldAnonymous.cron: $(ARCHIVENAME)/LmDbServer/scripts/deleteOldAnonymous.cron.in
	$(SED) $(SEDSPEC) $^ > $(ARCHIVENAME)/LmDbServer/scripts/$@
	chmod 755 $(ARCHIVENAME)/LmDbServer/scripts/deleteOldAnonymous.cron

lmLucene.py: $(ARCHIVENAME)/LmWebServer/lucene/lmLucene.py.in
	$(SED) $(SEDSPEC) $^ > $(ARCHIVENAME)/LmWebServer/lucene/$@

runAllSQLScripts.sql: $(ARCHIVENAME)/LmDbServer/dbsetup/runAllSQLScripts.sql.in
	$(SED) $(SEDSPEC) $^ > $(ARCHIVENAME)/LmDbServer/dbsetup/$@

runUpdateDBScripts.sql: $(ARCHIVENAME)/LmDbServer/dbsetup/runUpdateDBScripts.sql.in
	$(SED) $(SEDSPEC) $^ > $(ARCHIVENAME)/LmDbServer/dbsetup/$@


prepSrc.sh: prepSrc.sh.in
	$(SED) $(SEDSPEC) $^ > $@
	chmod 755 $@

prep: prepSrc.sh
	rm -rf version.mk
	make version.mk
	./prepSrc.sh

build: 
	tar xzvf $(NAME)-$(VERSION).tar.gz  
	make $(SCRIPTS)
	make $(SERVICES)

install::
	mkdir -p $(ROOT)/$(EXPORTDIR)
	mv $(ARCHIVENAME)/LmWebServer/test/data/* $(ROOT)/$(EXPORTDIR) 	
	mkdir -p $(ROOT)/$(LMHOME)
	rm -rf $(ARCHIVENAME)/svn-info
	mv $(ARCHIVENAME)/*  $(ROOT)/$(LMHOME) 
	
clean::
	rm -rf  $(SCRIPTS)  
	rm -rf  $(ARCHIVENAME)
	rm -rf  version.mk prepSrc.sh
