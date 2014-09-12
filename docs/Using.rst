
.. hightlight:: rest

Using LifeMapper Server roll
=============================

After the roll is installed, the initial database schema, and user 
authentication are set up and postgres and pgbouncer are configured.  

#. Seed the pipeline ::   

     # nohup /opt/lifemapper/rocks/bin/initDB

   The script output is in /tmp/initDB.log.  On a host with 4Gb memory it takes ~2.5 hrs
   to complete, on a host with 2GBb memory - ~6hrs. 

#. Start the pipeline ::  

     # python2.7 /opt/lifemapper/LmDbServer/pipeline/localpipeline.py
     # other commands ...

#. Stop the pipeline ::    

     # touch /opt/lifemapper/pipeline.lm.die
