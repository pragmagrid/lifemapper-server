#!/bin/bash
#
# Build and install prerequisites for compiling lmserver dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

### do this only once for roll distro to keep known RPMS in the roll src
#cd src/RPMS; 
#
# wget http://li.nux.ro/download/nux/dextop/el7/x86_64//bitstream-vera-fonts-common-1.10-19.el7.nux.noarch.rpm
# wget http://li.nux.ro/download/nux/dextop/el7/x86_64//bitstream-vera-sans-fonts-1.10-19.el7.nux.noarch.rpm
#
## for postgresql9.6 and postgis2 rpms
# wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
# yum install pgdg-centos96-9.6-3.noarch.rpm epel-release;  \
# yum update;  \
#
# yumdownloader --resolve --enablerepo=base screen.x86_64
# yumdownloader --resolve --enablerepo=base readline-devel.x86_64
#
## Add gdal, gdal-devel, gdal-python and deps from epel repo
# yumdownloader --resolve --enablerepo=epel gdal.x86_64
# yumdownloader --resolve --enablerepo=epel gdal-devel.x86_64
# yumdownloader --resolve --enablerepo=epel gdal-python.x86_64
#
## Add header files for dependencies proj, geos, tiff, hdf5
# yumdownloader --resolve --enablerepo=epel hdf5-devel.x86_64
# yumdownloader --resolve --enablerepo=epel proj49-devel.x86_64
# yumdownloader --resolve --enablerepo=epel proj49-epsg.x86_64
# yumdownloader --resolve --enablerepo=epel proj49-nad.x86_64
# yumdownloader --resolve --enablerepo=epel geos-devel
# yumdownloader --resolve --enablerepo=epel geos-python
# yumdownloader --resolve --enablerepo=epel libtiff
# yumdownloader --resolve --enablerepo=epel libgeotiff-devel
#
## Add PostgreSQL 9.6, devel, server, python
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-server 
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-contrib 
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-devel 
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-plpython
# yumdownloader --resolve --enablerepo=pgdg96 postgis2_96
#
## Add Postgis, python-postgresql connector
# yumdownloader --resolve --enablerepo=pgdg96 pgbouncer
# yumdownloader --resolve --enablerepo=pgdg96 python2_psycopg2.x86_64
# 
# yumdownloader --resolve --enablerepo=base python2-futures.noarch
# #)

# Add PGDG repo for Postgresql and geospatial libs
# No opt-python for yum
module unload opt-python
yum install src/RPMS/pgdg-centos96-9.6-3.noarch.rpm epel-release
yum update

module load opt-python

