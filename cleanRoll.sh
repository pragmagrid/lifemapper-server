#!/bin/bash

# This script removes :
#    roll-installed RPMs, 
#    created directories
#    rocks hsot attributes
#    user groups

RM="rpm -evl --nodeps"

del-lifemapper() {
   echo "Removing lifemapper-* and prerequisite RPMS"
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
   echo "Removing opt-* RPMS"
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
   echo "Removing mapserver and dependencies RPMS"
   $RM mapserver
   $RM hdf4-devel hdf4
   $RM readline-devel
   $RM byacc
   $RM giflib-devel
   $RM bitstream-vera-sans-fonts
   $RM bitstream-vera-fonts-common
}

del-postgres() {
   echo "Removing postgis, postgres, pgbouncer and dependencies RPMS"
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
   echo "Removing pgdg and elgis repos RPMS"
   $RM pgdg-centos91
   $RM elgis-release
}

del-directories () {
   echo "Removing /opt/lifemapper/*"
   rm -rf /opt/lifemapper/*

   echo "Removing  directories used by postgres and pgbouncer"
   rm -rf /var/run/postgresql
   rm -rf /var/lib/pgsql
   rm -rf /etc/pgbouncer

   echo "Removing data directories"
   rm -rf /state/partition1/lmserver
   rm -rf /var/www/tmp
   rm -rf /var/lib/lm2
}

del-group () {
   echo "Remove lmwriter group"
   groupdel lmwriter
   rocks sync users
}

del-attr () {
   echo "Remove attributes"
   rocks remove host attr localhost LM_dbserver
   rocks remove host attr localhost LM_webserver
}

### main ###
del-postgres
del-mapserver 
del-opt-python 
del-lifemapper
del-sysRPM
del-directories
del-group
del-attr
