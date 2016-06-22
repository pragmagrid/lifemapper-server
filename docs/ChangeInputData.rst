
.. hightlight:: rest

Updating an existing Lifemapper Server installation
###################################################
.. contents::  

.. _Update Combined System : docs/UpdatingCombinedSystem.rst


Introduction
************
After the roll is installed, and the instance has been populated, you will want
to update the default data or configuration. To update code, see: 
**Update Combined System** instructions at `Update Combined System`_

Stop processes
**************

#. **Stop the archivist** as lmwriter  ::    

     % $PYTHON /opt/lifemapper/LmDbServer/pipeline/archivist.py stop 

   **TODO:** Move to command **lm stop archivist** 


Add a new computation server
****************************

.. _Using : docs/Using.rst#add-a-new-lmcompute

.. _Add a new LmCompute : docs/Using.rst#add-a-new-lmcompute

   Instructions at **Add a new LmCompute** at `Using`_
#. Follow instructions at  `Add a new LmCompute`_

          
Update input data
*****************

.. _ModifyData : https://github.com/lifemapper/core/blob/master/docs/using/starting.rst
     
Change Archive User
===================

#. Add/Change the ARCHIVE_USER value in the [LmCommon - common] section of 
   /opt/lifemapper/config/site.ini file.  
   
   The ARCHIVE_USER must own all occurrence and scenario records; so you must 
   insert new or re-insert existing climate data as this user.  If the 
   configured climate data exists on the server, it will not re-download it. 
   The user, and climate scenarios (owned by that user) will be added when 
   running this script :: 

     # /opt/lifemapper/rocks/bin/updateArchiveInput

   **TODO:** Move to command **lm update input**

Climate data
============
     
#. **Download, catalog new climate data**  as ``root``

   Add SCENARIO_PACKAGE, DEFAULT_MODEL_SCENARIO, DEFAULT_PROJECTION_SCENARIOS 
   to the [LmServer - pipeline] section of /opt/lifemapper/config/site.ini 
   file.  Available climate packages and codes are described at `_ModifyData`_.
   Then catalog these values with::   
   
      # /opt/lifemapper/rocks/bin/updateArchiveInput

   **TODO:** Move to command **lm update input**
   
Species data
============

#. **Download, catalog new species data**  as ``root`` 

   As user root, add or edit the sections ``[LmServer - environment]`` and 
   optionally ``[LmServer - pipeline]`` in /opt/lifemapper/config/site.ini. 
   DATASOURCE options are described in  `_ModifyData`_.  If NOT using a 
   pre-defined datasource, USER_OCCURRENCE_* filenames must added to site.ini
   and installed (in the format described at  `_ModifyData`_ ) into 
   /share/lmserver/data/species/ . This dataset is used by the archivist/boomer,
   so after the config file is updated, no other scripts are required :: 

     [LmServer - environment]
     DATASOURCE: USER

     [LmServer - pipeline]
     USER_OCCURRENCE_CSV: <spdata>.csv
     USER_OCCURRENCE_META: <spdata>.meta

   
Start processes
***************

#. **Start the archivist**  as ``lmserver`` to initialize all new jobs with the 
   new species data.  (Note: in old versions this script is named buildBoom)::

     % $PYTHON /opt/lifemapper/LmDbServer/pipeline/archivist.py start
   
   **TODO:** Move to command **lm start archivist**

