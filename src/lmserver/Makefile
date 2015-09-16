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
        -e 's%@COMMIT_HASH@%$(COMMIT_HASH)%g' \
        -e 's%@REPONAME@%$(REPONAME)%g' \
	-e 's%@LMUSER@%$(LMUSER)%g' \
        -e 's%@DATASOURCE@%$(DATASOURCE)%g' \
        -e 's%@ALGORITHMS@%$(ALGORITHMS11)%g' \
        -e 's%@MODEL_SCENARIO@%$(MODEL_SCENARIO)%g' \
        -e 's%@PROJECTION_SCENARIOS@%$(PROJECTION_SCENARIOS)%g' \
        -e 's%@SCENARIO_PACKAGE@%$(SCENARIO_PACKAGE)%g'

SCRIPTS = buildLmLuceneIndex.sh \
          checkLmWeb.cron \
          config.ini \
          deleteOldAnonymous.cron \
          runAllSQLScripts.sql  \
          runUpdateDBScripts.sql \
          lmLucene.py

          
buildLmLuceneIndex.sh: $(REPONAME)/LmWebServer/lucene/buildLmLuceneIndex.sh.in
	$(SED) $(SEDSPEC) $^ > $(REPONAME)/LmWebServer/lucene/$@
	chmod 755 $(REPONAME)/LmWebServer/lucene/buildLmLuceneIndex.sh

checkLmWeb.cron: $(REPONAME)/LmWebServer/scripts/checkLmWeb.cron.in
	$(SED) $(SEDSPEC) $^ > $(REPONAME)/LmWebServer/scripts/$@
	chmod 755 $(REPONAME)/LmWebServer/scripts/checkLmWeb.cron

config.ini: $(REPONAME)/config/config.ini.in
	$(SED) -i $(SEDSPEC) $^ 
	cat $^ > $(REPONAME)/config/$@

deleteOldAnonymous.cron: $(REPONAME)/LmDbServer/scripts/deleteOldAnonymous.cron.in
	$(SED) $(SEDSPEC) $^ > $(REPONAME)/LmDbServer/scripts/$@
	chmod 755 $(REPONAME)/LmDbServer/scripts/deleteOldAnonymous.cron

lmLucene.py: $(REPONAME)/LmWebServer/lucene/lmLucene.py.in
	$(SED) $(SEDSPEC) $^ > $(REPONAME)/LmWebServer/lucene/$@

runAllSQLScripts.sql: $(REPONAME)/LmDbServer/dbsetup/runAllSQLScripts.sql.in
	$(SED) $(SEDSPEC) $^ > $(REPONAME)/LmDbServer/dbsetup/$@

runUpdateDBScripts.sql: $(REPONAME)/LmDbServer/dbsetup/runUpdateDBScripts.sql.in
	$(SED) $(SEDSPEC) $^ > $(REPONAME)/LmDbServer/dbsetup/$@


prepSrc.sh: prepSrc.sh.in
	$(SED) $(SEDSPEC) $^ > $@
	chmod 755 $@

prep: prepSrc.sh
	rm -rf version.mk
	make version.mk
	make prepSrc.sh
	./prepSrc.sh

build: 
	tar xzvf $(NAME)-$(COMMIT_HASH).tar.gz  
	make $(SCRIPTS)
	make $(SERVICES)

install::
	mkdir -p $(ROOT)/$(EXPORTDIR)
	mv $(REPONAME)/LmWebServer/test/data/* $(ROOT)/$(EXPORTDIR) 	
	mkdir -p $(ROOT)/$(LMHOME)
	mv $(REPONAME)/*  $(ROOT)/$(LMHOME) 
	
clean::
	rm -rf  $(SCRIPTS)  
	rm -rf  $(REPONAME)
	rm -rf  version.mk prepSrc.sh
