
.. hightlight:: rest

Student Challenge 
===================================

.. contents::  

Build Lifemapper Biodiversity Infrastructure 
----------------------------------------------

Use VirtualBox Rocks Cluster images to install and run Lifemapper 
on your laptop. The main steps are :

#. Install VirtualBox on your laptop 

#. Download VM image for cluster frontend 

#. Import VM in VirtualBox and set shared folders
   based on your laptop folders availability.

#. Download ISO image for lifemapepr-server software 
   into the folder on your laptop that will be used as a shared folder
   by your VM.

#. Start VM and login as root

#. Install Lifemapper server roll (see below)  

#. Start using Lifemapper server roll (see below)
    
Downloads
~~~~~~~~~~~
All the downloads that you need for the challenge
are av ailable from the `PRAGMA 27 Challenge  site
<http://pragma27.pragma-grid.net/dct/page/70007>`_ and include

#. **rocks611.ova**  - cluster frontend virtual image

#. **lifemapper-server-6.1.1-0.x86_64.disk1.iso**  - lifemapper-server roll.
   This is an  ISO image that inlcudes all needed lifemapepr server software and configuration. 

#. Instructions about VirtualBox installation and setup. 

Optional 

#. **rocks611-compute-0-0.ova**  - cluster compute node virtual image.
   This image is not needed for lifemapepr server to work but gives one an
   opportunity to explore the whole cluster setup. 


Install Lifemapepr roll
-------------------------

A roll can be added to the existing frontend. 
Assume that your downloaded lifemapper-server ISO is available in the folder that
is mounted as ``data1``.  This means that on the VM the directory with the ISO is ``/media/sf_data1``

**Check the ISO md5sum signature:** ::  

   # md5sum /media/sf_data1/lifemapper-server-6.1.1-0.x86_64.disk1.iso 

The output should be: ::

   fe77b42373910eafc3db243aca70d596 /media/sf_data1/lifemapper-server-6.1.1-0.x86_64.disk1.iso

If you see a different signature it means the ISO is corrupted and needs to be
downloaded anew. 

**Execute all commands below to install the roll:** ::

   # rocks add roll /media/sf_data1/lifemapper-server-6.1-0.x86_64.disk1.iso   
   # rocks enable roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)  
   # yum clean all
   # rocks run roll lifemapper-server > add-roll.sh  

The last command creates a script ``add-roll.sh`` in your current directory.
The scirpt contains all the commands that will be executed on the system to
install the roll software. Examine the scirpt and then run it : ::

   # bash add-roll.sh  > add-roll.out 2>&1

After the command  is finished, examine the add-roll.out file for errors
and then reboot your frontend: ::

   # reboot

The reboot is needed to run a few initialization commands. 
After the frontend boots up login as root and check the ``/tmp/lifemapper-config.log`` file 
to check the status of initialization commands.

Use Lifemapepr roll 
------------------------

After the roll install is completed the frontend is ready and configured as 
for Lifemapepr LmDbServer and LmWebServer components. To use the roll and run 
lifemapper-specific commands for pipeline initialization
and data seeding, see `Using Lifemapper <Using.rst>`_


Info: where installed roll components are
-----------------------------------------------

This secitons outlines where installed lifemapper servers components are
installed and where to expect log files.

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

#. **/etc/yum.repos.d** - elgis and pgdg yum repos

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

#. **/state/partition1/lmserver/** -  mounted as /share/lmserver/
  
   + /share/lmserver/data/ - ClimateData/, ESRIDATA/, image/, models/, species/.
   + /share/lmserver/log/ - pipeline logs. Alos available via link ``/opt/lifemapper/log``

#. **/var/lib/lm2/** -  pylucene  index and sessions

#. **/var/www/tmp/** - for mapserver temp files


