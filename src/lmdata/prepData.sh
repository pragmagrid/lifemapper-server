#!/bin/bash

# Purpose: checkout data/ from lifemapper SVN and create distro tar.gz file to use in RPM. 
# Need to pass svn url as a first argument. 
# Will be prompted for svn user and passwd.

DATA=data

# check commadn line arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 url"
    echo "       url  - svn url to check out lifemapper data "
    echo "       NOTE: for svn co will be prompted for valid user/pass "
else
    URL=$1
fi

# get data distro from lifemapper svn
svnCheckout () {
      svn checkout $1
      if [ -d $DATA ]; then
        cd $DATA/
        rm -rf .svn
      fi
}

# create distro file
compressFiles () {
  if [ -d $DATA ]; then
      echo "Creating data archive from svn checkout"
      DATE=`date +%Y%m%d`
      tar czf data-$DATE.tar.gz $DATA
  else
      echo "Svn checkout directory $DATA is not present"
  fi
}

svnCheckout $URL
compressFiles
