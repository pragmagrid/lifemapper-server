
.. hightlight:: rest

Using LifeMapper Server roll
=============================

After the roll is installed, the initial database schema, and user 
authentication are set up and postgres and pgbouncer are configured.  

#. **Seed the pipeline**.

   This command must be executed as user ``root`` ::  

     # nohup /opt/lifemapper/rocks/bin/initDB

   The script output is in /tmp/initDB.log.  On a host with 4Gb memory it takes ~2.5 hrs
   to complete, on a host with 2GBb memory - ~6hrs. 

The commands below must be executed as user ``lmwriter``

#. **Test the LmWebServer** 
  
   These commands are executed to check if the web server is setup correctly ::  

     % python2.7 /opt/lifemapper/LmWebServer/scripts/createTestUser.py
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkJobServer.py)
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkLmWeb.py

#. **Run the pipeline**  

   To start the pipeline  ::  

     % python2.7 /opt/lifemapper/LmDbServer/pipeline/localpipeline.py

   To Stop the pipeline  ::    

     % touch /opt/lifemapper/pipeline.lm.die
