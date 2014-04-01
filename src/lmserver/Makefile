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
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

version.mk:
	cat ../version.mk version.mk.in > version.mk

PY.PATH = /opt/python/bin/$(PYTHONVER)

SEDSPEC += \
        -e 's%@LMHOME@%$(LMHOME)%g' \
        -e 's%@LMWEB@%$(LMWEB)%g' \
        -e 's%@TEMPDIR@%$(TEMPDIR)%g' \
        -e 's%@DATADIR@%$(DATADIR)%g' \
        -e 's%@LMUSER@%$(LMUSER)%g' \
        -e 's%@LMDISK@%$(LMDISK)%g' \
        -e 's%@PYBIN@%$(PY.PATH)%g'

SCRIPTS = buildLmLuceneIndex.cron checkLmWeb.cron deleteOldAnonymous.cron \
          lmconstants.py \
          lmLucene.sh \
          nextProductionUpdateDBChanges.sql 

buildLmLuceneIndex.cron: buildLmLuceneIndex.cron.in
	$(SED) $(SEDSPEC) $^ > $@

deleteOldAnonymous.cron: deleteOldAnonymous.cron.in
	$(SED) $(SEDSPEC) $^ > $@

lmconstants.py: lmconstants.py.in
	$(SED) $(SEDSPEC) $^ > $@

lmLucene.sh: lmLucene.sh.in
	$(SED) $(SEDSPEC) $^ > $@

checkLmWeb.cron: checkLmWeb.cron.in
	$(SED) $(SEDSPEC) $^ > $@

nextProductionUpdateDBChanges.sql: nextProductionUpdateDBChanges.sql.in
	$(SED) $(SEDSPEC) $^ > $@

#hourlyUpdates: hourlyUpdates.cron
#	$(SED) $(SEDSPEC) $^ > $@
#dailyUpdates: dailyUpdates.cron
#	$(SED) $(SEDSPEC) $^ > $@
#weeklyUpdates: weeklyUpdates.cron
#	$(SED) $(SEDSPEC) $^ > $@
#monthlyUpdates: monthlyUpdates.cron
#	$(SED) $(SEDSPEC) $^ > $@
#checkLmWeb: checkLmWeb.cron
#	$(SED) $(SEDSPEC) $^ > $@
#deleteOldAnonymous: deleteOldAnonymous.cron
#	$(SED) $(SEDSPEC) $^ > $@

prep:
	./prepSrc.sh

build: $(SCRIPTS)

install::
	# lmserver source
	mkdir -p $(ROOT)/$(LMHOME)
	tar xzvf  $(ARCHIVENAME)-$(DIST).tar.gz  -C  $(ROOT)/$(LMHOME) --strip=1

	mkdir -p  $(ROOT)/$(LMHOME)/LmWebServer/lucene/
	$(INSTALL) -m755 buildLmLuceneIndex.cron $(ROOT)/$(LMHOME)/LmWebServer/lucene/
	$(INSTALL) -m755 lmLucene.sh $(ROOT)/$(LMHOME)/LmWebServer/lucene/

	mkdir -p  $(ROOT)/$(LMHOME)/LmWebServer/scripts/
	$(INSTALL) -m755 checkLmWeb.cron $(ROOT)/$(LMHOME)/LmWebServer/scripts/
	$(INSTALL) -m755 deleteOldAnonymous.cron $(ROOT)/$(LMHOME)/LmWebServer/scripts/

	mkdir -p  $(ROOT)/$(LMHOME)/LmDbServer/config/
	$(INSTALL) -m644 nextProductionUpdateDBChanges.sql $(ROOT)/$(LMHOME)/LmDbServer/config/

	mkdir -p  $(ROOT)/$(LMHOME)/LmCommon/common
	$(INSTALL) -m644 lmconstants.py $(ROOT)/$(LMHOME)/LmCommon/common

	mkdir -p  $(ROOT)/$(LMHOME)/LmDbServer/populate/
	$(INSTALL) -m644 initCatalog.py $(ROOT)/$(LMHOME)/LmDbServer/populate/


	# cron jobs
	#mkdir -p $(ROOT)/etc/cron.hourly
	#mkdir -p $(ROOT)/etc/cron.daily
	#mkdir -p $(ROOT)/etc/cron.weekly
	#mkdir -p $(ROOT)/etc/cron.monthly
	#$(INSTALL) -m755 hourlyUpdates $(ROOT)/etc/cron.hourly/lifemapper-hourly
	#$(INSTALL) -m755 dailyUpdates $(ROOT)/etc/cron.daily/lifemapper-daily
	#$(INSTALL) -m755 weeklyUpdates $(ROOT)/etc/cron.weekly/lifemapper-weekly
	#$(INSTALL) -m755 monthlyUpdates $(ROOT)/etc/cron.monthly/lifemapper-monthly
	#$(INSTALL) -m755 checkLmWeb $(ROOT)/etc/cron.weekly/lifemapper-checkLmWeb
	#$(INSTALL) -m755 deleteOldAnonymous $(ROOT)/etc/cron.weekly/lifemapper-deleteOldAnonymous

clean::
	rm -rf  $(SCRIPTS) version.mk
	rm -rf  $(ARHIVENAME)
