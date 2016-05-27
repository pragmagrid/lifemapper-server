
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

#. **Stop the archivist** as lmwriter ::    

     % $PYTHON /opt/lifemapper/LmDbServer/pipeline/archivist.py stop

   **TODO:** Move to command **lm stop archivist** 
     
#. **Stop the jobMediator** as lmwriter::

     lmwriter$ $PYTHON /opt/lifemapper/LmCompute/tools/jobMediator.py stop

   **TODO:** Move to command **lm stop jobs** 

Update everything
-----------------

#. **Copy new LmServer and LmCompute rolls to server**, for example::

   # scp lifemapper-compute-6.2-0.x86_64.disk1.iso  server.lifemapper.org:
   # scp lifemapper-server-6.2-0.x86_64.disk1.iso server.lifemapper.org:

#. **Add a new roll and rpms**, ensuring that old rpms/files are replaced::

   # rocks add roll lifemapper-server-6.2-0.x86_64.disk1.iso clean=1
   # rocks add roll lifemapper-compute-6.2-0.x86_64.disk1.iso clean=1
   
#. **Remove some rpms manually** 
   
   #. Do this just in case the rpm versions have not changed, to ensure that
      scripts are run.  If the configuration (rocks-lifemapper, rocks-lmcompute) 
      rpms are new, the larger version git tag will force the new rpm to be 
      installed, **but if the rpm versions have not changed**, you must remove 
      them to ensure that the installation scripts are run.  Even if the source 
      code rpms (lifemapper-lmserver and lifemapper-compute) have changed, 
      removing them avoids error messages about file conflicts.::  

      # rpm -el lifemapper-lmserver rocks-lifemapper \
                lifemapper-lmcompute rocks-lmcompute \
                lifemapper-climate-data lifemapper-seed-data

#. **Create distribution**::

   # rocks enable roll lifemapper-compute lifemapper-server
   # (cd /export/rocks/install; rocks create distro; yum clean all)

#. **Create and run LmServer/LmCompute scripts**::

   # rocks run roll lifemapper-server > add-server.sh 
   # rocks run roll lifemapper-compute > add-compute.sh 
   # bash add-server.sh > add-server.out 2>&1
   # bash add-compute.sh > add-compute.out 2>&1
    
#. **Reboot front end** ::  

   # reboot
   
#. **Remove some compute-node rpms manually** 
   
   #. Do this just in case the rpm versions have not changed, to ensure that
      scripts are run.::  

      # rocks run host compute 'rpm -el lifemapper-lmcompute rocks-lmcompute'

#. **Rebuild the compute nodes** ::  

   # rocks set host boot compute action=install
   # rocks run host compute reboot 

#. **Temporary** If necessary, fix permissions on nodes.  Note: this should be 
   run during the post process on reboot (nodes/lifemapper-compute-base.xml)::

   # rocks run host compute "chgrp -R lmwriter /state/partition1/lm"
   # rocks run host compute "chmod -R g+ws /state/partition1/lm"
   # rocks run host compute "chgrp -R lmwriter /opt/lifemapper/.java"
   # rocks run host compute "chmod -R g+ws /opt/lifemapper/.java"

#. **Test database population** ::  

   # export PGPASSWORD=`grep sdlapp /opt/lifemapper/rocks/etc/users | awk '{print $2}'`
   # psql -U sdlapp -d mal
   # select scenariocode, userid from scenario;

