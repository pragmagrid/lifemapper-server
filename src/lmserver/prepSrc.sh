#!/bin/bash

# Purpose: checkout src/ from lifemapper SVN and create distro tar.gz file to use in RPM. 
# Need to pass svn url as a first argument. 
# Will be prompted for svn user and passwd.

SRC=components
URL=https://svn.lifemapper.org/trunk
echo "NOTE: for svn checkout you will be prompted for valid user/pass "

# get src distro from lifemapper svn
svnCheckout () {
      echo "Starting SVN checkout from $1:"
      svn checkout $1/components
      if [ -d $SRC ]; then
          DIRS=`find $SRC -name .svn`
          for i in $DIRS; do
              echo "removing $i"
              rm -rf $i
          done
      else
          echo "Error with SVN checkout: directory $SRC is not created"
      fi
}

mvSrc () {
  DIRS="LmCompute LmDbServer LmWebServer LmServerCommon LmCommon"
  for i in $DIRS; do
    dirname=$SRC/$i
    if [ -d $dirname/src ] ; then
      echo "moving files from $dirname/src"
      mv  $dirname/src/* $dirname
      rm -rf $dirname/src/
    else
      echo "directory $dirname/src is not present"
    fi
  done
}

# create distro file
compressFiles () {
  if [ -d $SRC ]; then
      echo "Creating src archive from svn checkout"
      DATE=`date +%Y%m%d`
      PARTS="$SRC/LmClient $SRC/LmDbServer $SRC/LmWebServer $SRC/LmServerCommon $SRC/LmCommon $SRC/__init__.py"
      #(cd patch-files && find . -type f | grep -v CVS | cpio -pduv ..)
      tar czvf src-$DATE.tar.gz $PARTS 
  else
      echo "Svn checkout directory $SRC is not present"
  fi
}

svnCheckout $URL
mvSrc
compressFiles
