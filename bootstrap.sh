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
# wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm; \
# yum install pgdg-centos96-9.6-3.noarch.rpm epel-release;  \
#
#yumdownloader --resolve --enablerepo base readline-devel.x86_64; \
#yumdownloader --resolve --enablerepo base flex.x86_64; \
#
#yumdownloader --resolve --enablerepo epel hdf5.x86_64 hdf5-devel.x86_64; \
#yumdownloader --resolve --enablerepo epel fcgi.x86_64; \
#yumdownloader --resolve --enablerepo epel fcgi.x86_64; \
#yumdownloader --resolve --enablerepo epel fribidi.x86_64; \
#yumdownloader --resolve --enablerepo epel mapserver.x86_64; \
#yumdownloader --resolve --enablerepo epel proj.x86_64; \
#yumdownloader --resolve --enablerepo epel python-psycopg2.x86_64; \
# Add pytest and deps for Rocks 7.0 roll

## brings postgresql92-libs
#yumdownloader --resolve --enablerepo pgdg96 postgresql96; \
#yumdownloader --resolve --enablerepo pgdg96 postgresql96-devel.x86_64; \
#yumdownloader --resolve --enablerepo pgdg96 postgresql96-server.x86_64; \
#yumdownloader --resolve --enablerepo pgdg96 postgresql96-contrib.x86_64; \
#yumdownloader --resolve --enablerepo pgdg96 pgbouncer.x86_64; \
#yumdownloader --resolve --enablerepo pgdg96 postgis2_96.x86_64; \
#
#yumdownloader --resolve --enablerepo base gd-devel.x86_64; \
#yumdownloader --resolve --enablerepo base byacc.x86_64; \
#yumdownloader --resolve --enablerepo base screen.x86_64; \

#yumdownloader --resolve --enablerepo base python2-futures.noarch; \
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

# util
rpm -i src/RPMS/screen*rpm

# why are these needed 
rpm -i src/RPMS/giflib-devel*.rpm
rpm -i src/RPMS/gd-devel*.rpm
rpm -i src/RPMS/bitstream-vera-*1.10-19*.rpm

# for rdflib, from epel
rpm -i src/RPMS/python-html5lib-0.999-6.el7.noarch.rpm
rpm -i src/RPMS/python-isodate-0.5.0-3.el7.noarch.rpm
rpm -i src/RPMS/python-rdflib

# for gdal, from epel
rpm -i src/RPMS/CharLS*el7.*.rpm     
rpm -i src/RPMS/SuperLU*el7.*.rpm     
rpm -i src/RPMS/armadillo*el7.*.rpm     
rpm -i src/RPMS/arpack*.el7.*.rpm       
rpm -i src/RPMS/blas*.el7.*.rpm     
rpm -i src/RPMS/atlas*.el7.*.rpm     
rpm -i src/RPMS/cfitsio*.el7.*.rpm     
rpm -i src/RPMS/freexl*.el7.*.rpm     
rpm -i src/RPMS/gdal*.el7.*.rpm
# use geos from pgdg96, needed for mapserver
rpm -i src/RPMS/geos*3.5.0*.rhel7.*.rpm     
rpm -i src/RPMS/gpsbabel*.el7.*.rpm     
rpm -i src/RPMS/lapack*.el7.*.rpm
rpm -i src/RPMS/hdf5*.el7.*.rpm     
rpm -i src/RPMS/libaec*.el7.*.rpm     
rpm -i src/RPMS/libdap*.el7.*.rpm     
rpm -i src/RPMS/libgeotiff*.el7.*.rpm     
rpm -i src/RPMS/libusb*.el7.*.rpm     
rpm -i src/RPMS/libgta*.el7.*.rpm     
rpm -i src/RPMS/netcdf*.el7.*.rpm     
rpm -i src/RPMS/ogdi*.el7.*.rpm     
rpm -i src/RPMS/openblas-openmp*.el7.*.rpm     
rpm -i src/RPMS/postgresql-libs-9.2*.el7_4.*.rpm     
rpm -i src/RPMS/openjpeg2*.el7.*.rpm     
rpm -i src/RPMS/proj-*.el7.*.rpm     
rpm -i src/RPMS/unixODBC*.el7.*.rpm     
rpm -i src/RPMS/shapelib*.el7.*.rpm     
rpm -i src/RPMS/xerces-c*.el7_2.*.rpm

# for postgresql 9.6, pgbouncer, from pgdg96
rpm -i src/RPMS/postgresql96*rpm
rpm -i src/RPMS/python2-psycopg2
rpm -i src/RPMS/c-ares*.rpm
rpm -i src/RPMS/postgresql10-libs*.rpm
rpm -i src/RPMS/pgbouncer*.rpm

# for mapserver ???


# install postgresql 9.2 and postgis
rpm -i src/RPMS/postgresql92*.rpm
rpm -i src/RPMS/postgis2*.rpm

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

