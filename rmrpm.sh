#!/bin/bash

# When debugging the roll build may need to
# rm all roll-installed RPMs. 

RM="rpm -evl --nodeps"

del-lifemapper() {
   $RM roll-lifemapper-server-usersguide
   $RM rocks-lifemapper
   $RM lifemapper-tiff
   $RM lifemapper-spatialindex
   $RM lifemapper-server
   $RM lifemapper-proj
   $RM lifemapper-mod_python
   $RM lifemapper-geos
   $RM lifemapper-ant
   $RM lifemapper-climate-data
   $RM lifemapper-libevent
   $RM hdf5-devel hdf5
   $RM lifemapper-gdal
   $RM cmake
   $RM subversion
   $RM screen
   $RM fribidi
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
   $RM postgresql91-python
   $RM postgresql91-docs
   $RM postgresql91-server
   $RM postgresql91-devel
   $RM postgresql91
   $RM postgresql91-libs
   $RM uuid
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

