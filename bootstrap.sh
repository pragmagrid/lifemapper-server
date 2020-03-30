#!/bin/bash
#
# Build and install prerequisites for compiling lmserver dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# Add PGDG repo for Postgresql and geospatial libs
# No opt-python for yum
module unload opt-python
yum install src/RPMS/screen-4.1.0-0.25.20120314git3c2946.el7.x86_64.rpm
yum install src/RPMS/pgdg-centos96-9.6-3.noarch.rpm epel-release
yum install cmake
yum update

### do this only once for roll distro to keep known RPMS in the roll src
#cd src/RPMS
# yumdownloader --resolve --enablerepo base screen.x86_64

# wget http://li.nux.ro/download/nux/dextop/el7/x86_64/bitstream-vera-fonts-common-1.10-19.el7.nux.noarch.rpm
# wget http://li.nux.ro/download/nux/dextop/el7/x86_64/bitstream-vera-sans-fonts-1.10-19.el7.nux.noarch.rpm
#
## for postgresql9.6 and postgis2 rpms
# wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
#
## for gdal
# yumdownloader --resolve --enablerepo epel libaec.x86_64  libaec-devel.x86_64
# yumdownloader --resolve --enablerepo epel hdf5.x86_64 hdf5-devel.x86_64
## for postgis
# yumdownloader --resolve --enablerepo epel proj.x86_64
## for mapserver
# yumdownloader --resolve --enablerepo base giflib-devel.x86_64
#
## Add PostgreSQL 9.6, devel, server, python
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-server 
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-contrib 
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-devel 
# yumdownloader --resolve --enablerepo=pgdg96 postgresql96-plpython
#
## Add postgis 
# yumdownloader --resolve --enablerepo=pgdg96 boost-serialization
# for gdal-libs
# yumdownloader --resolve --enablerepo=epel libdap 
# yumdownloader --resolve --enablerepo=epel CharLS  
# yumdownloader --resolve --enablerepo=epel cfitsio
# yumdownloader --resolve --enablerepo=epel freexl 
# yumdownloader --resolve --enablerepo=epel libgta 
# yumdownloader --resolve --enablerepo=epel netcdf 
# yumdownloader --resolve --enablerepo=epel openjpeg2 
## armadillo brings arpack, atlas, blas, lapack, hdf5, SuperLU, openblas-openmp
# yumdownloader --resolve --enablerepo epel  armadillo

# yumdownloader --resolve --enablerepo=pgdg96 postgis2_96
#
## Add postgresql-python connector
# yumdownloader --resolve --enablerepo=pgdg96 python2-psycopg2.x86_64

## Add pgbouncer from PGDG and dependency c-ares from epel and base repos
# yumdownloader --resolve --enablerepo=base c-ares.x86_64
# yumdownloader --resolve --enablerepo=base c-ares-devel.x86_64
# yumdownloader --resolve --enablerepo=pgdg96 pgbouncer
#
# for gdal
rpm -i src/RPMS/libaec-1.0.4-1.el7.x86_64.rpm
rpm -i src/RPMS/libaec-devel-1.0.4-1.el7.x86_64.rpm
rpm -i src/RPMS/hdf5-1.8.12-10.el7.x86_64.rpm
rpm -i src/RPMS/hdf5-devel-1.8.12-10.el7.x86_64.rpm

# for pgbouncer
rpm -i src/RPMS/c-ares-1.10.0-3.el7.x86_64.rpm
rpm -i src/RPMS/c-ares-devel-1.10.0-3.el7.x86_64.rpm

# for mapserver
module unload opt-python
# gd-devel pulls libXpm-devel also
yum --enablerepo base install gd-devel
rpm -i src/RPMS/bitstream-vera-fonts-common-1.10-19.el7.nux.noarch.rpm
rpm -i src/RPMS/bitstream-vera-sans-fonts-1.10-19.el7.nux.noarch.rpm
rpm -i src/RPMS/giflib-devel-4.1.6-9.el7.x86_64.rpm

# add dynamic libs
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-server.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-server.conf
# echo "/opt/rocks/fcgi/lib" >> /etc/ld.so.conf.d/lifemapper-server.conf
/sbin/ldconfig

# pip for numpy and scipy
module load opt-python
python3.6 -m ensurepip --default-pip
module unload opt-python

# setuptools and wheel for backports.functools_lru_cache install
cd src/setuptools
make prep
cd ../..
module load opt-python
compile setuptools
module unload opt-python
install opt-lifemapper-setuptools

cd src/wheel
make prep
module load opt-python
python36 -m ensurepip --default-pip
python36 -m pip install *.whl
cd ../..
compile wheel
module unload opt-python


# # add newer version of chardet for requests dependency
# cd src/chardet
# make prep
# cd ../..
# module load opt-python
# compile chardet
# module unload opt-python
# install opt-lifemapper-chardet
# /sbin/ldconfig

# install proj, tiff, geos for gdal
cd src/proj
make prep
cd ../..
compile proj
install lifemapper-proj
/sbin/ldconfig

cd src/tiff
make prep
cd ../..
compile tiff
install lifemapper-tiff
/sbin/ldconfig

cd src/geos
make prep
cd ../..
compile geos
install lifemapper-geos
/sbin/ldconfig

cd src/gdal
make prep
cd ../..
module load opt-python
compile gdal
module unload opt-python
install lifemapper-gdal
/sbin/ldconfig

# cython > 0.23.4 for scipy 
cd src/cython
make prep
cd ../..
module load opt-python
compile cython
module unload opt-python
install opt-lifemapper-cython

