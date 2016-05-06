
.. hightlight:: rest

Updating an existing Lifemapper Compute installation
====================================================
.. contents::  

Introduction
------------
For systems with both the LmCompute and LmServer rolls installed, you will want 
to update the LmCompute roll and LmServer rpms (lifemapper-lmserver, rocks-lifemapper) 
without losing data.

.. contents::  

Stop processes
--------------

#. **Stop the pipeline** as lmwriter (replace 'pragma' with the datasource name 
   configured for this instance, i.e. bison, idigbio) ::    

     % touch /opt/lifemapper/log/pipeline.pragma.die

   **TODO:** Move to command **lm stop pipeline** 
     
#. **Stop the jobMediator** as lmwriter::

     lmwriter$ $PYTHON /opt/lifemapper/LmCompute/tools/jobMediator.py stop

   **TODO:** Move to command **lm stop jobs** 
   
#. **Stop database processes** as root::

     root# service pgbouncer stop
     root# service postgresql-9.1 stop

Update everything
-----------------

#. **Copy new LmServer and LmCompute rolls to server**, for example::

   # scp lifemapper-compute-6.2-0.x86_64.disk1.iso  server.lifemapper.org:
   # scp lifemapper-server-6.2-0.x86_64.disk1.iso server.lifemapper.org:

#. **Add a new roll and rpms**, ensuring that old rpms/files are replaced::

   # rocks add roll lifemapper-server-6.2-0.x86_64.disk1.iso clean=1
   # rocks add roll lifemapper-compute-6.2-0.x86_64.disk1.iso clean=1
   
#. **Remove some rpms manually** 
   
   #. If the **lifemapper-lmserver** and **lifemapper-compute** rpms are new, 
      the larger version git tag will force the new rpm to be installed. If the 
      rpm has not changed, you will need to remove it to ensure that the new rpm 
      is installed and installation scripts are run.::  

      # rpm -el lifemapper-lmserver
      # rpm -el lifemapper-lmcompute
   
   #. Previously, the **rocks-lifemapper** and **rocks-lmcompute** rpms did not 
      have a version, and so defaulted to rocks version 6.2 
      (rocks-lifemapper-6.2-0.x86_64.rpm, rocks-lmcompute-6.2-0.x86_64.rpm).  
      The new version, 1.0.x (i.e. rocks-lifemapper-1.0.0-0.x86_64.rpm) has a 
      lower revision number than the previous rpm, so 1.0.x will not be 
      installed unless 6.2 is forcibly removed.::

      # rpm -el rocks-lifemapper
      # rpm -el rocks-lmcompute

   **Note**: Make sure to change the rpm version when modifying scripts  
   to make sure that the rpm is replaced and scripts are run.

#. **Create distribution**::

   # rocks enable roll lifemapper-compute
   # rocks enable roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)
   # yum clean all

#. **Create and run LmServer/LmCompute scripts**::

   # rocks run roll lifemapper-server > add-server.sh 
   # bash add-server.sh > add-server.out 2>&1
   # rocks run roll lifemapper-compute > add-compute.sh 
   # bash add-compute.sh > add-compute.out 2>&1
    
#. **Reboot front end** ::  

   # reboot
   
#. **Rebuild the compute nodes** ::  

   # rocks set host boot compute action=install
   # rocks run host compute reboot 

#. **Temporary** On EACH node fix permissions.  Note: this is run on FE by 
   script created by run roll. Commands are in lifemapper-compute-base.xml::

   # /bin/chgrp -R lmwriter /state/partition1/lm
   # /bin/chmod -R g+ws /state/partition1/lm

   # /bin/chgrp -R lmwriter /opt/lifemapper/.java
   # /bin/chmod -R g+ws /opt/lifemapper/.java


