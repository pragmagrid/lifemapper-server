
.. hightlight:: rest

Using Lifemapper Server roll
=============================

After the roll is installed, the initial database schema, and user 
authentication are set up and postgres and pgbouncer are configured.  

#. **Seed the pipeline**.

   This command must be executed as user ``root`` ::  

     # nohup /opt/lifemapper/rocks/bin/initDB

   The script output is in /tmp/initDB.log.  On a host with 4Gb memory the script takes ~50 min 
   to complete. Examine the script output begininng and end (the output file is 63Mb): ::
   
     # head /tmp/initDB.log
     # tail /tmp/initDB.log
     
   The last command shoudl give output similar to: ::

     ...
     Static Stenus flavidulus
     Inserted 778716; updated 22
     # End Tue Sep 30 20:18:42 PDT 2014
     
   with the number of inserted record as stated above.

#. Check the available memory: ::

     # free -m
     
   If the output indicates 200-300 Mb, reboot the VM: ::
     
     # reboot
   
#. **Test the LmWebServer** setup
  
   All the commands below must be executed as user ``lmwriter``. To become lmwriter use do: ::

     # su - lmwriter
     
   These commands are executed to check if the web server is setup correctly ::  

     % python2.7 /opt/lifemapper/LmWebServer/scripts/createTestUser.py
       Successfully created user  (command output if successful)
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkJobServer.py)
     % python2.7 /opt/lifemapper/LmWebServer/scripts/checkLmWeb.py

#. **Run the pipeline**  as user lmwriter

   To start the pipeline  ::  

     % python2.7 /opt/lifemapper/LmDbServer/pipeline/localpipeline.py

   To Stop the pipeline  ::    

     % touch /opt/lifemapper/pipeline.lm.die
