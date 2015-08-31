
.. hightlight:: rest

Using Lifemapper Server roll
=============================

After the roll is installed, the initial database schema, and user 
authentication are set up and postgres and pgbouncer are configured.  

#. **Enable public http access**.
 
   Follow instructions at: localhost/roll-documentation/base/6.2/enable-www.html
   
#. **Populate the database**.

   This command must be executed as user ``root`` ::  

     # nohup /opt/lifemapper/rocks/bin/initDB

   The script output is in /tmp/initDB.log. Examine the script output: ::
   
   If (and only if) the DATASOURCE is GBIF, the script takes ~50 min to complete 
   on a host with 4Gb memory. The last command should give output similar to: ::
     ...
     Static Stenus flavidulus
     Inserted 778716; updated 22
     # End Tue Sep 30 20:18:42 PDT 2014
     
   with the number of inserted record as stated above.

#. Check the available memory: ::

     # free -m
     
   If the output indicates 200-300 Mb, reboot the VM: ::
     
     # reboot
     
#. **Register LmCompute instance(s)**  as root  

   Run the script to install LmCompute instance configured for this LmServer  ::  

     # $PYTHON /opt/lifemapper/bin/registerCompute.py 

   Optionally, edit configured LmCompute values in the script and re-run

   
#. **Test the LmWebServer** setup
  
   All the commands below must be executed as user ``lmwriter``. To become lmwriter use do: ::

     # su - lmwriter
     
   As lmwriter user, execute the following to check if the web server is setup correctly, 
   successful output is similar to that shown under each.   ::  

     % python2.7 /opt/lifemapper/LmWebServer/scripts/createTestUser.py
       Successfully created user
       
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkJobServer.py
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

   To Stop the pipeline (replace 'gbif' with the datasource name configured for this instance, i.e. bison, idigbio) ::    

     % touch /opt/lifemapper/pipeline.gbif.die
     
     
#. After the pipeline has run for awhile, and there are some completed jobs, test this:
 
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkLmWeb.py

