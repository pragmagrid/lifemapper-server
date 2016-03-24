
.. hightlight:: rest

Updating an existing Lifemapper Server installation
===================================================
.. contents::  

Introduction
------------
After the roll is installed, and the instance has been populated, you may want
to update the code, configuration, and/or database (in lifemapper-server*.rpm) 
and applying those changes with scripts (from rocks-lifemapper*.rpm) 
without losing data.

Update code and scripts
-----------------------

#. **Stop the pipeline** as lmserver.

   To Stop the pipeline (replace 'pragma' with the datasource name configured for this instance, i.e. bison, idigbio) ::    

     % touch /opt/lifemapper/log/pipeline.pragma.die

   **TODO:** Move to command **lm stop pipeline** 
     
#. **Copy new Lifemapper RPMs to server**, for example lifemapper-lmserver-xxxxx.x86_64.rpm 
   and rocks-lifemapper-6.2-0.x86_64.rpm
     
#. **Install changed RPMs**  as user root.  If both LmServer and LmCompute are 
   installed on this machine, you must also uninstall the LmCompute source code 
   rpm (lifemapper-lmcompute), then install the new lmcompute rpm.
   
   Remove existing RPMs with::   

     # rpm -el lifemapper-lmserver
     # rpm -el lifemapper-lmcompute # ONLY if this rpm is installed
     # rpm -el rocks-lifemapper

   Install RPMs with: ::   

     # rpm -i --force path-to-new-lifemapper-lmserver.rpm
     # rpm -i --force path-to-new-lifemapper-lmcompute.rpm  # ONLY if the old version was installed
     # rpm -i --force  path-to-new-rocks-lifemapper.rpm

#. **Temporary** (this has been added to the rocks-lifemapper "make install").
   Read the new profile file to update any environment variables::
   
     # source /etc/profile.d/lifemapper.sh
   
#. **Update configuration** with ::
   
     # /opt/lifemapper/rocks/bin/updateLM

   The ``updateLM`` script:: 

    * runs rocks/bin/confDbconnect to rewrite the python db 
      connection file, /opt/lifemapper/LmServer/db/connect.py for LM code

    * runs rocks/bin/updateIP to edit the 
      LmServer/config/config.lmserver.ini.in file with fully qualified domain 
      name or IP address, and move it to config/config.lmserver.ini

    * runs rocks/bin/updateDB to make required database changes to tables, 
      views, indexes, constraints, or functions (using the script 
      LmDbServer/dbsetup/runUpdateDBScripts.sql).  If views, types, functions 
      have not changed, this script will not only drop and recreate them.  
      If tables, constraints, or indexes have not changed, the 
      LmDbServer/dbsetup/updateDatabases.sql file should be empty.
   
    * restarts postgresql, pgbouncer, and apache services.  The ``pgbouncer`` 
      service must be restarted after a new connect.py file is created.  Apache 
      must be restarted to pick up any code changes.

    * Logs results in /tmp/updateLM.log (pre 1.0.9.lw, lifemapper-update.log)
    
   **TODO:** Move to command **lm update server config**
   
#. **Check results** 
   
   #. If pgbouncer failed to restart, causing the database updates to fail
   
      #. Check for lock files in /var/run/pgbouncer/, /var/lock/subsys/ , and
         /var/run/postgresql/ (owned by pgbouncer).
      #. Double check that pgbouncer is not running
      #. Delete lock files
      #. Restart pgbouncer
      #. Re-run the failed command  (from updateLM)::
          
         # /rocks/bin/updateDB
         
      #. Check the output in /tmp/updateDB.log
     
   
#. For updating from source code **version 1.0.3.lw or below to 1.0.4.lw and 
   above**, the configuration files (for lmcompute and lmserver) are newly 
   separated.  The environment variable holding configuration file must be 
   added to the apache configuration by ::
   
   # cat /opt/lifemapper/rocks/etc/lifemapper-sysconfig-httpd >> /etc/sysconfig/httpd

Add a new computation server
----------------------------

.. _Using : docs/Using.rst#add-a-new-lmcompute

.. _Add a new LmCompute : docs/Using.rst#add-a-new-lmcompute

   Instructions at **Add a new LmCompute** at `Using`_
#. Follow instructions at  `Add a new LmCompute`_


Add/change Archive User
-----------------------

#. Change the archive user  as ``root`` 

   Add ARCHIVE_USER to the [LmCommon - common] section of site.ini file.  
   
   The ARCHIVE_USER must own all occurrence and scenario records, so add 
   existing (or new) climate data as this new user :: 

     # $PYTHON /opt/lifemapper/LmDbServer/tools/initCatalog.py 

   **TODO:** Move to command **lm init catalog**

#. **Start the pipeline**  as ``lmserver`` to initialize all new jobs with the new species data.::

     % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &
   
   **TODO:** Move to command **lm start pipeline**

          
Update data
-----------

#. **Stop the pipeline** as lmserver.

   To Stop the pipeline (replace 'pragma' with the datasource name configured for 
   this instance, i.e. gbif, bison, idigbio) ::    

     % touch /opt/lifemapper/log/pipeline.pragma.die
     
   **TODO:** Move to command **lm stop pipeline**  
     
