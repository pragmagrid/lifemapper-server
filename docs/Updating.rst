
.. hightlight:: rest

Updating an existing Lifemapper Server installation without losing data
=============================
.. contents::  

Introduction
----------------
After the roll is installed, and the instance has been populated, you may want
to update the code, configuration, and/or database (in lifemapper-server*.rpm) 
and applying those changes with scripts (from rocks-lifemapper*.rpm) 
without losing data.

Update code and scripts
------------------------

#. **Stop the pipeline** as lmserver.

   To Stop the pipeline (replace 'pragma' with the datasource name configured for this instance, i.e. bison, idigbio) ::    

     % touch /opt/lifemapper/log/pipeline.pragma.die
     
#. **Copy new Lifemapper RPMs to server**.

     # lifemapper-server-xxxxx.x86_64.rpm 
     # rocks-lifemapper-6.2-0.x86_64.rpm
     
#. **Install changed RPMs **  as user root

Install RPMs with: ::   

   # rpm -el lifemapper-server
   # rpm -i path-to-new-lifemapper-server.rpm
   # rpm -el rocks-lifemapper
   # rpm -i  path-to-new-rocks-lifemapper.rpm
   # /opt/lifemapper/rocks/bin/updateLM

   If the source code rpm is on a machine with both LmServer and LmCompute rolls,
   add the option --force to force overwriting shared code.
   
   The ``updateLM`` script 
    * runs confDbconnect to rewrite the python db connection file for LM code
    * runs updateIP to fill in newly installed config.ini file with IP address
    * runs updateDB to make required database changes to tables, views, or functions  

   The script output is in /tmp/updateLM.log. 
     
Update data
------------------------

#. **Stop the pipeline** as lmserver.

   To Stop the pipeline (replace 'pragma' with the datasource name configured for 
   this instance, i.e. gbif, bison, idigbio) ::    

     % touch /opt/lifemapper/log/pipeline.pragma.die
     
Add a new computation server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. **Register LmCompute instance(s)**  as root  

   As user root, add the section ``[LmServer - registeredcompute]`` in 
   ``config/site.ini`` to include :: 

     [LmServer - registeredcompute]
     COMPUTE_NAME: <required>
     COMPUTE_IP:  <required>
     COMPUTE_IP_MASK:
     COMPUTE_CONTACT_USERID:  <required>
     COMPUTE_CONTACT_EMAIL:  <required **only if new user**>
 
   get/copy keys from config.ini). The new record requires COMPUTE_NAME, 
   COMPUTE_IP, and COMPUTE_CONTACT_USERID.  If the COMPUTE_CONTACT_USERID does 
   not already exist in the database, COMPUTE_CONTACT_EMAIL is also required.
   
   If LmServer will be communicating with LmCompute instance installed on the 
   same cluster, use the private IP address and CIDR to allow all compute nodes
   access to jobs.  

   Run the script to install LmCompute instance configured for this LmServer  ::  

     # $PYTHON /opt/lifemapper/LmDbServer/tools/registerCompute.py 

Add/change Archive User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. Change the archive user  as ``root`` 

   Add ARCHIVE_USER to the [LmCommon - common] section of site.ini file.  
   
   The ARCHIVE_USER must own all occurrence and scenario records, so add 
   existing (or new) climate data as this new user :: 

     # $PYTHON /opt/lifemapper/LmDbServer/tools/initCatalog.py 


#. **Start the pipeline**  as ``lmserver`` to initialize all new jobs with the new species data.

   % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &

Add/change climate data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     
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

#. **Start the pipeline**  as lmserver to initialize all new jobs with the new scenarios.

   % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &
     

Add/change species data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ** Download, catalog new species data **  as ``root`` 

   As user root, add or edit the sections ``[LmServer - environment]`` and ``[LmServer - pipeline]`` 
   in ``config/site.ini`` to include :: 

     [LmServer - environment]
     DATASOURCE: USER

     [LmServer - pipeline]
     USER_OCCURRENCE_CSV: 
     USER_OCCURRENCE_META: 

   Download tar.gz files and uncompress into /share/lmserver/data/species/
   
#. **Start the pipeline**  as ``lmserver`` to initialize all new jobs with the new species data.

   % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &
   

Add all data (unfinished)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#. ** Download, catalog new user, scenario, species, taxonomy **  as ``root`` 
   **TODO: This is not yet working** it will do all above steps 
   Download the data specified in site.ini variables and add metadata using 
   
     # /opt/lifemapper/LmDbServer/tools/addInputData

#. **Start the pipeline**  as lmserver to initialize all new jobs with the new scenarios.

   % $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py &

Test
------------------------

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

#. **Run the pipeline**  as user lmwriter

   To start the pipeline  ::  

     % python2.7 /opt/lifemapper/LmDbServer/pipeline/localpipeline.py

   To Stop the pipeline  ::    

     % touch /opt/lifemapper/pipeline.pragma.die
     
     
#. After the pipeline has run for awhile, and there are some completed jobs, test this:
 
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkLmWeb.py)

