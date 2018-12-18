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

ENV_DATA_DIR		= layers
SPECIES_DATA_DIR	= species

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
ECOREGION_LAYER		= ecoreg_10min_global

EPSG				= 4326
MAPUNITS			= dd

USER_SPECIES_DATA	= sorted_seasia_gbif
PUBLIC_USER			= kubi

GBIF_TAXONOMY		= gbif_taxonomy
GBIF_OCCURRENCES	= gbif_occ_subset
GBIF_PROVIDER		= gbif_orgs
GBIF_VERSION		= 2018.09.14

GRID_NAME				= lmgrid_1d
GRID_CELLSIZE			= 1
GRID_NUM_SIDES			= 4

# Code version
CODEVERSION			= 2.7.4

