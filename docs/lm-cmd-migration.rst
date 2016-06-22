.. highlight:: rest

`lm` Command Migration
======================
.. contents::

Introduction
------------
The new 'lm' commands are intended to simplify the install, configuration, 
testing, and running of the Lifemapper software.

Commands to migrate
-------------------
        
Commands executed by lmwriter

 #. /opt/lifemapper/LmWebServer/tests/scripts/createTestUser.py move to
    lm test insert user
 #. /opt/lifemapper/LmWebServer/tests/scripts/checkLmWeb.py move to 
    lm test webservices
 #. /opt/lifemapper/LmDbServer/pipeline/archivist.py start/stop move to 
    lm start/stop archivist
    
Commands executed by root ::

 #. $PYTHON /opt/lifemapper/LmDbServer/tools/registerCompute.py move to 
    lm insert compute
