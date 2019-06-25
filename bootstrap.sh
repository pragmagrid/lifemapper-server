#!/bin/bash
#
# Build and install prerequisites for compiling lmserver dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

### do this only once for roll distro to keep known RPMS in the roll src
#(cd src/RPMS; 
#wget http://li.nux.ro/download/nux/dextop/el7/x86_64//bitstream-vera-fonts-common-1.10-19.el7.nux.noarch.rpm; \
#wget http://li.nux.ro/download/nux/dextop/el7/x86_64//bitstream-vera-sans-fonts-1.10-19.el7.nux.noarch.rpm; \
## for postgresql9.2 and postgis2 rpms
#wget https://download.postgresql.org/pub/repos/yum/9.2/redhat/rhel-7-x86_64/pgdg-centos92-9.2-3.noarch.rpm;  \
#
#yumdownloader --resolve --enablerepo base uuid.x86_64; \
#yumdownloader --resolve --enablerepo base c-ares.x86_64; \
#yumdownloader --resolve --enablerepo base readline-devel.x86_64; \
#yumdownloader --resolve --enablerepo base flex.x86_64; \
#
#yumdownloader --resolve --enablerepo epel hdf5.x86_64 hdf5-devel.x86_64; \
#yumdownloader --resolve --enablerepo epel fcgi.x86_64; \
#yumdownloader --resolve --enablerepo epel fcgi.x86_64; \
#yumdownloader --resolve --enablerepo epel fribidi.x86_64; \
#yumdownloader --resolve --enablerepo epel mapserver.x86_64; \
#yumdownloader --resolve --enablerepo epel proj.x86_64; \
# Add pytest and deps for Rocks 7.0 roll

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

# Add pytest and deps for Rocks 7.0 roll

# Add PGDG repo for Postgresql and geospatial libs
rpm -i src/RPMS/pgdg-centos92-9.2-3.noarch.rpm

# Needed for postgresql92-contrib  
rpm -i src/RPMS/uuid*.rpm

# Needed for pgbouncer 
rpm -i src/RPMS/c-ares*.rpm

# add dynamic libs
## No longer using java roll with /usr/java/latest/jre
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/rocks/fcgi/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

module unload opt-python
rpm -i src/RPMS/screen*rpm

# for pytables hdf5 
module unload opt-python
rpm -i src/RPMS/libaec*.rpm
rpm -i src/RPMS/hdf5*.rpm

# for mapserver
module unload opt-python
rpm -i src/RPMS/giflib-devel*.rpm
rpm -i src/RPMS/gd-devel*.rpm
rpm -i src/RPMS/bitstream-vera-*1.10-19*.rpm

# for cherrypy
# setuptools 36.2.7 included in /opt/python 2.7
# setuptools 20.7, needed for cherrypy build (on devapp, not in LM install)
# module load opt-python
# (cd src/setuptools; /opt/python/bin/python2.7 setup.py install)

# for cherrypy
# cheroot requires six
# tempora requires six, pytz
# portend requires tempora
# cherrypy requires six, cheroot>=5.2.0, portend>=1.6.1
module load opt-python
compile six
module unload opt-python
install opt-lifemapper-six
/sbin/ldconfig

module load opt-python
compile cheroot
module unload opt-python
install opt-lifemapper-cheroot
/sbin/ldconfig

module load opt-python
compile pytz
module unload opt-python
install opt-lifemapper-pytz
/sbin/ldconfig

module load opt-python
compile tempora
module unload opt-python
install opt-lifemapper-tempora
/sbin/ldconfig

module load opt-python
compile portend
module unload opt-python
install opt-lifemapper-portend
/sbin/ldconfig

# for pytables 
module load opt-python
compile cython 
module unload opt-python
install opt-lifemapper-cython 
/sbin/ldconfig

module load opt-python
compile numexpr 
module unload opt-python
install opt-lifemapper-numexpr 
/sbin/ldconfig

# # other options for gdal
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

# install proj, tiff, geos for gdal
module load opt-python
compile proj
module unload opt-python
install lifemapper-proj
/sbin/ldconfig

# New to match pre-gdal build in lifemapper-compute
module load opt-python
compile tiff
module unload opt-python
install lifemapper-tiff
/sbin/ldconfig

module load opt-python
compile geos
module unload opt-python
install lifemapper-geos
/sbin/ldconfig

# need for psycopg2
module load opt-python
compile gdal
module unload opt-python
install lifemapper-gdal
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

