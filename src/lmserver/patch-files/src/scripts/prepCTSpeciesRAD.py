# ............................................................................
import mx.DateTime as DT
from osgeo import ogr
import os

from LM.common.scribe import Scribe
from LM.common.lmconstants import Priority, APP_DIR
from LM.common.log import ConsoleLogger
from LM.rad.palayer import PresenceAbsenceRaster
from LM.rad.radexperiment import RADExperiment

# from lmClientLib import LMClient as client
"""
Completed so far:
   Mammals
      All SDM
      RAD:
         Current
         all future
   Amphibia
      All SDM
      RAD:
         Current
         all future
   Butterflies
      All SDM
      RAD:
         Current
         all future
   Passeriformes
      All SDM
      RAD:
         Current
         all future
   Brassicaceae
     
"""
# ...............................................
# Constants
# ...............................................
inpth = APP_DIR + '/data/'
tmppth = '/tmp/'
fname = 'passeriformes.list'
NAbbox = (-170.0,7.0,-50.0,75.0)

epsg = 2163
# usr = 'CTTest'
usr = 'CT_SongBirds'
algCode = 'GARP_BS'
researcher = 'jcavner@ku.edu'

mdlScenCode = 'NA_worldclim_1.4'
# TODO: add mdlScenCode to prjScenCodes for new species
prjScenCodes = ['NA_worldclim_1.4',
                'NA_NIES_A1B_7099',
                'NA_NIES_A2_7099', 
                'NA_NIES_B1_7099']
prefix = 'NA_'

#'CT_TenKm_BigPAM' -real thing on production
#'TwoDegreeTestCT' - low res, not real thing on production
shapeGridName = 'CT_TenKm_BigPAM'   

   
# ...............................................
def createPostPALayers(scribe, logHandle, exp, projList):
   attrPres = 'pixel'
   minPres = 127
   maxPres = 254 
   percentPres = 5
   rollback = True
   for prj in projList:
      prj_id = str(prj.getId())
      try:
         name = prj.speciesName.replace(' ','_')+'_'+prj_id
      except:
         name = prj.title.replace(' ','_') + '_' + prj_id
      par = PresenceAbsenceRaster.initFromRaster(prj, name=name, 
                                                 attrPresence=attrPres, 
                                                 minPresence=minPres, 
                                                 maxPresence=maxPres, 
                                                 percentPresence=percentPres, 
                                                 paUserId=usr)
      updatedpar = scribe.insertPresenceAbsenceLayer(par, exp, 
                                                     rollback=rollback)
      # only rollback on the first insert
      if rollback:
         rollback = False

# ............................................................................
#  MAIN
# ............................................................................
scribe = Scribe(ConsoleLogger(), openGBC=True) 
scribe.openConnections()
# open log file for taxa
logHandle = open(os.path.join(tmppth, fname + ".log"),'w')


###############################
# Get the geom Ref for the clip mask in dd
NAHandle = ogr.Open(os.path.join(inpth, 'NA_ClipMask_dd.shp'))
northAmerica = NAHandle.GetLayer(0)
feature = northAmerica.GetNextFeature()
NAGeom = feature.GetGeometryRef()
geomType = ogr.wkbPoint
# ...............................................

taxaExperiments = {}
taxa, ext = os.path.splitext(fname)


currtime = DT.gmt().mjd
currtaxa = {}
# ....................................................
# Initialize and Insert RAD Experiments
# ....................................................
shapegrid = scribe.getShapeGrid(usr, shpname=shapeGridName)
#shapegrid = ShapeGrid('ctGrid', 4, 1, 'meters', 
#                epsg, NAbbox, ogrType=ogr.wkbPolygon, ogrFormat='ESRI Shapefile', 
#                siteId='siteid', siteX='centerX', siteY='centerY', 
#                userId=usr, modTime=currtime, createTime=currtime)
# shapegrid = scribe.insertShapeGrid(shapegrid)

# ....................................................
# Initialize and Insert RAD Experiments
# ....................................................
for scenariocode in prjScenCodes:
   currtaxa[scenariocode] = []
   # Create experiments if haven't already done so
   expname = '_'.join((taxa, scenariocode[len(prefix):],"5pp"))
   exp = RADExperiment.initFromGrid(usr, expname, shapegrid, 
                                    keywords=None, createTime=currtime, 
                                    modTime=currtime)
   exp = scribe.insertRADExperiment(exp)
   
# ....................................................
# Assemble PA layers for each Class/Family by scenario
# ....................................................
f = open(os.path.join(inpth, fname))
for spname in f:
   spname = spname.strip()
   
   # ....................................................
   # Create, insert, write changeThinking occurrenceset in 2163
   # Initialize SDM Jobs
   # ....................................................
   # Done in prepCTSpeciesSDM.py
   
   # ....................................................
   # Assemble species layers by RAD experiment (taxa/scenario)
   # ....................................................
   occsets = scribe.getOccurrenceSetsForName(spname, userid=usr)
   if len(occsets) > 0:
      projs = scribe.getProjectionsForOccurrenceSet(occsets[0])
      for prj in projs:
         if prj.scenarioCode in prjScenCodes:
            currtaxa[prj.scenarioCode].append(prj)
            
taxaExperiments[taxa] = currtaxa

# ....................................................
# Initialize RAD Jobs (initially for JUST ONE scenario)
# Next, everything but mdlScenCode (already done)
# ....................................................
for scenariocode in prjScenCodes:
   expname = '_'.join((taxa, scenariocode[len(prefix):],"5pp"))

   projList = taxaExperiments[taxa][scenariocode]
   exp = scribe.getRADExperiment(usr, expname=expname)
   bucketId = exp.bucketList[0].getId()
   # ....................................................
   # Parameterize and Insert PA layer for each species into (ONE) Experiment 
   # ....................................................
   createPostPALayers(scribe, logHandle, exp, projList)
   
   # ....................................................
   # Initialize Intersect/Compress/Calculate 
   # ....................................................
   jobs = scribe.initRADIntersectPlus(usr, bucketId, doSpecies=True, 
                                      priority=Priority.REQUESTED)
   # ....................................................
   # Let the pipeline do the rest! 
   # ....................................................
   
logHandle.close()











