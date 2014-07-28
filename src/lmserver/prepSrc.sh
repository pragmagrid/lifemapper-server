#!/bin/bash

# Purpose: checkout distro from lifemapper SVN and create *.tar.gz files to use in RPM. 
# NOTE: Will be prompted for valid svn user and passwd.

SRC=components
URL=https://svn.lifemapper.org/trunk

# get src distro from lifemapper svn
checkout_svn () {
      echo "Starting SVN checkout from $1:"
      svn checkout $1/$SRC

      echo "Record SVN revision for $SRC:"
      svn info $SRC > $SRC/svn-info
      REV=`svn info $SRC | grep Revision | awk '{print $2}'`

      echo "Removing .svn in $SRC:"
      if [ -d $SRC ]; then
          DIRS=`find $SRC -name .svn`
          for i in $DIRS; do
              rm -rf $i
          done
      else
          echo "Error with SVN checkout from $URL/$SRC: directory $SRC is not created"
      fi
}

# move src/* in all modules one level up
collect_src () {
  DIRS=`find $SRC -maxdepth 1 -type d`
  for i in $DIRS; do
    if [ -d $i/src ] ; then
      echo "Moving files from $i/src/ to $i"
      mv  $i/src/* $i
      rm -rf $i/src/
    fi
  done
}

# create distro files for lmserver and lmcompute
create_distro () {
  if [ -d $SRC ]; then
      #DATE=`date +%Y%m%d`
      # create lmserver src distro
      echo "Creating lmserver src archive from svn checkout"
      tar czf lifemapper-server-$REV.tar.gz $SRC/* --exclude=LmCompute --exclude=dist --exclude=public_html/dl

      # create lmcompute src distro
      echo "Creating lmcompute src archive from svn checkout"
      tar czf lifemapper-lmcompute-$REV.tar.gz $SRC/LmCompute $SRC/LmCommon $SRC/config
  else
      echo "SVN checkout directory $SRC is not present"
  fi
}

### main ###
checkout_svn $URL
collect_src
create_distro
