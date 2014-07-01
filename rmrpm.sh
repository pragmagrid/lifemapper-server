#!/bin/bash

# When debugging the roll build may need to
# rm all roll-installed RPMs. 

RM="rpm -evl"

del-lifemapper() {
   $RM roll-lifemapper-server-usersguide
   $RM rocks-lifemapper
   $RM lifemapper-tiff
   $RM lifemapper-spatialindex
   $RM lifemapper-server-data
   $RM lifemapper-server
   $RM lifemapper-proj
   $RM lifemapper-mod_python
   $RM lifemapper-geos
   $RM --nodeps hdf5-devel hdf5
   $RM --nodeps lifemapper-gdal
   $RM lifemapper-ant
}

del-opt-python () {
   $RM opt-setuptools
   $RM opt-pytables
   $RM opt-pylucene
   $RM opt-psycopg2
   $RM opt-numexpr
   $RM opt-faulthandler
   $RM opt-egenix-mx-base
   $RM opt-cython
   $RM opt-cherrypy
   $RM opt-cheetah
   $RM opt-MySQL-python
   $RM opt-rtree
}

del-mapserver(){
   $RM mapserver
   $RM hdf4-devel hdf4
   $RM readline-devel
   $RM byacc
   $RM giflib-devel
   $RM bitstream-vera-sans-fonts
   $RM bitstream-vera-fonts-common
}

del-postgres() {
   $RM postgis2_91
   $RM json-c.x86_64
   $RM pgbouncer
   $RM postgresql91-test
   $RM postgresql91-contrib
   $RM uuid
   $RM postgresql91-python
   $RM postgresql91-docs
   $RM postgresql91-server
   $RM postgresql91-devel
   $RM postgresql91
   $RM --nodeps postgresql91-libs
}

del-sysRPM() {
   $RM pgdg-centos91
   $RM elgis-release
}

del-postgres
del-mapserver 
del-opt-python 
del-lifemapper
del-sysRPM
