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

 #. ``test insert user`` :
    * LmWebServer/tests/scripts/createTestUser.py
 #. ``test webservices``
    * LmWebServer/tests/scripts/checkLmWeb.py
 #. ``start/stop`` 
    * ``archivist``: runs LmDbServer/pipeline/archivist.py, in the future, this
      will also accept an optional filename with values for a "user" archive 
    * ``makeflow``: currently LmCompute/tools/jobMediator.py, this will change
      very soon
    
    
Commands executed by root ::

 #. ``insert compute``
    * LmDbServer/tools/registerCompute.py
 #. ``init db`` 
    * ``postgresql``: runs init_db in rocks/bin/initLM to creates db, starts
      services with default config, create db users, install postgis functions, 
      create new config and auth files
    * ``config``: create new config and auth files, runs 
      rocks/bin/confPostgres pg/ca, rocks/bin/confPgbouncer
    * ``connect``: update connection file for python code, runs 
      rocks/bin/confDbconnect
    * ``define``: create lifemapper tables, views, functions,
      runs define_lm_database and add_lm_functions in rocks/bin/initLM
    * ``update``: create lifemapper tables, views, functions,
      runs update_lm_tables and add_lm_functions in rocks/bin/initLM
    * ``populate``: insert metadata for archive data inputs, runs
      rocks/bin/fillDB (options may be enabled for this script)
 #. ``add cron jobs``
    * ``compute``: runs rocks/bin/installComputeCronJobs
    * ``server``: runs rocks/bin/installServerCronJobs
 #. ``update IP``: runs rocks/bin/updateIP and/or updateIP-compute depending
     on which rolls are installed.
 #. ``build`` solr index
 #. ``list`` : lists database contents, will create a script for these queries
    * ``users archive/all``
    * ``algorithms archive/all``
    * ``climate archive/all`` 
    * ``species``
    * ``status occ/mdl/proj`` 
