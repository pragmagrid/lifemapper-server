
.. hightlight:: rest

.. content:: Lifemapper server roll

LifeMapper Server roll
=============================

This roll installs lmserver and lmweb parts of Lifemapper

Prerequisites
-----------------
 
#. RPM repos ``elgis`` and ``pgdg91`` 
#. RPMs from standard yum repos:  

   :base:     cmake, subversion, sqlite-devel, giflib-devel, byacc, readline-devel 
   :rpmforge: hdf4, hdf4-devel, hdf5, hdf5-devel
   :epel:     fribidi, json-c
   :elgis:    mapserver 
   :pgdg91:   postgresql91, postgresql91-devel, postgis2_91, pgbouncer

#. Source distributions: 
   
   :binaries: ant gdal proj geos libevent libspatialindex tiff  
   :python modules:         Cheetah, CherryPy, Cython,  egenix-mxDateTime (part of egenix-mx-base),   
                                faulthandler  mod_python, mysql-python,  numexpr,   
                                rtree, psycopg2,  pylucene, pytables, setuptools   
    
Downloads
---------------

#. **elgis and pgdg91 repos**  ::

    wget http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/pgdg-centos91-9.1-4.noarch.rpm  
    wget http://elgis.argeo.org/repos/6/elgis-release-6-6_0.noarch.rpm  

#. **vera fonts for mapserver**  ::

    wget ftp://ftp.pbone.net/mirror/atrpms.net/el6-x86_64/atrpms/stable/bitstream-vera-sans-fonts-1.10-18.el6.noarch.rpm  
    wget ftp://ftp.pbone.net/mirror/atrpms.net/el6-i386/atrpms/stable/bitstream-vera-fonts-common-1.10-18.el6.noarch.rpm  

#. **sources**  ::

    wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2  
    wget http://www.cython.org/release/Cython-0.20.tar.gz  
    wget http://sourceforge.net/projects/pytables/files/pytables/3.1.0/tables-3.1.0rc2.tar.gz  
    wget http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.1.tar.gz  
    wget http://www.poolsaboveground.com/apache/lucene/pylucene/pylucene-4.5.1-1-src.tar.gz  
    wget http://download.cherrypy.org/cherrypy/3.1.2/CherryPy-3.1.2.tar.gz  
    wget http://mirror.metrocast.net/apache//ant/source/apache-ant-1.9.3-src.tar.gz  
    wget http://dist.modpython.org/dist/mod_python-3.5.0.tgz  
    wget --no-check-certificate https://pypi.python.org/packages/source/n/numexpr/numexpr-2.3.tar.gz  
    wget --no-check-certificate https://downloads.egenix.com/python/egenix-mx-base-3.2.7.tar.gz  
    wget --no-check-certificate http://pypi.python.org/packages/source/s/setuptools/setuptools-2.1.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/R/Rtree/Rtree-0.7.0.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.5.2.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/M/MySQL-python/MySQL-python-1.2.5.zip  
    wget --no-check-ertificate https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/f/faulthandler/faulthandler-2.3.tar.gz  

Individual package dependencies
-------------------------------

  :**pytables**:    Cython and numexpr python packages and hdf5, hdf5-devel RPMS   
  :**rtree**:       spatialindex, setuptools python packages  
  :**mapserver**:   elgis repo, bitstream-vera-sans-fonts RPM, bitstream-vera-fonts-common RPM  
  :**pylucene**:    setuptools python packages  
  :**postgis2_91**: geos  
  :**mapserver**:   geos  
  :**psycopg2**:    gdal, postgresql91  

Building individual packages 
--------------------------------
::

   # cd src/pkgname 
   # make rpm 

Building a roll 
------------------
::

   # ./bootstrap.sh  
   # make roll

Adding a roll
------------------
::

    # rocks add roll lifemapper-server-6.1-0.x86_64.disk1.iso   
    # (cd /export/rocks/install; rocks create distro)  
    # rocks run roll lifemapper-server > add-lmserver.sh  
    # bash add-lmserver.sh  

TODO 
-----------

1. add screen on frontend
2. These files need further decoupling from the manual deiting  
  * LmCommon/common/lmconstants.py  
  * LmServerCommon/sdm/algorithm.py  
  * LmServerCommon/db/peruser.py  
  * LmServerCommon/db/localparams.py  
  * LmServerCommon/common/datalocator.py  
  * LmDbServer/pipeline/localpipeline.py  

