#!/bin/bash

gname=lmwriter

# Create directories for lucene indexes and cherrypy sessions
GID=`grep $gname: /etc/group`
if [ "$GID" != "" ] ; then
    mkdir -p /var/lib/lm2 
    mkdir -p /var/lib/lm2/sessions
    mkdir -p /var/lib/lm2/luceneIndex
    mkdir -p /var/lib/lm2/.python-eggs
    chmod -R g+ws /var/lib/lm2
else 
    echo "ERROR: group $gname does not exist"
    exit 1
fi

# Set overcommit_memory mode to strict (2) to reduce chances of 'Out of Memory killer' being invoked
/sbin/sysctl -w vm.overcommit_memory=2

