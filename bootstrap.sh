#!/bin/bash
#
# Build and install prerequisites for compiling lmserver dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# enable elgis repo, need for map server
(cd src/RPMS; 
ELGISREPO=elgis-release-6-6_0.noarch.rpm
wget  http://elgis.argeo.org/repos/6/$ELGISREPO
rpm -i $ELGISREPO
)

# enable repo for postgresql and postgis2 rpms
(cd src/RPMS; 
PGDGREPO=pgdg-centos91-9.1-4.noarch.rpm
wget http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/$PGDGREPO
rpm -i $PGDGREPO
)

# download needed RPMS
(cd src/RPMS; 
yumdownloader --resolve --enablerepo elgis mapserver.x86_64; \
yumdownloader --resolve --enablerepo epel fribidi.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91-devel.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91-server.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91-docs.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91-python.x86_64; \
yumdownloader --resolve --enablerepo base uuid.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91-contrib.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgresql91-test.x86_64; \
yumdownloader --enablerepo pgdg91 pgbouncer.x86_64; \
yumdownloader --resolve --enablerepo epel json-c.x86_64; \
yumdownloader --resolve --enablerepo pgdg91 postgis2_91.x86_64; \
yumdownloader --resolve --enablerepo rpmforge hdf4-devel.x86_64; \
yumdownloader --resolve --enablerepo rpmforge hdf5-devel.x86_64; \
yumdownloader --resolve --enablerepo base readline-devel.x86_64; \
yumdownloader --resolve --enablerepo base giflib-devel.x86_64; \
yumdownloader --resolve --enablerepo base byacc.x86_64; \
yumdownloader --resolve --enablerepo base subversion.x86_64; \
yumdownloader --resolve --enablerepo base cmake.x86_64; \
yumdownloader --resolve --enablerepo base screen.x86_64; \
)

# add dynamic libs
echo "/usr/java/latest/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/usr/java/latest/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

# for compiling 
yum --enablerepo base install cmake

# for checking out lifemapper source  
yum --enablerepo base install subversion

# for mapserver
rpm -i src/RPMS/bitstream-vera-fonts-common-1.10-18.el6.noarch.rpm
rpm -i src/RPMS/bitstream-vera-sans-fonts-1.10-18.el6.noarch.rpm

# for mysql-python, rtree, pylucene
compile setuptools
install opt-setuptools

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

# meed for psycopg2
compile gdal
install lifemapper-gdal
/sbin/ldconfig

# for rtree
compile spatialindex
install lifemapper-spatialindex
/sbin/ldconfig

# install postgresql
yum --enablerepo base update openssl
yum install postgresql91
yum install postgresql91-devel

