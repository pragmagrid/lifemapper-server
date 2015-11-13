
.. hightlight:: rest

PRAGMA Next Steps
=============================
.. contents::  

Introduction
----------------
This document describes improvements planned to serve the PRAGMA project Virtual 
Biodiversity Expedition (VBE).  Test comments from Aimee.

PRAGMA 29
~~~~~~~~~~~~~~

This section lists goals for PRAGMA 29, October 2015, Bogor, Indonesia.

#. Lifemapper code improvements

   #. Further code modularization for alternate datasources.
   
      #. Localization/Site file for site-specific parameters to be defined on installation  
      
      #. Leverage subclasses for handling site-specific data within the code 
      
   #. Formalize requirements and generalize population/pipeline code for site-specific data
   
#. Mount Kinabalu VBE

   #. Enable multi-species (RAD) experiments
   
   #. Set up pipeline between UFL (LmCompute), Indonesia (LmServer) and clients
   
#. Virtual Lifemapper on a laptop

   #. Create a Virtual cluster with 2 nodes, both components (LmCompute/LmServer).
      This VM will be available for download for PRAGMA participants prior to 
      and during PRAGMA 29.  
      
   #. Researchers can install QGIS with Lifemapper plugin to communicate with
      laptop LM installation
 
PRAGMA 30
~~~~~~~~~~~~~~

#. Code/Configuration improvements

   #. Create more complete tests for LmServer, LmCompute, and LmServer-LmCompute communications.
   
   #. Optionally write to a data space shared between LmCompute and LmServer, 
      bypassing apache for '''internal''' communications
      
   #. Optionally write to a data space shared with clients, bypassing apache 
      for '''external''' communications
      
#. Operational improvements

   #.  Lay groundwork for '''lm''' commands (similar to '''rocks''' commands) 
       that will execute any user/installer commands related to testing (checkLmWeb, 
       checkJobServer ...), configuration (changeEnvData, seedLayers ...), 
       updates (updateLmCode, updateLmDatabase, ...), and execution (pipeline,
       exportUserData, ...).
      
#. Moving forward

  #. Framework for integrating with RDA
   
#. Documentation improvements

   #.  Formalize instructions for setup, configuration, and post-install data changes
   
   #.  Add ZFS instructions for setting aside large volumes for data archive

#. Data

   #.  Use actual UAV data


Important dates
~~~~~~~~~~~~~~~~

#. Oct 23: Nail down agenda and dates for Aimee's visit to SDSC


Weekly TODO
~~~~~~~~~~~~~

#. 
