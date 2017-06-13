# Purpose: make all roll rpms
#
# This script is run by a superuser

usage () 
{
    echo "Usage: bash $0"
    echo "This script is run by the superuser. It will make all rpms for the"
    echo "lifemapper-server roll."
    echo "   "
    echo "The output of the script is in `/bin/basename $0`.log"
}

### define varibles
SetDefaults () {
    THISNAME=`/bin/basename $0`
    # directory
    BASEDIR=/state/partition1/workspace/lifemapper-server
    LMGDAL_COUNT=`rpm -qa | grep lifemapper-gdal | wc -l`
    if [ $LMGDAL_COUNT = 0 ]; then
        echo "Error: $BASEDIR/bootstrap has not been executed" | tee -a $LOG
        exit 1
    fi

    # Logfile
    LOG=$BASEDIR/$THISNAME.log
    rm -f $LOG
    touch $LOG
}

TimeStamp () {
    echo $1 `/bin/date` >> $LOG
}

### build entire roll
MakeProfile () {
    echo "*************************" | tee -a $LOG
    echo "Making the profile ... " | tee -a $LOG
    echo "*************************" | tee -a $LOG
    cd $BASEDIR
    make profile 2>&1 | tee -a $LOG
}

### make ready-to-bake rpms
MakeSimpleRpms () {
    declare -a easyrpms=("cherrypy" "cython" "egenix" "faulthandler" 
          "gdal" "geos" "isodate" "libevent" "lm-cmd" "mapserver" "mod-wsgi" 
          "mysql-python" "numexpr" "processing" "proj" "psycopg2" "pytables" 
          "rdflib" "requests" "rocks-lifemapper" "rtree" "spatialindex" 
          "tiff" "usersguide")

    for i in "${easyrpms[@]}"
    do
        echo "*************************" | tee -a $LOG
        echo "Packaging $i..." | tee -a $LOG
        echo "*************************" | tee -a $LOG
        cd $BASEDIR/src/"$i"
        pwd
        make rpm 2>&1 | tee -a $LOG
    done
}

### make rpms that need data prep
MakePreppedRpms () {
    declare -a preprpms=("cctools" "lmdata-climate" "lmdata-species" "lmserver" 
                         "solr")

    for i in "${preprpms[@]}"
    do
        echo "*************************" | tee -a $LOG
        echo "Packaging $i..." | tee -a $LOG
        echo "*************************" | tee -a $LOG
        cd $BASEDIR/src/"$i"
        pwd
        make prep 2>&1 | tee -a $LOG
        make rpm 2>&1 | tee -a $LOG
    done
}

### build entire roll
BuildRoll () {
    echo "*************************" | tee -a $LOG
    echo "Building the roll ... " | tee -a $LOG
    echo "*************************" | tee -a $LOG
    cd $BASEDIR
    make roll 2>&1 | tee -a $LOG
}

### Main ###
if [ $# -ne 0 ]; then
    usage
    exit 0
fi 

SetDefaults
TimeStamp "# Start"
MakeProfile
MakeSimpleRpms
MakePreppedRpms
BuildRoll
TimeStamp "# End"

