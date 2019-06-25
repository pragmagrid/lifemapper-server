
.. highlight:: rest

Lifemapper Server roll
======================
.. contents::  

Introduction
------------
This roll installs dbserver and webserver parts of Lifemapper.
All prerequisite software listed below are a part of the roll and 
will be installed and configured during roll installation. 
The roll has been tested with Rocks 6.2.

For PRAGMA27 student challenge please see `Lifemapper Student Challenge`_

.. _Lifemapper Student Challenge : docs/student-challenge.rst


Prerequisites
~~~~~~~~~~~~~

This section lists all the prerequisites for lifemapper code dependencies.
The dependencies are either build from source or installed from RPMs 
during the roll build.
 
#. RPM repos ``epel`` and ``pgdg91`` 
#. RPMs from standard yum repos:  

   :base:     cmake, sqlite-devel, giflib-devel, byacc, readline-devel 
              hdf5, hdf5-devel
   :epel:     fribidi, json-c, mapserver
   :pgdg91:   postgresql91, postgresql91-devel, postgis2_91, pgbouncer

#. Source distributions: 
   
   :binaries: gdal proj geos libevent libspatialindex tiff mod_wsgi cctools 
              dendropy solr
   :python modules: CherryPy, Cython,  egenix-mxDateTime (part of egenix-mx-base),   
                    faulthandler,  numexpr,   
                    psycopg2, setuptools, rdflib, isodate, processing
    
Downloads
~~~~~~~~~

This section lists all the packages that were downloaded and used in the roll. 
The packages are a part of the roll source (or downloaded by bootstrap.sh). 

#. **pgdg91 repo**  ::

    wget http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/pgdg-centos91-9.1-4.noarch.rpm  

#. **vera fonts for mapserver**  ::

    wget ftp://ftp.pbone.net/mirror/atrpms.net/el6-x86_64/atrpms/stable/bitstream-vera-sans-fonts-1.10-18.el6.noarch.rpm  
    wget ftp://ftp.pbone.net/mirror/atrpms.net/el6-i386/atrpms/stable/bitstream-vera-fonts-common-1.10-18.el6.noarch.rpm  

#. **sources**  ::

    wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2  
    wget http://www.cython.org/release/Cython-0.20.tar.gz  
    wget http://sourceforge.net/projects/pytables/files/pytables/3.1.0/tables-3.1.0rc2.tar.gz  
    wget http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.1.tar.gz  
    wget http://download.cherrypy.org/cherrypy/3.1.2/CherryPy-3.1.2.tar.gz  
    wget http://dist.modpython.org/dist/mod_python-3.5.0.tgz  
    wget https://rdflib.googlecode.com/files/rdflib-3.2.0.tar.gz
    wget --no-check-certificate https://pypi.python.org/packages/source/n/numexpr/numexpr-2.3.tar.gz  
    wget --no-check-certificate https://downloads.egenix.com/python/egenix-mx-base-3.2.7.tar.gz  
    wget --no-check-certificate http://pypi.python.org/packages/source/s/setuptools/setuptools-2.1.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/R/Rtree/Rtree-0.7.0.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.5.2.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/M/MySQL-python/MySQL-python-1.2.5.zip  
    wget --no-check-certificate https://pypi.python.org/packages/source/f/faulthandler/faulthandler-2.3.tar.gz  
    wget --no-check-certificate https://pypi.python.org/packages/source/i/isodate/isodate-0.5.0.tar.gz
    wget --no-check-certificate  https://pypi.python.org/packages/source/p/processing/processing-0.52.zip`

    solr
    wget http://mirror.metrocast.net/apache/lucene/solr/5.3.0/solr-5.3.0.tgz
    wget http://www.vividsolutions.com/jts/bin/jts-1.8.0.zip

    makeflow + work_queue
    wget http://ccl.cse.nd.edu/software/files/cctools-5.4.2-source.tar.gz

Individual package dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section is for information on some packages build dependencies. These dependencies are handled
by the bootstrap.sh 

:**pytables**:    cython and numexpr python packages; hdf5 and hdf5-devel RPMS   
:**rtree**:       spatialindex, setuptools
:**mapserver**:   epel repo, bitstream-vera-*fonts* RPMs, geos
:**postgis2_91**: geos  
:**psycopg2**:    gdal, postgresql91  

Required Rolls
~~~~~~~~~~~~~~

Required rolls must be added at the same time when the lifemapper-server roll is isntalled. 
See ``Adding a roll`` section for details.

:**python**:    Python roll provides python2.7 and numpy

