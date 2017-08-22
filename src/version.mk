PKGROOT       = /opt/lifemapper
LMHOME        = /opt/lifemapper
MAPSERVER_TMP = /var/www/tmp
LMURL			  = http://yeti.lifemapper.org/dl
LMSERVERDISK  = /share/lmserver
LMDISK        = /share/lm
## DATADIR_SHARED is identical in the lifemapper-compute roll
DATADIR_SHARED  = /share/lm/data
DATADIR_SERVER  = /share/lmserver/data
LMSCRATCHDISK = /state/partition1/lmscratch

## Matches ENV_DATA_DIR in the lifemapper-compute roll
ENV_DATA_DIR   = layers

PYTHONVER     = python2.7
PGSQLVER      = 9.1
UNIXSOCKET    = /var/run/postgresql
SMTPSERVER    = localhost
SMTPSENDER    = no-reply-lifemapper@@PUBLIC_FQDN@
JAVABIN       = /usr/java/latest/bin/java

# Top directory of the current webclient and metrics dashboard client
LMCLIENT = sdm
DASHBOARD = lmdashboard

# SCENARIO_PACKAGE matches SCENARIO_PACKAGE in the lifemapper-compute roll
SCENARIO_PACKAGE      = 10min-past-present-future
EPSG                  = 4326
MAPUNITS              = dd

SPECIES_DATA 	       = sorted_seasia_gbif
GRID_NAME             = lmgrid_1d
GRID_CELLSIZE         = 1

# Code version
CODEVERSION = 2.0.3.lw
