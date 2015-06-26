
.. hightlight:: rest

PRAGMA Next Steps
=============================
.. contents::  

Introduction
----------------
This document describes improvements planned to serve the PRAGMA project Virtual 
Biodiversity Expedition (VBE).

PRAGMA 29
~~~~~~~~~~~~~~

This section lists goals for PRAGMA 29, October 2015, Bogor, Indonesia.

#. Lifemapper code improvements
   #. Further code modularization for alternate datasources.\
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
   #. Optionally write to a data space shared between LmCompute and LmServer, 
      bypassing apache for '''internal''' communications
   #. Optionally write to a data space shared with clients, bypassing apache 
      for '''external''' communications
      

Important dates
~~~~~~~~~~~~~~

#. July 10, 2015: Aimee will provide 2 working LM component rolls 
   with LM SVN Version 6171 for Nadya to work with.  These rolls will not contain
   completed code improvements planned for PRAGMA 29, but will be suitable for
   testing.
   
#. July 27-29: Nadya will visit Kansas for one-on-one problem-solving
  
#. Aug 24-29 (2/3 days TBD): Aimee will visit SDSC for one-on-one problem-solving