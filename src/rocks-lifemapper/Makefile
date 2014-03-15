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

SEDSPEC += \
        -e 's%@LMHOME@%$(LMHOME)%g' \
        -e 's%@MAPSERVER_TMP@%$(MAPSERVER_TMP)%g' \
        -e 's%@LMWEB@%$(LMWEB)%g' \
        -e 's%@PGSQL@%$(PGSQL)%g' \
        -e 's%@PYTHONVER@%$(PYTHONVER)%g' \
        -e 's%@MYSQLDB@%$(MYSQLDB)%g' \
        -e 's%@PKGROOT@%$(PKGROOT)%g'

SCRIPTS = \
	lifemapper.conf \
	lifemapper.sh  \
	lifemapper.csh  \
	lmserver_init \
	lmweb_init  \
	db_init  \
	buildLmLuceneIndex \
	lucene.cron \
	lifemapper-server.conf

PYFILES = __init__.py confconst.py  confbase.py
PYSCRIPTS = confPgbouncer confPostgres  confUsers 

lifemapper.conf: lifemapper.conf.in
	$(SED) $(SEDSPEC) $^ > $@

lifemapper.sh: lifemapper.sh.in
	$(SED) $(SEDSPEC) $^ > $@

lifemapper.csh: lifemapper.csh.in
	$(SED) $(SEDSPEC) $^ > $@

lmserver_init: lmserver_init.in
	$(SED) $(SEDSPEC) $^ > $@

lmweb_init: lmweb_init.in
	$(SED) $(SEDSPEC) $^ > $@

db_init: db_init.in
	$(SED) $(SEDSPEC) $^ > $@

buildLmLuceneIndex: buildLmLuceneIndex.in
	$(SED) $(SEDSPEC) $^ > $@

lucene.cron: lucene.cron.in
	$(SED) $(SEDSPEC) $^ > $@

lifemapper-server.conf: lifemapper-server.conf.in
	$(SED) $(SEDSPEC) $^ > $@

build: $(SCRIPTS)
	
install::

	mkdir -p $(ROOT)/etc/profile.d
	install -m 755 lifemapper.sh $(ROOT)/etc/profile.d
	install -m 755 lifemapper.csh $(ROOT)/etc/profile.d

	mkdir -p $(ROOT)/etc/sysctl.d
	install -m 644 postgresd $(ROOT)/etc/sysctl.d

	mkdir -p $(ROOT)/etc/httpd/conf.d
	install -m 644 lifemapper.conf $(ROOT)/etc/httpd/conf.d

	mkdir -p $(ROOT)/etc/ld.so.conf.d
	install -m 644 lifemapper-server.conf $(ROOT)/etc/ld.so.conf.d

	mkdir -p $(ROOT)/$(PKGROOT)/rocks/bin
	install -m 755 lmserver_init $(ROOT)/$(PKGROOT)/rocks/bin
	install -m 755 lmweb_init $(ROOT)/$(PKGROOT)/rocks/bin
	install -m 755 db_init $(ROOT)/$(PKGROOT)/rocks/bin
	install -m 755 buildLmLuceneIndex $(ROOT)/$(PKGROOT)/rocks/bin
	install -m 755 $(PYSCRIPTS) $(ROOT)/$(PKGROOT)/rocks/bin
	install -m 644 $(PYFILES) $(ROOT)/$(PKGROOT)/rocks/bin

	mkdir -p $(ROOT)/$(PKGROOT)/rocks/etc
	install -m 644 lucene.cron $(ROOT)/$(PKGROOT)/rocks/etc

	mkdir -p $(ROOT)/$(PKGROOT)/rocks/sql
	install -m 644 postgis.sql $(ROOT)/$(PKGROOT)/rocks/sql 
	install -m 644 roles.sql $(ROOT)/$(PKGROOT)/rocks/sql/roles.sql.template

clean::
	rm -rf version.mk $(SCRIPTS)
	rm -rf *.pyc 
