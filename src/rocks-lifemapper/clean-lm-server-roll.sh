#!/bin/bash

# This script removes :
#    roll-installed RPMs, 
#    created directories
#    rocks host attributes
#    user accounts and groups : postgres, pgbouncer, solr, lmwriter

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

del-lifemapper() {
   echo "Removing lifemapper-* and prerequisite RPMS" >> $LOG
   $RM lifemapper-cmd
   $RM lifemapper-libevent
   $RM lifemapper-lmserver
   $RM lifemapper-mod_wsgi
   $RM lifemapper-solr
   $RM lifemapper-image-data
   $RM lifemapper-species-data
   $RM lifemapper-webclient
   $RM rocks-lifemapper
   $RM roll-lifemapper-server-usersguide
}

del-opt-python () {
   echo "Removing opt-* RPMS" >> $LOG
   $RM opt-lifemapper-biotaphy-otol
   $RM opt-lifemapper-cheroot
   $RM opt-lifemapper-cherrypy
   $RM opt-lifemapper-coverage
   $RM opt-lifemapper-idigbio
   $RM opt-lifemapper-portend
   $RM opt-lifemapper-processing
   $RM opt-lifemapper-psycopg2
   $RM opt-lifemapper-pytables
   $RM opt-lifemapper-pytest
   $RM opt-lifemapper-pytz
   $RM opt-lifemapper-six
   $RM opt-lifemapper-tempora
   $RM opt-lifemapper-unicodecsv
}

del-mapserver(){
   echo "Removing mapserver and dependencies RPMS" >> $LOG
   $RM opt-lifemapper-mapserver
   $RM postgresql-libs
   $RM bitstream-vera-sans-fonts
   $RM bitstream-vera-fonts-common
}

del-postgres() {
   echo "Removing postgis, postgres, pgbouncer and dependencies RPMS" >> $LOG
   $RM postgresql96 postgresql96-libs postgresql96-devel postgresql96-server postgresql96-contrib
   $RM boost-serialization     
   $RM SFCGAL SFCGAL-libs     
   $RM proj     
   $RM CGAL     
   $RM postgis2_96
   $RM c-ares
   $RM postgresql10-libs
   $RM python2-psycopg2     
   $RM pgbouncer
}

del-shared-geospatial-dependencies() {
   echo "Removing shared geos, proj, tiff, and gdal dependencies RPMS" >> $LOG
   $RM CharLS
   $RM SuperLU
   $RM armadillo
   $RM arpack
   $RM blas
   $RM atlas
   $RM cfitsio
   $RM freexl
   $RM gpsbabel
   $RM lapack
   $RM geos geos-devel  geos-python
   $RM hdf5-devel
   $RM libaec
   $RM glibc     
   $RM jbigkit-libs     
   $RM libgcc     
   $RM libjpeg-turbo     
   $RM libstdc++
   $RM libtiff  libtiff-devel  
   $RM nss-softokn-freebl     
   $RM zlib
   $RM libgeotiff libgeotiff-devel
   $RM libdap
   $RM libusb
   $RM libgta
   $RM ogdi
   $RM netcdf
   $RM openblas-openmp     
   $RM postgresql-libs
   $RM openjpeg2
   $RM unixODBC
   $RM xerces-c
   $RM proj49 proj49-devel proj49-epsg proj49-nad
   $RM shapelib
   $RM gdal gdal-libs gdal-devel gdal-python 
   $RM python-nose     
   $RM numpy     
   $RM gdal-python
}

del-lifemapper-shared() {
   echo "Removing SHARED lifemapper-* and prerequisite RPMS" >> $LOG
   $RM lifemapper-cctools
   $RM lifemapper-env-data
   echo "Removing SHARED opt-* RPMS" >> $LOG
   $RM opt-lifemapper-egenix-mx-base
   $RM opt-lifemapper-requests
   $RM opt-lifemapper-dendropy
}

del-sysRPM() {
   echo "Removing pgdg repo" >> $LOG
   $RM pgdg-centos96
}

del-directories () {
   if [ $LMROLL_COUNT = 1 ]; then
      echo "Removing shared /opt/lifemapper"
      rm -rf /opt/lifemapper
      echo "Removing shared data directories"
      rm -rf /state/partition1/lmscratch
      rm -rf /state/partition1/lm
      echo "Removing shared PID directory"
      rm -rf /var/run/lifemapper
   fi
   
   echo "Removing  directories used by postgres and pgbouncer" >> $LOG
   rm -rf /var/run/postgresql
   rm -rf /var/lib/pgsql
   rm -rf /etc/pgbouncer

   echo "Removing data directories" >> $LOG
   rm -rf /state/partition1/lmserver

#    echo "Removing jcc installed by bootstrap" >> $LOG
#    rm -rf /opt/python/lib/python2.7/site-packages/jcc
#    rm -rf /opt/python/lib/python2.7/site-packages/libjcc.so 
#    rm -rf /opt/python/lib/python2.7/site-packages/JCC-2.18-py2.7.egg-info  
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
   rm -vf  /etc/cron.*/lmserver_*
   echo "Removed old cron jobs on frontend in /etc directories cron.d, cron.daily and cron.monthly ..."  >> $LOG
}

del-automount-entry () {
   if [ $LMROLL_COUNT = 1 ]; then
       cat /etc/auto.share  | grep -v "^lmserver " | grep -v "^lm " > /tmp/auto.share.nolmserver
       /bin/cp /tmp/auto.share.nolmserver /etc/auto.share
   else
       cat /etc/auto.share  | grep -v "^lmserver " > /tmp/auto.share.nolmserver
       /bin/cp /tmp/auto.share.nolmserver /etc/auto.share
   fi
}

check_lm_processes () {
    LMUSER_PROCESSES=`ps -Alf | grep lmwriter | grep -v grep | wc -l`
    if [ $LMUSER_PROCESSES -ne 0 ]; then
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

if [ $LMROLL_COUNT = 1 ]; then
	del-shared-geospatial-dependencies
	del-lifemapper-shared
fi

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
