
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
     root# service postgresql stop

Update everything
-----------------

#. **Copy new LmCompute roll and LmServer RPMs to server**, for example::

   # scp lifemapper-compute-6.2-0.x86_64.disk1.iso  server.lifemapper.org:
   # scp lifemapper-lmserver-<version>-1.x86_64.rpm server.lifemapper.org:
   # scp rocks-lifemapper-6.2-0.x86_64.rpm          server.lifemapper.org:

#. **Remove old LmCompute roll and LmServer rpms**, for example::

   # rocks remove roll lifemapper-compute
   # rpm -el lifemapper-lmserver
   # rpm -el rocks-lifemapper
   # (cd /export/rocks/install; rocks create distro)
   # yum clean all

#. **Add a new roll and rpms**, ensuring that old rpms/files are replaced::

   # rocks add roll lifemapper-compute-6.2-0.x86_64.disk1.iso clean=1
   # rocks enable roll lifemapper-compute
   # rpm -i --force path-to-new-lifemapper-lmserver.rpm
   # rpm -i --force  path-to-new-rocks-lifemapper.rpm

#. **Create distribution**::

   # (cd /export/rocks/install; rocks create distro)
   # yum clean all

#. **Create and run LmCompute scripts**::

   # rocks run roll lifemapper-compute > add-compute.sh 
   # bash add-compute.sh > add-compute.out 2>&1
    
#. **Reboot front end** ::  

   # reboot

#. **Update LmServer configuration** with ::
   
     # /opt/lifemapper/rocks/bin/updateLM
   
#. **Rebuild the compute nodes** ::  

   # rocks set host boot compute action=install
   # rocks run host compute reboot 

#. **Temporary** On EACH node fix permissions.  Note: this is run on FE by 
   script created by run roll. Commands are in lifemapper-compute-base.xml::

   # /bin/chgrp -R lmwriter /state/partition1/lm
   # /bin/chmod -R g+ws /state/partition1/lm

   # /bin/chgrp -R lmwriter /opt/lifemapper/.java
   # /bin/chmod -R g+ws /opt/lifemapper/.java