Building a roll
---------------

Checkout roll distribution from git repo :: 

   # git clone https://github.com/pragmagrid/lifemapper-server.git 
   # cd lifemapper-server/

To build a roll, first execute a script that downloads and installs some packages 
and RPMS that are prerequisites for other packages during the roll build stage: ::

   # ./bootstrap.sh  

When the script finishes, it prints the next step instruction to get the 
lifemapper source, default input data, and solr source code ::  

   # cd src/lmserver/
   # make prep
   #
   # cd src/lmdata-climate
   # make prep
   #
   # cd src/lmdata-species
   # make prep
   #
   # cd src/solr
   # make prep 

The first 2 commands will produce lifemappser-server-X.tar.gz 
The X is the tag in lifemapper's core Github repository . The X is recorded in 
version.mk.in.  Assumption: X is production ready revision and is a working code.
The roll will be using the X revision of lifemapper code.
 
To build individual packages ::

   # cd src/pkgname 
   # make rpm 

When all individual packages are building without errors build a roll via 
executing the command at the top level of the roll source tree ::

   # make roll

The resulting ISO file lifemapper-server-*.iso is the roll that can be added to the
frontend.

Debugging a roll
----------------

When need to update only a few packages that have changed one can rebuild only the RPMs
for changed packages and use the rest of the RPMS from the previous build. 
For example, only  rebuilding lmserver RPM will involve: ::   
  
   # cd src/lmserver
   # make clean
   # update version.mk.in with new version number to check out from Github
   # make prep
   # make rpm

Install the resulting RPM with: ::   

   # rpm -el <rpm-name>
   # rpm -i  <path-to-new-rpm-name>.rpm
   
.. _Updating : docs/Updating.rst

If you are installing the lifemapper-lmserver rpm (Lifemapper source code), 
see **Update code and scripts** at `Updating`_  to update the configuration, 
database, and restart services.   

Start using the roll, see `Using Lifemapper`_ 

Recreate roll ISO
-----------------

When updating only a few packages in the roll, there is no need to re-create 
all packages anew. After re-making updated RPMs  from the top level of roll source tree ::   

   # make reroll

The new rpms will be inlcuded in the new ISO. 

Adding a roll
-------------
The roll (ISO file) can be added (1) during the initial installation of the cluster (frontend)
or (2) to the existing frontend.


Adding a roll to a new server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Add roll ISO to your existing frontend that is configured to be 
   a central server. This procesdure is documented in the section ``Frontend 
   Central Server`` of `Rocks Users Guide <http://central6.rocksclusters.org/roll-documentation/base/6.1.1/>`_.

#. During the frontend install choose the lifemapper-server roll from the list of available rolls
   when you see ``Select Your Rolls`` screen. 

#. During the frontend install choose python roll, it is a prerequisite for lifemapper-server roll.


Adding a roll to a live frontend
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A roll can be added to the existing frontend. 
Make sure that the python roll is installed (can be downloaded from
`Rocks Downloads <http://www.rocksclusters.org/wordpress/?page_id=80>`_ )

Execute first command from the location of the ISO ::

   # rocks add roll lifemapper-server-6.2-0.x86_64.disk1.iso   
   # rocks enable roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)  
   # yum clean all
   # rocks run roll lifemapper-server > add-server.sh  
   # bash add-server.sh  > add-server.out 2>&1

After the  last command  is finished, examine the add-roll.out file for errors
and then reboot your frontend: ::

   # reboot

The reboot is needed to run a few initialization ($PKGROOT/rocks/bin/initLM) started with 
/etc/rc.d/rocksconfig.d/post-99-lifemapper-lmserver.
After the frontend boots up, check the success of initialization commands in 
log files in /tmp:
  * initLM.log
  * updateDB.log,
  * installServerCronJobs.log
  * post-99-lifemapper-lmserver.debug 

At this point the  server is ready to run lifemapper-specific commands for pipeline initialization
and data seeding, see `Using Lifemapper`_ 

Where installed roll components are
-----------------------------------

#. Created user ``lmwriter``

#. Add user  ``apache`` to ``lmwriter`` group

#. Created rocks attributes ``LM_dbserver`` and ``LM_webserver``, both set to true. 
   Currently dbserver and webserver are installed on the same host - setting ``true``
   means host's FQDN is used for configurations where needed.
   These attributes will be used in the future for possible separation of servers to different hosts.

#. **/opt/lifemapper** - prerequisites and lifemapper code

