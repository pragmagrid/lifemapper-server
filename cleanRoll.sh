#!/bin/bash

# This script removes :
#    roll-installed RPMs, 
#    created directories
#    rocks host attributes
#    user accounts and groups : postgres, pgbouncer, lmwriter

RM="rpm -evl --quiet --nodeps"

del-lifemapper() {
   echo "Removing lifemapper-* and prerequisite RPMS"
   $RM lifemapper-cctools
   $RM lifemapper-climate-data
   $RM lifemapper-cmd
   $RM lifemapper-gdal
   $RM lifemapper-geos
   $RM lifemapper-libevent
   $RM lifemapper-lmserver
   $RM lifemapper-mod_wsgi
   $RM lifemapper-proj
   $RM lifemapper-solr
   $RM lifemapper-spatialindex
   $RM lifemapper-species-data
   $RM lifemapper-tiff
   $RM rocks-lifemapper
   $RM roll-lifemapper-server-usersguide
}

del-opt-python () {
   echo "Removing opt-* RPMS"
   $RM opt-lifemapper-cherrypy
   $RM opt-lifemapper-cython
   $RM opt-lifemapper-egenix-mx-base
   $RM opt-lifemapper-faulthandler
   $RM opt-lifemapper-isodate
   $RM opt-lifemapper-MySQL-python
   $RM opt-lifemapper-numexpr
   $RM opt-lifemapper-processing
   $RM opt-lifemapper-psycopg2
   $RM opt-lifemapper-pytables
   $RM opt-lifemapper-rdflib
   $RM opt-lifemapper-requests
   $RM opt-lifemapper-rtree
}

del-mapserver(){
   echo "Removing mapserver and dependencies RPMS"
   $RM opt-lifemapper-mapserver
   $RM hdf4-devel hdf4
   $RM hdf5-devel hdf5
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
}

del-sysRPM() {
   echo "Removing pgdg and elgis repos RPMS"
   $RM pgdg-centos91
   $RM elgis-release
}

del-directories () {
   echo "Removing /opt/lifemapper/*"
   rm -rf /opt/lifemapper

   echo "Removing  directories used by postgres and pgbouncer"
   rm -rf /var/run/postgresql
   rm -rf /var/lib/pgsql
   rm -rf /etc/pgbouncer

   echo "Removing data directories"
   rm -rf /state/partition1/lmserver
   rm -rf /var/www/tmp
   rm -rf /var/lib/lm2

   echo "Removing jcc installed by bootstrap"
   rm -rf /opt/python/lib/python2.7/site-packages/jcc
   rm -rf /opt/python/lib/python2.7/site-packages/libjcc.so 
   rm -rf /opt/python/lib/python2.7/site-packages/JCC-2.18-py2.7.egg-info  

}

del-user-group () {
   needSync=0
   /bin/egrep -i "^lmwriter" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove lmwriter user"
       userdel lmwriter
       groupdel lmwriter
       /bin/rm -f /var/spool/mail/lmwriter
       /bin/rm -rf /export/home/lmwriter
       needSync=1
   fi

   /bin/egrep -i "^pgbouncer" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove phgouncer user"
       userdel pgbouncer
       needSync=1
   fi

   /bin/egrep -i "^postgres" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove postgres user"
       userdel postgres
       needSync=1
   fi

   if [ "$needSync" -eq "1" ]; then
       echo "Syncing users info"
       rocks sync users
   fi
}

del-attr () {
   rocks list host attr localhost | /bin/egrep -i LM_dbserver
   if [ $? -eq 0 ]; then
   	echo "Remove attribute LM_dbserver"
   	rocks remove host attr localhost LM_dbserver
   fi

   rocks list host attr localhost | /bin/egrep -i LM_webserver
   if [ $? -eq 0 ]; then
   	echo "Remove attribute LM_webserver"
   	rocks remove host attr localhost LM_webserver
   fi
}

### main ###
del-postgres
del-mapserver 
del-opt-python 
del-lifemapper
del-sysRPM
del-directories
del-user-group
del-attr
