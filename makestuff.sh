BASEDIR=/state/partition1/workspace/lifemapper-server

#declare -a easyrpms=("cctools" "cherrypy" "cython" "egenix" "faulthandler" "gdal" 
declare -a easyrpms=(
          "geos" "isodate" "libevent" "lm-cmd" "lmdata-climate" "lmdata-species" 
          "lmserver" "mapserver" "mod-wsgi" "mysql-python" "numexpr" "processing" 
          "proj" "psycopg2" "pytables" "rdflib" "requests" "rocks-lifemapper" 
          "rtree" "solr" "spatialindex" "tiff" "usersguide")

for i in "${easyrpms[@]}"
do
   cd $BASEDIR/src/"$i"
   make rpm
done


