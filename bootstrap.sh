#!/bin/bash
#
# Build and install prerequisites for compiling lmserver dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# EPEL repo 7.9 is installed in Rocks 7 by default

# enable repo (from https://yum.postgresql.org/repopackages.php) 
# for postgresql9.2 and postgis2 rpms
(cd src/RPMS;
PGDGREPO=pgdg-centos92-9.2-3.noarch.rpm;
wget https://download.postgresql.org/pub/repos/yum/9.2/redhat/rhel-7-x86_64/$PGDGREPO;
rpm -i $PGDGREPO;
)

# HDF4 not needed?
# replace defunct rpmforge repo for hdf4 rpms
# edit repo to point to correct URLs
#     /etc/yum.repos.d/rpmforge.repo
# (cd src/RPMS; 
# RPMFORGEREPO=rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm;
# wget http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/$RPMFORGEREPO;
# rpm -Uvh $RPMFORGEREPO;
# )


### do this only once for roll distro to keep known RPMS in the roll src
#(cd src/RPMS; 
#wget http://li.nux.ro/download/nux/dextop/el7/x86_64//bitstream-vera-fonts-common-1.10-19.el7.nux.noarch.rpm; \
#wget http://li.nux.ro/download/nux/dextop/el7/x86_64//bitstream-vera-sans-fonts-1.10-19.el7.nux.noarch.rpm; \

#yumdownloader --resolve --enablerepo base uuid.x86_64; \
#yumdownloader --resolve --enablerepo base c-ares.x86_64; \
#
# #yumdownloader --resolve --enablerepo rpmforge hdf4.x86_64 hdf4-devel.x86_64; \
#
#yumdownloader --resolve --enablerepo epel hdf5.x86_64 hdf5-devel.x86_64; \
#yumdownloader --resolve --enablerepo epel fcgi.x86_64; \
#yumdownloader --resolve --enablerepo epel fcgi.x86_64; \
#yumdownloader --resolve --enablerepo epel fribidi.x86_64; \
#yumdownloader --resolve --enablerepo epel mapserver.x86_64; \
#yumdownloader --resolve --enablerepo epel proj.x86_64; \
#
#yumdownloader --resolve --enablerepo pgdg92 gdal.x86_64 gdal-devel.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 geos.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgresql92.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgresql92-devel.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgresql92-server.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgresql92-docs.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 uuid.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgresql92-contrib.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgresql92-test.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 pgbouncer.x86_64; \
#yumdownloader --resolve --enablerepo pgdg92 postgis2_92.x86_64; \
#
#yumdownloader --resolve --enablerepo base gd-devel.x86_64; \
#yumdownloader --resolve --enablerepo base byacc.x86_64; \
#yumdownloader --resolve --enablerepo base screen.x86_64; \
#)

# Needed for postgresql92-contrib  
rpm -i src/RPMS/uuid*.rpm

# Needed for pgbouncer 
rpm -i src/RPMS/c-ares.rpm

# add dynamic libs
## No longer using java roll with /usr/java/latest/jre
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opll t/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-server.conf
# echo "/opt/rocks/fcgi/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

rpm -i src/RPMS/screen*rpm

# cmake already installed and up-to-date
# yum --enablerepo base install cmake

# for pytables hdf5 
rpm -i src/RPMS/libaec*.rpm
rpm -i src/RPMS/hdf5*.rpm


# for mapserver
module unload opt-python
rpm -i src/RPMS/giflib-devel*.rpm
rpm -i src/RPMS/gd-devel*.rpm
rpm -i src/RPMS/bitstream-vera-*.rpm

module load opt-python
compile proj
module unload opt-python
install lifemapper-proj

# for mysql-python, rtree, cherrypy
# setuptools 6.1, included in python roll
# setuptools 20.7, needed for cherrypy build (on devapp, not in LM install)
module load opt-python
(cd src/setuptools; /opt/python/bin/python2.7 setup.py install)

# for cherrypy
# cheroot requires six
# tempora requires six, pytz
# portend requires tempora
# cherrypy requires six, cheroot>=5.2.0, portend>=1.6.1
module load opt-python
compile six
module unload opt-python
install opt-lifemapper-six

module load opt-python
compile cheroot
module unload opt-python
install opt-lifemapper-cheroot

module load opt-python
compile pytz
module unload opt-python
install opt-lifemapper-pytz

module load opt-python
compile tempora
module unload opt-python
install opt-lifemapper-tempora

module load opt-python
compile portend
module unload opt-python
install opt-lifemapper-portend

# for pytables 
module load opt-python
compile cython 
module unload opt-python
install opt-lifemapper-cython 

module load opt-python
compile numexpr 
module unload opt-python
install opt-lifemapper-numexpr 
rpm -i src/RPMS/hdf5*rpm

# # need for gdal?
# yum --enablerepo epel install gpsbabel
# yum --enablerepo base install xerces-c
# yum --enablerepo epel install openjpeg2
# yum --enablerepo epel install ogdi
# yum --enablerepo base install unixODBC
# yum --enablerepo epel install netcdf
# yum --enablerepo pgdg2 install libgeotiff
# yum --enablerepo epel install libgta
# # libfreexl.so.1
# yum --enablerepo epel install libdap
# yum --enablerepo epel install cfitsio
# yum --enablerepo epel install armadillo
# yum --enablerepo epel install CharLS

module load opt-python
compile geos
module unload opt-python
install lifemapper-geos
/sbin/ldconfig

# meed for psycopg2
module load opt-python
compile gdal
module unload opt-python
install lifemapper-gdal
/sbin/ldconfig

# for rtree
module load opt-python
compile spatialindex
module unload opt-python
install lifemapper-spatialindex
/sbin/ldconfig

# # install postgresql 9.2
yum --enablerepo pgdg92 -y install postgresql92
yum --enablerepo pgdg92 -y install postgresql92-devel

# reload opt-python for rpm builds
module load opt-python

echo "You will need to download source code, data and dependencies."
echo "    lmserver"
echo "    webclient"
echo "    lmdata-env"
echo "    lmdata-image"
echo "    lmdata-species"
echo "    solr"
echo "    cctools"
echo "    dendropy"
echo "Go to each of the packages and execute:"
echo "    make prep"