Add/change climate data
~~~~~~~~~~~~~~~~~~~~~~~
     
#. ** Download, catalog new climate data **  as ``root``  

   Add SCENARIO_PACKAGE to the [LmServer - pipeline] section of config/site.ini file.  
   Available scenario packages are defined in the CLIMATE_PACKAGES dictionary in
   LmDbServer.tools.bioclimMeta.  
   
   To change the default scenarios used by the pipeline to new scenarios defined
   in the package, add DEFAULT_MODEL_SCENARIO, DEFAULT_PROJECTION_SCENARIOS 
   to the site.ini file using scenario codes documented in the CLIMATE_PACKAGES 
   dictionary. 

   Download data from http://lifemapper.org/dl/<SCENARIO_PACKAGE>.tar.gz. 
   Uncompress into the /share/lmserver/data/climate/ directory.

   Run the script to install scenario data with the configured ARCHIVE_USER ::  

     # $PYTHON /opt/lifemapper/LmDbServer/tools/initCatalog.py scenario 
     
   **TODO:** Move to command **lm init catalog scenario**

#. **Start the pipeline**  as lmserver to initialize all new jobs with the new scenarios. ::

     % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &
     
   **TODO:** Move to command **lm start pipeline**
   
Add/change species data
~~~~~~~~~~~~~~~~~~~~~~~

#. **Download, catalog new species data**  as ``root`` 

   As user root, add or edit the sections ``[LmServer - environment]`` and ``[LmServer - pipeline]`` 
   in ``config/site.ini`` to include :: 

     [LmServer - environment]
     DATASOURCE: USER

     [LmServer - pipeline]
     USER_OCCURRENCE_CSV: 
     USER_OCCURRENCE_META: 

   Download tar.gz files and uncompress into /share/lmserver/data/species/
   
#. **Start the pipeline**  as ``lmserver`` to initialize all new jobs with the new species data.::

     % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &
   
   **TODO:** Move to command **lm start pipeline**

Add all data (unfinished)
~~~~~~~~~~~~~~~~~~~~~~~~~

#. **Download, catalog new user, scenario, species, taxonomy**  as ``root`` 
   **TODO: This is not yet working** it will do all above steps 
   
   Download the data specified in site.ini variables and add metadata using :: 
   
     # /opt/lifemapper/LmDbServer/tools/addInputData

   
Test
----

#. **Test the LmWebServer** setup as user ``lmwriter``
  
   To become lmwriter use do: ::

     # su - lmwriter
     
   As lmwriter user, execute the following to check if the web server is setup correctly, 
   successful output is similar to that shown under each.   ::  

     % python2.7 /opt/lifemapper/LmWebServer/scripts/createTestUser.py
       Successfully created user
       
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkJobServer.py)
       30 Mar 2015 14:17 MainThread.log.debug line 80 DEBUG    {'epsgcode': '4326', 'displayname': 'Test Chain57111.8872399', 'name': 'Test points57111.8872399', 'pointstype': 'shapefile'}
       30 Mar 2015 14:17 MainThread.log.debug line 80 DEBUG    Test Chain57111.8872399
       30 Mar 2015 14:17 MainThread.log.warning line 136 WARNING  Database connection is None! Trying to re-open ...
       Closed/wrote dataset /share/lmserver/data/archive/unitTest/000/000/000/194/pt_194.shp
       creating index of new  LSB format
       30 Mar 2015 14:17 MainThread.log.debug line 80 DEBUG       inserted job to write points for occurrenceSet 194 in MAL
       Occurrence job id: 962
       Model job id: 963
       Projection job id: 964
     
   This test shows the result of URLs on the local server.  EML is not configured, 
   so errors for this format may be ignored.  We will add configuration to identify 
   installed formats.  ::  

     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkLmWeb.py
       30 Mar 2015 14:17 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net
       30 Mar 2015 14:17 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/projections
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/scenarios
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/rad/
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/rad/experiments
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/rad/layers
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/atom
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/csv
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/eml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/html
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/json
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/kml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/shapefile
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/occurrences/117/xml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/scenarios/3/atom
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/scenarios/3/eml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/scenarios/3/html
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/scenarios/3/json
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/scenarios/3/xml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/atom
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/eml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/html
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/json
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/kml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/model
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/status
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/experiments/118/xml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/ascii
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/atom
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/eml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG     returned HTTP code: 500
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/html
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/json
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/kml
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/raw
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/tiff
       30 Mar 2015 14:18 MainThread.log.debug line 80 DEBUG    Url: http://pc-167.calit2.optiputer.net/services/sdm/layers/58/xml
       
  **TODO:** Move to commands **lm test <user | jobserver | web>**
  
#. **Run the pipeline**  as user lmwriter

   To start the pipeline  ::  

     % python2.7 /opt/lifemapper/LmDbServer/pipeline/localpipeline.py

   To Stop the pipeline  ::    

     % touch /opt/lifemapper/pipeline.pragma.die
     
     
   **TODO:** Move to commands **lm start/stop pipeline**
   
#. After the pipeline has run for awhile, and there are some completed jobs, test this:
 
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkLmWeb.py

   **TODO:** Move to command **lm test web**
