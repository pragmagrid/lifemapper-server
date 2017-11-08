#!/bin/bash

# This script removes :
#    roll-installed RPMs, 
#    created directories
#    rocks host attributes
#    user accounts and groups : postgres, pgbouncer, lmwriter

RM="rpm -evl --quiet --nodeps"
LMROLL_COUNT=`rocks list roll | grep lifemapper | wc -l`
LMUSER_COUNT=`/bin/egrep -i "^lmwriter" /etc/passwd  | wc -l`

TimeStamp () {
    echo $1 `/bin/date` >> $LOG
}

set_defaults() {
    THISNAME=`/bin/basename $0`
    LOG=/tmp/$THISNAME.log
    rm -f $LOG
    touch $LOG
}

# stop Lifemapper daemons if running
stop-lm-daemons () {
    TRYAGAIN=0
    if [ -f /state/partition1/lmscratch/run/mattDaemon.pid ]; then
        echo "-- login as lmwriter to stop mattDaemon" >> $LOG
        TRYAGAIN=1
    fi

    if [ -f /state/partition1/lmscratch/run/daboom.pid ]; then
        echo "-- login as lmwriter to stop daboom daemon" >> $LOG
        TRYAGAIN=1
    fi

    if [ $TRYAGAIN = 1 ]; then
        exit
    fi
}

# stop services if running
stop-services () {
    PG=`basename /etc/init.d/postgresql-*`
    echo "-- stop $PG and pgbouncer daemons " >> $LOG
    
    if [ -f /var/run/pgbouncer/pgbouncer.pid ]; then
        /sbin/service pgbouncer stop
    fi

    if [ -f /var/run/$PG.pid ] ; then
        /sbin/service $PG stop
    fi

    prog="postmaster"
    if [ -n "`pidof $prog`" ]; then
        echo "-- kill $prog process " >> $LOG
        killproc  $prog
    fi
    
    SOLR_PROCESSES=`ps -Af | grep solr | grep -v "grep" | wc -l`
    if [ $SOLR_PROCESSES = 1 ]; then
        echo "-- stop Solr process " >> $LOG
        /sbin/service solr stop
    fi    
}

del-possible-shared-dependencies() {
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing SHARED hdf rpms" >> $LOG
      $RM hdf4-devel hdf4
      $RM hdf5-devel hdf5
   fi
}

del-lifemapper-shared() {
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing SHARED lifemapper-* and prerequisite RPMS" >> $LOG
      $RM lifemapper-cctools
      $RM lifemapper-gdal
      $RM lifemapper-geos
      $RM lifemapper-proj
      $RM lifemapper-spatialindex
      $RM lifemapper-tiff
      $RM lifemapper-env-data
      echo "Removing SHARED opt-* RPMS" >> $LOG
      $RM opt-lifemapper-egenix-mx-base
      $RM opt-lifemapper-requests
      $RM opt-lifemapper-rtree
      $RM opt-lifemapper-dendropy   
   fi
}

del-lifemapper() {
   echo "Removing lifemapper-* and prerequisite RPMS" >> $LOG
   $RM lifemapper-cmd
   $RM lifemapper-image-data
   $RM lifemapper-libevent
   $RM lifemapper-lmserver
   $RM lifemapper-mod_wsgi
   $RM lifemapper-solr
   $RM lifemapper-species-data
   $RM lifemapper-webclient
   $RM rocks-lifemapper
   $RM roll-lifemapper-server-usersguide
}

del-opt-python () {
   echo "Removing opt-* RPMS" >> $LOG
   $RM opt-lifemapper-cheroot
   $RM opt-lifemapper-cherrypy
   $RM opt-lifemapper-coverage
   $RM opt-lifemapper-cython
   $RM opt-lifemapper-faulthandler
   $RM opt-lifemapper-isodate
   $RM opt-lifemapper-MySQL-python
   $RM opt-lifemapper-numexpr
	$RM opt-lifemapper-portend
   $RM opt-lifemapper-processing
   $RM opt-lifemapper-psycopg2
   $RM opt-lifemapper-pytables
   $RM opt-lifemapper-pytz
   $RM opt-lifemapper-rdflib
   $RM opt-lifemapper-six
	$RM opt-lifemapper-tempora
}

del-mapserver(){
   echo "Removing mapserver and dependencies RPMS" >> $LOG
   $RM opt-lifemapper-mapserver
   $RM giflib-devel
   $RM bitstream-vera-sans-fonts
   $RM bitstream-vera-fonts-common
}

del-postgres() {
   echo "Removing postgis, postgres, pgbouncer and dependencies RPMS" >> $LOG
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
   echo "Removing pgdg and elgis repos RPMS" >> $LOG
   $RM pgdg-centos91
   $RM elgis-release
}

