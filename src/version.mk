PKGROOT			= /opt/lifemapper
LMHOME			= /opt/lifemapper
MAPSERVER_TMP	= /var/www/tmp
LMURL			= http://yeti.lifemapper.org/dl
LMSERVERDISK	= /share/lmserver
LMDISK			= /share/lm

## DATADIR_SHARED is identical in the lifemapper-compute roll
DATADIR_SHARED  = /share/lm/data

DATADIR_SERVER  = /share/lmserver/data
LMSCRATCHDISK	= /state/partition1/lmscratch

## Matches ENV_DATA_DIR in the lifemapper-compute roll
ENV_DATA_DIR   = layers

PYTHONVER			= python2.7
PYTHON27			= /opt/python/bin/$(PYTHONVER)
PYTHON27_PACKAGES	= /opt/python/lib/$(PYTHONVER)/site-packages
PGSQLVER			= 9.2
UNIXSOCKET			= /var/run/postgresql
SMTPSERVER			= localhost
SMTPSENDER			= no-reply-lifemapper@@PUBLIC_FQDN@
JAVABIN				= /usr/java/latest/bin/java

# Top directory of the current webclient and metrics dashboard client
LMCLIENT			= boom
DASHBOARD			= lmdashboard

# SCENARIO_PACKAGE matches SCENARIO_PACKAGE in the lifemapper-compute roll
# and lifemapper-env-data rpm in both rolls
SCENARIO_PACKAGE	= 10min-past-present-future
EPSG				= 4326
MAPUNITS			= dd

USER_SPECIES_DATA		= sorted_seasia_gbif

GBIF_TAXONOMY_FILENAME		= gbif_taxonomy_2018-03-08.csv
GBIF_OCCURRENCE_FILENAME	= gbif_occurrence_2018-03-08.csv
GBIF_PROVIDER_FILENAME		= gbif_orgs.txt

GRID_NAME				= lmgrid_1d
GRID_CELLSIZE			= 1
GRID_NUM_SIDES			= 4

# Code version
CODEVERSION			= 2.4.4
