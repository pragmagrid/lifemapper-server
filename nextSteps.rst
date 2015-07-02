
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

   #. Optionally write to a data space shared between LmCompute and LmServer, 
      bypassing apache for '''internal''' communications
      
   #. Optionally write to a data space shared with clients, bypassing apache 
      for '''external''' communications
      
Important dates
~~~~~~~~~~~~~~~~

#. June 31: Aimee will email Nadya with travel suggestions for her Lawrence visit.

#. July 1: Aimee/Nadya call 9:30 PDT / 11:30 CDT

#. July 2: Aimee will email Reed and Nadya to discuss and request Kinabalu data 
   for testing and demonstration (and workshop?).

#. July 10, 2015: Aimee will provide 2 working LM component rolls 
   with LM SVN Version 6171 for Nadya to work with.  These rolls will not contain
   completed code improvements planned for PRAGMA 29, but will be suitable for
   testing.
   
#. July 3: Aimee will email Reed and Nadya to discuss and request Kinabalu data 
   for testing and demonstration (and workshop?).

#. July 8: Aimee/Nadya call 9:30 PDT / 11:30 CDT

#. July 23-24: PI meeting at SDSC, Nadya will talk with Peter and follow up with Reed
   
#. July 27-29: Nadya will visit Kansas for one-on-one problem-solving
  
#. Aug 24-29 (2/3 days TBD): Aimee will visit SDSC for one-on-one problem-solving

Weekly TODO
~~~~~~~~~~~~~

#. July 1 call

    #. send email to Aimee with info how to build devel-server
       Done july 1. 
    
    #. verify security-updates roll for 6.2
       Done july 1. Verified roll build and install, send email to Aimee 
       
    #. TODO Build new Vbox images with rocks 6.2 on laptop  
    
    #. TODO Follow up with Peter and Reed during their visit in SD.
