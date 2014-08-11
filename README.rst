
.. hightlight:: rest

LifeMapper Server roll
=============================
.. contents::  

Introduction
----------------
This roll installs dbserver and webserver parts of Lifemapper.
All prerequisite software listed below are a part of the roll and 
will be installed and configured during roll installation. 
The roll has been tested with Rocks 6.1 and 6.1.1.

Prerequisites
~~~~~~~~~~~~~~
 
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
~~~~~~~~~

This section lists all the packages that were downloaded and used in the roll. 
The packages are a part of the roll source (or downloaded by bootstrap.sh). 

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section is for information on some packages build dependencies. These dependencies are handled
by the bootstrap.sh 

:**pytables**:    Cython and numexpr python packages and hdf5, hdf5-devel RPMS   
:**rtree**:       spatialindex, setuptools python packages  
:**mapserver**:   elgis repo, bitstream-vera-sans-fonts RPM, bitstream-vera-fonts-common RPM  
:**pylucene**:    setuptools python packages  
:**postgis2_91**: geos  
:**mapserver**:   geos  
:**psycopg2**:    gdal, postgresql91  

Required Rolls
~~~~~~~~~~~~~~~~

:**python**:    Python roll provides python2.7 

Building a roll 
------------------

Checkout roll distribution from git repo :: 

   # git clone https://github.com/pragmagrid/lifemapper-server.git 
   # cd lifemapper-server/

To build a roll, first execute a script that downloads and installs some packages 
and RPMS that are prerequisites for other packages during the roll build stage: ::

   # ./bootstrap.sh  

When the scirpt finishes, it prints the next step instruciton to get the lifemapper source ::  

   # cd src/lmserver/
   # make prep

This will produce lifemappser-server-X.tar.gz 
The X is the revision number in lifemapper SVN. The X is recorded in version.mk.in
Assumption: X is production ready revision and is a working code.
The roll will be using the X revision of lifemapper code.
 
To build individual packages ::

   # cd src/pkgname 
   # make rpm 

When all individual packages are building without errors build a roll via 
executing the command at the top level of the roll source tree ::

   # make roll


The resulting ISO file lifemapper-server-*.iso is the roll that can be added to the
frontend.

Adding a roll 
--------------
The roll (ISO file) can be added (1) during the initial installation of the cluster (frontend)
or (2) to the existing frontend.


1 Adding a roll to a new server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Add roll ISO to your existing frontend that is configured to be 
   a central server. This procesdure is documented in the section ``Frontend 
   Central Server`` of `Rocks Users Guide <http://central6.rocksclusters.org/roll-documentation/base/6.1.1/>`_.

#. During the frontend install choose the lifemapper-server roll from the list of available rolls
   when you see ``Select Your Rolls`` screen. 

#. During the forntend install choose python roll, it is a prerequisite for lifemapper-server roll


2 Adding a roll to a live frontend
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A roll can be added to the existing frontend. 
Make sure that the python roll is installed (can be downloaded from
`Rocks Downloads <http://www.rocksclusters.org/wordpress/?page_id=80>`_ )

Execute all commands from top level lifemapper-server/ ::

   # rocks add roll lifemapper-server-6.1-0.x86_64.disk1.iso   
   # rocks enable roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)  
   # yum clean all
   # rocks run roll lifemapper-server > add-lmserver.sh  
   # bash add-lmserver.sh  > add-lmserver.out 2>&1

After the  last command  is finished, examine the add-lmserver.out file for errors
and then reboot your frontend: ::

   # reboot

The reboot is needed to run a few initialization commands. 
After the frontend boots up check the /tmp/lifemapper-config.log file to check the status
of initialization commands.

At this point the  server is ready to run lifemapper-specific commands for pipeline initialization
and data seeding. 


Removing a roll
-------------------

When debugging a roll may need to remove the roll and all installled RPMs.
Before removing the roll stop postgres and pgbouncer services ::  
  
   # /etc/init.d/pgbouncer stop
   # /etc/init.d/postgresql-9.1 stop 

These commands remove the installed roll from Rocks database and repo ::

   # rocks remove roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)  

Run this script (from the top of roll source directory) to remove all 
installed RPMs, directories, users, etc ::

   # bash cleanRoll.sh

Using a Roll
-----------------

After the roll is installed, the initial database schema, and user authentication are set up
and postgres and pgbouncer are configured.  

#. Seed the pipeline ::   

     # /opt/lifemapper/rocks/bin/initDB

   The script output is in /tmp/initDB.log

#. Run the pipeline ::  

   # Instructions TBD

Notes 
-------

#. Compiling pylucene (make rpm) 

   #. On 2Gb memory host: is barely succeeding or failing intermittently. 
      Need to shut down  any extra daemons (like postgres and pgbouncer) and limit the java heap size. 
      Currently, heap sie is limited by added  environment ``_JAVA_OPTIONS="-Xmx256m"`` in Makefile. 
      May need to investigate -XX:MaxPermSize=128m and -Xms128m options in addition to -Xmx. 
      Other solutions (excerpt from hs_err_pi*log from one of failed runs): ::   

        # There is insufficient memory for the Java Runtime Environment to continue.
        # Native memory allocation (malloc) failed to allocate 32744 bytes for ChunkPool::allocate
        # Possible reasons:
        #   The system is out of physical RAM or swap space
        #   In 32 bit mode, the process size limit was hit
        # Possible solutions:
        #   Reduce memory load on the system
        #   Increase physical memory or swap space
        #   Check if swap backing store is full
        #   Use 64 bit Java on a 64 bit OS
        #   Decrease Java heap size (-Xmx/-Xms)
        #   Decrease number of Java threads
        #   Decrease Java thread stack sizes (-Xss)
        #   Set larger code cache with -XX:ReservedCodeCacheSize=

      If possible use 4Gb memory host. 

   #. On 4gb memory host: compile succeeds. 

#. During building a roll some java-based packages are not releasing allocated memory properly
   which results in available memory loss. After building a roll check host memory with ``free -m`` and 
   reboot if the free memory is too low. 
 
TODO 
-----------

#. Change all occurences of "DROP DATABASE X" to "DROP DATABASE X IF EXISTS".
   Same for index, type, view, function 

#. initTaxonomy.sql need to be created with correct time stamp.

#. fix last line in readTaxonomy.py (referrign non-existing var)

#. write a section on where roll parts are installed

#. update rmrpm.sh

#. write update roll info and some debugging
