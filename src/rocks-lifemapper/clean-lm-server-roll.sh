#!/bin/bash

# This script removes :
#    roll-installed RPMs, 
#    created directories
#    rocks host attributes
#    user accounts and groups : postgres, pgbouncer, lmwriter

RM="rpm -evl --quiet --nodeps"
LMROLL_COUNT=`rocks list roll | grep lifemapper | wc -l`

# stop services if running
stop-services () {
    PG=`basename /etc/init.d/postgresql-*`
    echo "-- stop $PG and pgbouncer daemons "

    if [ -f /var/run/pgbouncer/pgbouncer.pid ]; then
        /sbin/service pgbouncer stop
    fi

    if [ -f /var/run/$PG.pid ] ; then
        /sbin/service $PG stop
    fi

    prog="postmaster"
    if [ -n "`pidof $prog`" ]; then
        echo "-- kill $prog process "
        killproc  $prog
    fi
    
    SOLR_PROCESSES=`ps -Af | grep solr | grep -v "grep" | wc -l`
    if [ $SOLR_PROCESSES = 1 ]; then
        echo "-- stop Solr process "
        /sbin/service solr stop
    fi
    
    if [ -f /var/run/lifemapper/lmboom.pid ] ; then
        echo "-- stop Lifemapper archivist "
        /opt/python/bin/python2.7   /opt/lifemapper/LmDbServer/pipeline/archivist.py  stop
    fi
}

del-possible-shared-dependencies() {
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing SHARED hdf rpms"
      $RM hdf4-devel hdf4
      $RM hdf5-devel hdf5
   fi
}

del-lifemapper-shared() {
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing SHARED lifemapper-* and prerequisite RPMS"
      $RM lifemapper-cctools
      $RM lifemapper-gdal
      $RM lifemapper-geos
      $RM lifemapper-proj
      $RM lifemapper-spatialindex
      $RM lifemapper-tiff
      echo "Removing SHARED opt-* RPMS"
      $RM opt-lifemapper-egenix-mx-base
      $RM opt-lifemapper-requests
      $RM opt-lifemapper-rtree
   fi
}

del-lifemapper() {
   echo "Removing lifemapper-* and prerequisite RPMS"
   $RM lifemapper-climate-data
   $RM lifemapper-cmd
   $RM lifemapper-libevent
   $RM lifemapper-lmserver
   $RM lifemapper-mod_wsgi
   $RM lifemapper-solr
   $RM lifemapper-species-data
   $RM rocks-lifemapper
   $RM roll-lifemapper-server-usersguide
}

del-opt-python () {
   echo "Removing opt-* RPMS"
   $RM opt-lifemapper-cherrypy
   $RM opt-lifemapper-cython
   $RM opt-lifemapper-faulthandler
   $RM opt-lifemapper-isodate
   $RM opt-lifemapper-MySQL-python
   $RM opt-lifemapper-numexpr
   $RM opt-lifemapper-processing
   $RM opt-lifemapper-psycopg2
   $RM opt-lifemapper-pytables
   $RM opt-lifemapper-rdflib
}

del-mapserver(){
   echo "Removing mapserver and dependencies RPMS"
   $RM opt-lifemapper-mapserver
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
   echo "Removing shared frontend code, data and PID directories"
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing /opt/lifemapper"
      rm -rf /opt/lifemapper
      echo "Removing common data directories"
      rm -rf /state/partition1/lmserver
      rm -rf /state/partition1/lm
      echo "Removing PID directory"
      rm -rf /var/run/lifemapper
   fi
   
   echo "Removing  directories used by postgres and pgbouncer"
   rm -rf /var/run/postgresql
   rm -rf /var/lib/pgsql
   rm -rf /etc/pgbouncer

   echo "Removing data directories"
   rm -rf /state/partition1/lmserver
   
   echo "Removing apache and process directories"
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
   if [ $? -eq 0 ] && [ $LMROLL_COUNT = 1 ]; then
       echo "Remove lmwriter user"
       userdel lmwriter
       groupdel lmwriter
       /bin/rm -f /var/spool/mail/lmwriter
       /bin/rm -rf /export/home/lmwriter
       needSync=1
   fi

   /bin/egrep -i "^solr" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove solr user"
       userdel solr
       /bin/rm -f /var/spool/mail/solr
       /bin/rm -rf /export/home/solr
       needSync=1
   fi

   /bin/egrep -i "^pgbouncer" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove pgbouncer user"
       userdel pgbouncer
       /bin/rm -rf /export/home/pgbouncer
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

# remove obsolete Lifemapper cron jobs
del-cron-jobs () {
   rm -vf  /etc/cron.daily/lmserver_*
   rm -vf  /etc/cron.monthly/lmserver_*
   echo "Removed old cron jobs in /etc/cron.daily and /etc/cron.monthly on frontend ..." | tee -a $LOG
}


### main ###
stop-services
del-postgres
del-mapserver 
del-lifemapper-shared
## del-possible-shared-dependencies
del-opt-python 
del-lifemapper
del-sysRPM
del-directories
del-user-group
del-attr
del-cron-jobs
echo
echo "To complete cleanup, run the command \"rocks remove roll lifemapper-server\""
echo