# util
rpm -i src/RPMS/screen*rpm
rpm -i src/RPMS/readline-devel*rpm
rpm -i src/RPMS/bitstream-vera-*1.10-19*.rpm
# GDAL and resolved dependencies
rpm -i src/RPMS/CharLS-1.0-5.el7.x86_64.rpm
rpm -i src/RPMS/SuperLU-5.2.0-5.el7.x86_64.rpm
rpm -i src/RPMS/armadillo-8.300.0-1.el7.x86_64.rpm
rpm -i src/RPMS/arpack-3.1.3-2.el7.x86_64.rpm
rpm -i src/RPMS/blas-3.4.2-8.el7.x86_64.rpm
rpm -i src/RPMS/atlas-3.10.1-12.el7.x86_64.rpm
rpm -i src/RPMS/cfitsio-3.370-10.el7.x86_64.rpm
rpm -i src/RPMS/freexl-1.0.5-1.el7.x86_64.rpm
rpm -i src/RPMS/gpsbabel-1.5.0-2.el7.x86_64.rpm
rpm -i src/RPMS/lapack-3.4.2-8.el7.x86_64.rpm
# Add devel
rpm -i src/RPMS/hdf5*-1.8.12-10.el7.x86_64.rpm     
rpm -i src/RPMS/libaec-1.0.4-1.el7.x86_64.rpm
rpm -i src/RPMS/libdap-3.13.1-2.el7.x86_64.rpm
rpm -i src/RPMS/libusb-0.1.4-3.el7.x86_64.rpm
rpm -i src/RPMS/libgta-1.0.4-1.el7.x86_64.rpm
# Add devel, python  
rpm -i src/RPMS/geos*-3.5.0-1.rhel7.1.x86_64.rpm
rpm -i src/RPMS/ogdi-3.2.0-4.rhel7.1.x86_64.rpm
rpm -i src/RPMS/netcdf-4.3.3.1-5.el7.x86_64.rpm
rpm -i src/RPMS/gdal-libs-1.11.4-12.rhel7.x86_64.rpm    
rpm -i src/RPMS/openblas-openmp-0.3.3-2.el7.x86_64.rpm     
rpm -i src/RPMS/postgresql-libs-9.2.23-3.el7_4.x86_64.rpm
rpm -i src/RPMS/openjpeg2-2.3.1-1.el7.x86_64.rpm
rpm -i src/RPMS/unixODBC-2.3.1-11.el7.x86_64.rpm
rpm -i src/RPMS/xerces-c-3.1.1-8.el7_2.x86_64.rpm
rpm -i src/RPMS/shapelib-1.3.0-2.el7.x86_64.rpm
rpm -i src/RPMS/proj49*-4.9.3-3.rhel7.1.x86_64.rpm
# Add devel (python below)  
rpm -i src/RPMS/gdal-1.11.4-12.rhel7.x86_64.rpm     
rpm -i src/RPMS/gdal-devel-1.11.4-12.rhel7.x86_64.rpm     
rpm -i src/RPMS/libgeotiff*-1.4.0-1.rhel7.1.x86_64.rpm
# Add libtiff for libgeotiff, brings 
rpm -i src/RPMS/glibc-2.17-196.el7_4.2.i686.rpm     
rpm -i src/RPMS/jbigkit-libs-2.0-11.el7.i686.rpm     
rpm -i src/RPMS/libgcc-4.8.5-16.el7_4.1.i686.rpm     
rpm -i src/RPMS/libjpeg-turbo-1.2.90-5.el7.i686.rpm     
rpm -i src/RPMS/libstdc++-4.8.5-16.el7_4.1.i686.rpm
# Note: both i686 and x86_64   
rpm -i src/RPMS/libtiff*-4.0.3-27.el7_3.*.rpm     
rpm -i src/RPMS/nss-softokn-freebl-3.28.3-8.el7_4.i686.rpm     
rpm -i src/RPMS/zlib-1.2.7-17.el7.i686.rpm
# Add gdal-python and resolved dependencies
rpm -i src/RPMS/python-nose-1.3.7-1.el7.noarch.rpm     
rpm -i src/RPMS/numpy-1.7.1-11.el7.x86_64.rpm     
rpm -i src/RPMS/gdal-python-1.11.4-12.rhel7.x86_64.rpm
# Postgresql 9.6 and related from pgdg96
rpm -i src/RPMS/postgresql96*rpm
# Add python2-psycopg2 and dependency
rpm -i src/RPMS/postgresql10-libs-10.9-1PGDG.rhel7.x86_64.rpm
rpm -i src/RPMS/python2-psycopg2-2.8.2-2.rhel7.x86_64.rpm
# Add pgbouncer and resolved dependency 
rpm -i src/RPMS/c-ares-1.10.0-3.el7.x86_64.rpm                                                                                                                              |  78 kB  00:00:00     
rpm -i src/RPMS/pgbouncer-1.9.0-1.rhel7.1.x86_64.rpm
# Add postgis and related from PGDG96 repo
rpm -i src/RPMS/boost-serialization-1.53.0-27.el7.x86_64.rpm     
rpm -i src/RPMS/SFCGAL-1.3.1-1.rhel7.x86_64.rpm     
rpm -i src/RPMS/proj-4.8.0-2.rhel7.x86_64.rpm     
rpm -i src/RPMS/CGAL-4.7-1.rhel7.1.x86_64.rpm     
rpm -i src/RPMS/SFCGAL-libs-1.3.1-1.rhel7.x86_64.rpm     
rpm -i src/RPMS/postgis2_96-2.3.2-1.rhel7.x86_64.rpm
# futures backport to python2
rpm -i src/RPMS/python2-futures-3.1.1-5.el7.noarch.rpm


# add dynamic libs
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-server.conf
# echo "/opt/rocks/fcgi/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

# for cherrypy
# cheroot requires six
# tempora requires six, pytz
# portend requires tempora
# cherrypy requires six, cheroot>=5.2.0, portend>=1.6.1
compile six
install opt-lifemapper-six
/sbin/ldconfig

compile cheroot
install opt-lifemapper-cheroot
/sbin/ldconfig

compile pytz
install opt-lifemapper-pytz
/sbin/ldconfig

compile tempora
install opt-lifemapper-tempora
/sbin/ldconfig

compile portend
install opt-lifemapper-portend
/sbin/ldconfig


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

