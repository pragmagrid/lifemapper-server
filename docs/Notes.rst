.. highlight:: rest
.. contents:: 

Repo creation
=============

This repo was based on the previous lifemapper repo.  Many prerequisites 
for lifemapper-server repo are the same as for lifemapper. 
Use the following script to create new lifemapper-server repo ::

    #!/bin/bash

    # location of rolls repos from git
    ROLLSDIR=/state/partition1/site-roll/rocks/src/roll

    # directories from lifemapper repo to import into new lifemapper-server repo
    DIRS="
    cheetah cherrypy cython egenix
    faulthandler gdal geos lmdata lmserver
    mod-python mysql-python numexpr proj psycopg2
    pytables rocks-lifemapper rtree setuptools
    spatialindex tiff usersguide
    "
    # directory for creating patches
    PATCHDIR=/tmp/patches

    # create patches for all directories
    cd $ROLLSDIR/lifemapper
    for i in $DIRS; do
       reposrc=src/$i
       git format-patch -o $PATCHDIR $(git log $reposrc|grep ^commit|tail -1|awk '{print $2}')^..HEAD $reposrc
    done

    # apply all patches
    cd $ROLLSDIR/lifemapper-server
    git am $PATCHDIR/*.patch
    rm -rf $PATCHDIR/*.patch


; ...............................................
[LmCompute - Job Submitter]
;;;; Options are local | cluster, 
;;;; configured by roll in lifemapper-compute/src/version.mk
JOB_SUBMITTER_TYPE: @JOB_SUBMITTER_TYPE@
CAPACITY: @JOB_CAPACITY@
