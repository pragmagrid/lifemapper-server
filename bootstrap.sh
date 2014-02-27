#!/bin/bash

# Create prerequisites for building  lmserver dependencies

. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# add pgdg repo: need for installing postgresql and postgis2 rpms
(cd src/RPMS; rpm -i pgdg-centos91-9.1-4.noarch.rpm)

# for mapserver
yum --enablerepo base install cmake
(cd src/RPMS; \
	rpm -i elgis-release-6-6_0.noarch.rpm; \
	rpm -i bitstream-vera-fonts-common-1.10-18.el6.noarch.rpm; \
	rpm -i bitstream-vera-sans-fonts-1.10-18.el6.noarch.rpm;\
)
echo "/usr/java/latest/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/usr/java/latest/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

# for building PyLucene 
compile_and_install ant
(cd src/pylucene;  make install_jcc)

# for building pytables 
compile_and_install cython 
compile_and_install numexpr 
yum --enablerepo rpmforge install hdf5 hdf5-devel

# for building psycopg
compile_and_install gdal
/sbin/ldconfig
yum install postgresql91