#. **/opt/lifemapper/rocks**  - scripts, templates, etc for installation management. Reequires root access for most.

#. **/opt/python/lib/python2.7/site-packages** - python prerequisites

#. **/etc/ld.so.conf.d/lifemapper-server.conf** - dynamic linker bindings
  
#. **/etc/httpd/conf.d/lifemapper.conf** - apache configuration

#. **/etc/profile.d/lifemapper.[sh,csh]** - environment settings for all users

#. **/etc/yum.repos.d** - epel and pgdg yum repos

#. **cmake, subversion, screen, fribidi, hdf4*, hdf5*, mapserver, readline-devel, 
   byacc, giflib-devel, bitstrieam-vera-*fonts*, json-c, uuid**
   - in  usual system directories /usr/bin, /usr/lib, /usr/include, etc. as required  by each RPM.
   Use ``rpm -ql X`` to find all files for a package X.

#. Postgres

   + Created user/group ``postgres``
   + **/usr/pgsql-9.1** and **/usr/share/doc** - postgres  and postgis_2
   + **/var/run/postgresql/** - postgres daemon socket files
   + **/etc/init.d/postgresql*** - init script
   + **/var/lib/pgsql/** -  database, backups, log, pid
   + **/etc/sysctl.d/postgresd** - modification for memory usage

#. Pgbouncer

   + Created user/group ``pgbouncer``, add user ``pgbouncer`` to ``postgres`` group
   + **/etc/pgbouncer/** - authentication
   + **/etc/logrotate.d/pgbouncer** - logrotate script
   + **/etc/sysconfig/pgbouncer**, **/usr/share/*** - pbbouncer. Use 
     ``rpm -ql pgbouncer`` to list all files.
   + **/var/run/postgresql/** - pgbouncer socket file
   + **/etc/init.d/pgbouncer** - init script
   + **/var/log/pgbouncer.log** - log
   + **/var/run/pgbouncer.pid** - pid

#. **/state/partition1/lm/** -  mounted as /share/lm/data
  
   + /share/lmserver/ - dailyLogs/, data/, logs/, metrics/ 
     (also, deprecated: holdJobs, jobRequests, jobs, pushJobs)
   + /share/lmserver/data/ - layers/, archive/, testlayer/.

#. **/state/partition1/lmserver/** -  mounted as /share/lmserver
   + /share/lmserver/data/ - image/, solr/, species/, /test.

#. **/state/partition1/lmscratch/** -  
   + /state/partition1/lmscratch/sessions - cherrypy sessions.
   + /state/partition1/lmscratch/tmpUpload - landing spot for uploaded files
   + /state/partition1/lmscratch/log - script and daemon logs.
   + /state/partition1/lmscratch/run - PID files.
   + /state/partition1/lmscratch/worker - Workqueue workers and Makeflow data?

#. **/var/www/tmp/** - for mapserver temp files

#. **/var/www/html/roll-documentation/lifemapper-server** - roll documentation, bare  minimum as a place holder.

Updating parts of a roll
------------------------

.. _Updating : docs/Updating.rst

If you are re-installing the lifemapper-lmserver rpm (Lifemapper source code), 
and/or the rocks-lifemapper rpm, see **Update code and scripts** at `Updating`_  
to update the configuration, database, and restart services.   


Removing a roll
---------------

When debugging a roll may need to remove the roll and all installled RPMs.
Before removing the roll stop postgres and pgbouncer services ::  
  
   # /etc/init.d/pgbouncer stop
   # /etc/init.d/postgresql-9.1 stop 

(Nadya: this script is not present on stand-alone installations of the roll)
Run this script (from the top of roll source directory) to remove all
installed RPMs, directories, users, etc ::

   # bash cleanRoll.sh

These commands remove the installed roll from Rocks database and repo ::

   # rocks remove roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)  

Using a Roll
------------

See `Using Lifemapper`_

Notes
-----

#. **Compiling pylucene**: make rpm (deprecated)

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

#. **Free memory loss**: during building a roll some java-based packages are not releasing allocated memory properly
   which results in available memory loss. After building a roll check host memory with ``free -m`` and 
   reboot if the free memory is too low. 
 
TODO
----

#. tests attributes for separation of dbserver and webserver

#. add configuration for available interfaces (EML, maps)

#. add note about compiling gdal when postgres/giflib RPms are present

#. check client caracter encoding for postgres. Currently servet is set for
   UTF8. but client appears LATIN9. See
   http://www.postgresql.org/docs/9.1/static/multibyte.html


.. _Using Lifemapper: docs/Using.rst
