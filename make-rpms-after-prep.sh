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
    # directory
    BASEDIR=/state/partition1/workspace/lifemapper-server
    LMGDAL_COUNT=`rpm -qa | grep lifemapper-gdal | wc -l`
    if [ $LMGDAL_COUNT = 0 ]; then
        echo "Error: $BASEDIR/bootstrap has not been executed" | tee -a $LOG
        exit 1
    fi

    # Logfile
    LOG=$BASEDIR/`/bin/basename $0`.log
    rm -f $LOG
    touch $LOG
}

TimeStamp () {
    echo $1 `/bin/date` >> $LOG
}

### make ready-to-bake rpms
MakeSimpleRpms () {
    declare -a easyrpms=("cctools" "cherrypy" "cython" "egenix" "faulthandler" 
          "gdal" "geos" "isodate" "libevent" "lm-cmd" "mapserver" "mod-wsgi" 
          "mysql-python" "numexpr" "processing" "proj" "psycopg2" "pytables" 
          "rdflib" "requests" "rocks-lifemapper" "rtree" "solr" "spatialindex" 
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
    declare -a preprpms=("lmdata-climate" "lmdata-species" "lmserver")

    for i in "${preprpms[@]}"
    do
        echo "*************************" | tee -a $LOG
        echo "Packaging $i..." | tee -a $LOG
        echo "*************************" | tee -a $LOG
        cd $BASEDIR/src/"$i"
        pwd
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
MakeSimpleRpms
MakePreppedRpms
BuildRoll
TimeStamp "# End"