cd src/numpy
make prep
module load opt-python
python36 -m ensurepip --default-pip
python36 -m pip install *.whl
cd ../..
compile numpy
module unload opt-python

cd src/scipy
make prep
module load opt-python
python36 -m ensurepip --default-pip
python36 -m pip install *.whl
cd ../..
compile scipy
module unload opt-python
install opt-lifemapper-scipy

# install postgresql
# yum --enablerepo base update openssl
rpm -i src/RPMS/postgresql96-libs-9.6.15-1PGDG.rhel7.x86_64.rpm
rpm -i src/RPMS/postgresql96-9.6.15-1PGDG.rhel7.x86_64.rpm
rpm -i src/RPMS/postgresql96-devel-9.6.15-1PGDG.rhel7.x86_64.rpm
rpm -i src/RPMS/postgresql96-server-9.6.15-1PGDG.rhel7.x86_64.rpm
rpm -i src/RPMS/postgresql96-contrib-9.6.15-1PGDG.rhel7.x86_64.rpm
/sbin/ldconfig  /usr/pgsql-9.6/lib/


# # for postgis which is for mapserver
# rpm -i src/RPMS/CGAL-4.7-1.rhel7.1.x86_64.rpm
# rpm -i src/RPMS/boost-serialization-1.53.0-27.el7.x86_64.rpm 
# rpm -i src/RPMS/SFCGAL-libs-1.3.1-1.rhel7.x86_64.rpm 
# rpm -i src/RPMS/SFCGAL-1.3.1-1.rhel7.x86_64.rpm 
# rpm -i src/RPMS/geos-3.5.0-1.rhel7.1.x86_64.rpm 
# rpm -i src/RPMS/libgeotiff-1.4.0-1.rhel7.1.x86_64.rpm 
# rpm -i src/RPMS/ogdi-3.2.0-4.rhel7.1.x86_64.rpm 
# rpm -i src/RPMS/unixODBC-2.3.1-11.el7.x86_64.rpm 
# rpm -i src/RPMS/xerces-c-3.1.1-8.el7_2.x86_64.rpm 
# rpm -i src/RPMS/libdap-3.13.1-2.el7.x86_64.rpm 
# rpm -i src/RPMS/CharLS-1.0-5.el7.x86_64.rpm 
# rpm -i src/RPMS/cfitsio-3.370-10.el7.x86_64.rpm 
# rpm -i src/RPMS/freexl-1.0.5-1.el7.x86_64.rpm 
# rpm -i src/RPMS/netcdf-4.3.3.1-5.el7.x86_64.rpm 
# rpm -i src/RPMS/openjpeg2-2.3.1-1.el7.x86_64.rpm 
# rpm -i src/RPMS/libgta-1.0.4-1.el7.x86_64.rpm 
# rpm -i src/RPMS/atlas-3.10.1-12.el7.x86_64.rpm 
# rpm -i src/RPMS/SuperLU-5.2.0-5.el7.x86_64.rpm 
# rpm -i src/RPMS/arpack-3.1.3-2.el7.x86_64.rpm 
# rpm -i src/RPMS/blas-3.4.2-8.el7.x86_64.rpm 
# rpm -i src/RPMS/lapack-3.4.2-8.el7.x86_64.rpm 
# rpm -i src/RPMS/openblas-openmp-0.3.3-2.el7.x86_64.rpm 
# rpm -i src/RPMS/armadillo-8.300.0-1.el7.x86_64.rpm
 
# rpm -i src/RPMS/libusb-0.1.4-3.el7.x86_64.rpm
# rpm -i src/RPMS/shapelib-1.3.0-2.el7.x86_64.rpm
# rpm -i src/RPMS/gpsbabel-1.5.0-2.el7.x86_64.rpm
# rpm -i src/RPMS/gdal-1.11.4-12.rhel7.x86_64.rpm
# rpm -i src/RPMS/gdal-devel-1.11.4-12.rhel7.x86_64.rpm
# rpm -i src/RPMS/gdal-libs-1.11.4-12.rhel7.x86_64.rpm 

# rpm -i src/RPMS/proj-4.8.0-4.el7.x86_64.rpm 
# rpm -i src/RPMS/postgis2_96-2.3.2-1.rhel7.x86_64.rpm

# cherrypy 17.4.2 requires six>=1.11.0, cheroot>=6.2.4, portend>=2.1.1, 
#                    and for exec, not build:
#                          more-itertools=5.0.0 
#                          contextlib2==0.6.0.post1
#                          zc.lockfile=2.0
#                          backports.functools_lru_cache=1.6.1
#                          jaraco.functools=2.0
# cheroot requires six and setuptools
# portend requires tempora requires six, pytz


# needed for cheroot build (on devapp, not in LM install?)
cd src/six
make prep
cd ../..
module load opt-python
compile six
module unload opt-python
install opt-lifemapper-six
/sbin/ldconfig

cd src/cheroot
make prep
cd ../..
module load opt-python
compile cheroot
module unload opt-python
install opt-lifemapper-cheroot
/sbin/ldconfig

cd src/pytz
make prep
cd ../..
module load opt-python
compile pytz
module unload opt-python
install opt-lifemapper-pytz
/sbin/ldconfig

cd src/tempora
make prep
cd ../..
module load opt-python
compile tempora
module unload opt-python
install opt-lifemapper-tempora
/sbin/ldconfig

cd src/portend
make prep
cd ../..
module load opt-python
compile portend
module unload opt-python
install opt-lifemapper-portend
/sbin/ldconfig

# Leave with opt-python loaded
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

