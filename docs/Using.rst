
.. hightlight:: rest

Using Lifemapper Server roll
============================
.. contents::  

After the roll is installed, the initial database schema, and user 
authentication are set up and postgres and pgbouncer are configured.  
   
Populate the database
~~~~~~~~~~~~~~~~~~~~~

#. Initialize the database **as user root** ::  

     # /opt/lifemapper/rocks/bin/initDB > /tmp/initDB.log 2>&1

  #. The script output is in ``/tmp/initDB.log``. Examine the script output: ::
   
  #. If (and only if) the DATASOURCE is GBIF, the script takes ~50 min to complete 
     on a host with 4Gb memory. The last command should give output similar to: ::
    
     Static Stenus flavidulus
     Inserted 778716; updated 22
     # End Tue Sep 30 20:18:42 PDT 2014
  
  #. Check the available memory ::

     # free -m
     
  #. If the output indicates 200-300 Mb, reboot the VM: ::
     
     # reboot
     
#. **Deprecated: Create a layers package** ::
   
   First connect to postgres and find the 
   As ``lmwriter``, create a package to pre-populate a LmCompute instance with 
   the layers that will be used for jobs for this server.  You will need the 
   SCENARIO_PACKAGE variable (i.e. 30sec-present-future-SEA) and the scenario 
   ids (i.e. 1 through 5).  For small pragma tests, using only openModeller  
   algorithms, add the option --fileTypes=t to include only TIFFs (reducing the 
   size of input data).  If you want to include ASCII files (needed for 
   ATT Maxent algorithm), leave the --filetypes option out - the default will
   include both ASCII and TIFF.::
   
   % $PYTHON /opt/lifemapper/LmDbServer/tools/createScenarioPackage.py --fileTypes=t 30sec-present-future-SEA 1 2 3 4 5
     
Add a new LmCompute
~~~~~~~~~~~~~~~~~~~
     
#. **Register LmCompute instance(s)**  as root  

   As user ``root``, add the section ``[LmServer - registeredcompute]`` in ``config/site.ini`` to include :: 

     [LmServer - registeredcompute]
     COMPUTE_NAME: <required>
     COMPUTE_IP:  <required  **private IP if compute nodes from this cluster**>
     COMPUTE_IP_MASK:  <required **CIDR if compute nodes from this cluster**>
     COMPUTE_CONTACT_USERID:  <required>
     COMPUTE_CONTACT_EMAIL:  <required **only if new user**>


   The new record requires COMPUTE_NAME, COMPUTE_IP, and COMPUTE_CONTACT_USERID.  
   If the COMPUTE_CONTACT_USERID does not already exist in the database, 
   COMPUTE_CONTACT_EMAIL is also required.
   
   **IMPORTANT:** When running LmServer and LmCompute on the same cluster, 
   nodes (in LmCompute functions) will contact the  
   frontend through the private network.  In this case, make sure to put the 
   private network in the COMPUTE_IP, and a CIDR in the COMPUTE_MASK.  
   **TODO: Rename those variables! **

   As user ``root``, run the script to install LmCompute instance configured for this LmServer  ::  

     $ $PYTHON /opt/lifemapper/LmDbServer/tools/registerCompute.py 

Test the LmWebServer setup
~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Begin by checking the webservices.  Open a web browser to the FQDN or IP of 
   the server, then append '/services' to the address.  If the webserver returns
   an error message, look at the following to determine the cause
   
   #. Make sure web access is enabled (instructions at 
      http://yeti.lifemapper.org/roll-documentation/base/6.2/enable-www.html)
   #. /var/log/httpd/lifemapper_error
   #. /var/log/messages
   #. /opt/lifemapper/log/cherrypyErrors.log
   #. /opt/lifemapper/log/web.log
    
#. The following commands must be executed as user ``lmwriter``. To become ``lmwriter`` do: ::

     # su - lmwriter
     
#. Create a test user: ::  

     $ $PYTHON /opt/lifemapper/LmWebServer/tests/scripts/createTestUser.py  > /tmp/createTestUser.log 2>&1
       Successfully created user
       
#. Check job server: ::  

     $ $PYTHON /opt/lifemapper/LmWebServer/tests/scripts/checkJobServer.py > /tmp/checkJobServer.log 2>&1
     
       27 Sep 2015 13:57 MainThread.log.debug line 80 DEBUG    {'epsgcode': '4326', 'displayname': 'Test Chain57292.8734326', 'name': 'Test points57292.8734326', 'pointstype': 'shapefile'}
       27 Sep 2015 13:57 MainThread.log.debug line 80 DEBUG    Test Chain57292.8734326
       27 Sep 2015 13:57 MainThread.log.warning line 136 WARNING  Database connection is None! Trying to re-open ...
       27 Sep 2015 13:57 MainThread.log.debug line 80 DEBUG       inserted job to write points for occurrenceSet 1 in MAL
       Closed/wrote dataset /share/lmserver/data/archive/unitTest/000/000/000/194/pt_94.shp
       creating index of new  LSB format
       27 Sep 2015 13:57 MainThread.log.debug line 80 DEBUG       inserted job to write points for occurrenceSet 94 in MAL
       Occurrence job id: 148
       Model job id: 149
       Projection job id: 150
     
#. Check local URLs.  This test shows the result of URLs on the local server.  
   EML is not configured, so errors for this format may be ignored.  We will add 
   configuration to identify installed formats.  ::  

     $ $PYTHON /opt/lifemapper/LmWebServer/tests/scripts/checkLmWeb.py  > /tmp/checkLmWeb.log 2>&1
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/experiments
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/layers
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/projections
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/scenarios
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/rad/
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/rad/experiments
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/rad/layers
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/scenarios/5/atom
       ...
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/layers/94/ascii
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG     returned HTTP code: 500
       27 Sep 2015 14:38 MainThread.log.debug line 80 DEBUG    Url: http://lm.public/services/sdm/layers/94/atom
       ...

Run the pipeline
~~~~~~~~~~~~~~~~

#. To start the pipeline as user ``lmwriter`` do ::  

     $ $PYTHON /opt/lifemapper/LmDbServer/pipeline/localpipeline.py

#. To stop the pipeline: ::    

     $ touch /opt/lifemapper/log/pipeline.<DATASOURCE>.die
     
#. Check URLs on completed jobs.  After the pipeline has run for awhile, 
   **and LmCompute has pulled, computed, and returned some jobs**, as 
   user ``lmwriter``, check URLs again: ::
 
     $ $PYTHON /opt/lifemapper/LmWebServer/tests/scripts/checkLmWeb.py