del-directories () {
   echo "Removing shared frontend code, data and PID directories" >> $LOG
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing /opt/lifemapper"
      rm -rf /opt/lifemapper
      echo "Removing common data directories"
      rm -rf /state/partition1/lmscratch
      rm -rf /state/partition1/lm
      echo "Removing PID directory"
      rm -rf /var/run/lifemapper
   fi
   
   echo "Removing  directories used by postgres and pgbouncer" >> $LOG
   rm -rf /var/run/postgresql
   rm -rf /var/lib/pgsql
   rm -rf /etc/pgbouncer

   echo "Removing data directories" >> $LOG
   rm -rf /state/partition1/lmserver

   echo "Removing jcc installed by bootstrap" >> $LOG
   rm -rf /opt/python/lib/python2.7/site-packages/jcc
   rm -rf /opt/python/lib/python2.7/site-packages/libjcc.so 
   rm -rf /opt/python/lib/python2.7/site-packages/JCC-2.18-py2.7.egg-info  

}

del-webstuff () {
   echo "Removing mapserver tmp directory" >> $LOG
   rm -rf /var/www/tmp

   echo "Removing symlinks" >> $LOG
   rm -f /var/www/html/sdm
   rm -f /var/www/html/lmdashboard
   
   echo "Removing lifemapper web config" >> $LOG
   rm -f /etc/httpd/conf.d/lifemapper.conf
}

del-user-group () {
   needSync=0
   if [ $LMUSER_COUNT = 1 ] && [ $LMROLL_COUNT = 1 ]; then
       echo "Remove lmwriter user/group/dirs" >> $LOG
       userdel lmwriter
       groupdel lmwriter
       /bin/rm -f /var/spool/mail/lmwriter
       /bin/rm -rf /export/home/lmwriter
       needSync=1
   fi

   /bin/egrep -i "^solr" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove solr user" >> $LOG
       userdel solr
       /bin/rm -f /var/spool/mail/solr
       /bin/rm -rf /export/home/solr
       needSync=1
   fi

   /bin/egrep -i "^pgbouncer" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove pgbouncer user" >> $LOG
       userdel pgbouncer
       /bin/rm -rf /export/home/pgbouncer
       needSync=1
   fi

   /bin/egrep -i "^postgres" /etc/passwd
   if [ $? -eq 0 ]; then
       echo "Remove postgres user" >> $LOG
       userdel postgres
       needSync=1
   fi

   if [ "$needSync" -eq "1" ]; then
       echo "Syncing users info" >> $LOG
       rocks sync users
   fi
}

del-attr () {
   rocks list host attr localhost | /bin/egrep -i LM_dbserver
   if [ $? -eq 0 ]; then
   	echo "Remove attribute LM_dbserver" >> $LOG
   	rocks remove host attr localhost LM_dbserver
   fi

   rocks list host attr localhost | /bin/egrep -i LM_webserver
   if [ $? -eq 0 ]; then
   	echo "Remove attribute LM_webserver" >> $LOG
   	rocks remove host attr localhost LM_webserver
   fi
}

# remove obsolete Lifemapper cron jobs
del-cron-jobs () {
   rm -vf  /etc/cron.hourly/lmserver_*
   rm -vf  /etc/cron.daily/lmserver_*
   rm -vf  /etc/cron.monthly/lmserver_*
   echo "Removed old cron jobs in /etc/cron.daily and /etc/cron.monthly on frontend ..."  >> $LOG
}

del-automount-entry () {
    cat /etc/auto.share  | grep -v "^lmserver " /tmp/auto.share.nolmserver
    /bin/cp /tmp/auto.share.nolmserver /etc/auto.share
    if [ $LMROLL_COUNT = 1 ]; then
        cat /etc/auto.share  | grep -v "^lmserver " | grep -v "^lm " > /tmp/auto.share.nolmserver
        /bin/cp /tmp/auto.share.nolmserver /etc/auto.share
    fi
}

check_lm_processes () {
    LMUSER_PROCESSES=`ps -Alf | grep lmwriter | grep -v grep | wc -l`
    if [ $LMUSER_PROCESSES -ne 1 ]; then
        echo "Stop all lmwriter processes before running this script"
        exit 0
    fi 
}

### main ###

check_lm_processes

set_defaults
TimeStamp "# Start"
stop-lm-daemons
stop-services
del-postgres
del-mapserver 
del-lifemapper-shared
del-opt-python 
del-lifemapper
del-sysRPM
del-directories
del-webstuff
del-user-group
del-attr
del-cron-jobs
del-automount-entry
echo
echo "Removing roll lifemapper-server"
/opt/rocks/bin/rocks remove roll lifemapper-server
echo "Rebuilding the distro"
(cd /export/rocks/install; rocks create distro; yum clean all)
echo
TimeStamp "# End"
