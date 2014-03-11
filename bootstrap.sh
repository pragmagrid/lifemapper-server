#!/bin/bash
#
# Build and install prerequisites for compiling lmserver dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# add dynamic libs
echo "/usr/java/latest/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/usr/java/latest/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

# yum repo for postgresql and postgis2 rpms
rpm -i src/RPMS/pgdg-centos91-9.1-4.noarch.rpm

# yum repo and vera fonts for mapserver
yum --enablerepo base install cmake
rpm -i src/RPMS/elgis-release-6-6_0.noarch.rpm 
rpm -i src/RPMS/bitstream-vera-fonts-common-1.10-18.el6.noarch.rpm
rpm -i src/RPMS/bitstream-vera-sans-fonts-1.10-18.el6.noarch.rpm

# for PyLucene 
compile ant
install lifemapper-ant
export ANT_HOME=/opt/lifemapper
(cd src/pylucene;  make install_jcc)

# for pytables 
compile cython 
install opt-cython 
compile numexpr 
install opt-numexpr 
yum --enablerepo rpmforge install hdf5 hdf5-devel

# for psycopg2
compile gdal
install lifemapper-gdal
/sbin/ldconfig

# for mysql-python and rtree
compile setuptools
install opt-setuptools

# for rtree
compile spatialindex
install lifemapper-spatialindex
/sbin/ldconfig

# install postgresql91
yum install postgresql91
yum install postgresql91-devel

