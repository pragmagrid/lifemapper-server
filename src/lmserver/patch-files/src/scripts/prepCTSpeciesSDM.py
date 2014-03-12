# ............................................................................
import mx.DateTime as DT
from osgeo import ogr,osr
import os

from LM.common.scribe import Scribe
from LM.common.lmconstants import PrimaryEnvironment, Priority, JobStatus, APP_DIR
from LM.common.log import ConsoleLogger
from LM.sdm.algorithm import Algorithm
from LM.sdm.occlayer import OccurrenceLayer
from LM.sdm.sdmexperiment import SDMExperiment
from LM.sdm.sdmprojection import SDMProjection
from LM.sdm.sdmmodel import SDMModel
from lmClientLib import LMClient as client

# ...............................................
def reprojectClip(shp, name):
   
   # transformation object ################
   success = False
   
   try:
      #lAEA_2163PrjDef = """PROJCS["US National Atlas Equal Area",GEOGCS["Unspecified datum based upon the Clarke 1866 Authalic Sphere",DATUM["Not_specified_based_on_Clarke_1866_Authalic_Sphere",SPHEROID["Clarke 1866 Authalic Sphere",6370997,0,AUTHORITY["EPSG","7052"]],AUTHORITY["EPSG","6052"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4052"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Lambert_Azimuthal_Equal_Area"],PARAMETER["latitude_of_center",45],PARAMETER["longitude_of_center",-100],PARAMETER["false_easting",0],PARAMETER["false_northing",0],AUTHORITY["EPSG","2163"],AXIS["X",EAST],AXIS["Y",NORTH]]"""
      lAEA_2163PrjDef = """PROJCS["Lambert_Azimuthal_Equal_Area",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6370997,0]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Azimuthal_Equal_Area"],PARAMETER["latitude_of_origin",45],PARAMETER["central_meridian",-100],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]"""

      srcSR = osr.SpatialReference()
      srcSR.ImportFromWkt('GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]]')
      destSR = osr.SpatialReference()
      destSR.ImportFromWkt(lAEA_2163PrjDef)
      srTrans = osr.CoordinateTransformation(srcSR,destSR)
      ####################################################
      drv = ogr.GetDriverByName('ESRI Shapefile')
      
      shpHandle = ogr.Open(shp)
      layer = shpHandle.GetLayer(0)
      # create a new layer
      layerDef = layer.GetLayerDefn()
      fieldcount = layerDef.GetFieldCount()          
      trds = drv.CreateDataSource('/tmp/naocc_LAEA.shp')
      newlyr = trds.CreateLayer(trds.GetName(), geom_type=geomType, srs=destSR)
      for idx in range(0,fieldcount):
         fieldDef = layerDef.GetFieldDefn(idx)
         fieldType = fieldDef.GetType()
         fieldName = fieldDef.GetName()
         newfldDefn = ogr.FieldDefn(fieldName, fieldType)
         newfieldcode = newlyr.CreateField(newfldDefn)
      newlayerDefn = newlyr.GetLayerDefn()
      
      oneFeature = False
      occFeature = layer.GetNextFeature()
      while occFeature:
         oldGeom = occFeature.GetGeometryRef()
         if NAGeom.Intersect(oldGeom):
            oneFeature = True
            newGeom = occFeature.GetGeometryRef().Clone()
            newGeom.Transform(srTrans)
            newfeat = ogr.Feature(feature_def=newlayerDefn)
            geocode = newfeat.SetGeometry(newGeom)
            for fidx in range(0,fieldcount):
               fieldvalue = occFeature.GetField(fidx)
               newfeat.SetField(str(newlayerDefn.GetFieldDefn(fidx).GetName()),fieldvalue)
            newlyr.CreateFeature(newfeat)
            newfeat.Destroy() 
         occFeature = layer.GetNextFeature()
      trds.Destroy() 
   except Exception, e:
      print "failed on occ reproject clip ", name, " ",str(e)
   else:
      if oneFeature:
         success = True
   return success

# ...............................................
def removeTempLAEAShp():
   
   os.remove('/tmp/naocc_LAEA.shx')
   os.remove('/tmp/naocc_LAEA.shp')
   os.remove('/tmp/naocc_LAEA.prj')
   os.remove('/tmp/naocc_LAEA.dbf')

# ...............................................
def insertWScribe(spname):
   newocc = OccurrenceLayer(spname, epsgcode=2163, ogrType=ogr.wkbPoint, 
                               ogrFormat='ESRI Shapefile', 
                               primaryEnv=PrimaryEnvironment.TERRESTRIAL,
                               userId=usr)
   tmpShapefile = '/tmp/naocc_LAEA.shp'
   newocc.readData(dlocation=tmpShapefile)
   
   #This also sets the ID, and the new UserData dlocation (for writing shp)
   # added this Jeff
   newocc.clearDLocation()
   newocc.setDLocation()
   
   scribe.insertOccurrenceSet(newocc)
   newocc.writeShapefile()
   
   # added this Jeff
   newocc.clearLocalMapfile() 
   scribe.updateOccset(newocc)
   
   removeTempLAEAShp()
   
   currtime = DT.gmt().mjd
   
   projs = []
   mdl = SDMModel(Priority.REQUESTED, newocc, mdlScen, alg, 
                  name=spname, createTime=currtime, mask=None,
                  status=JobStatus.INITIALIZE, 
                  statusModTime=currtime, userId=usr)
   for pscen in prjScens:
      prj = SDMProjection(mdl, pscen, priority=Priority.REQUESTED, 
                          status=JobStatus.GENERAL, statusModTime=currtime, 
                          mask=None, userId=usr, createTime=currtime)
      projs.append(prj)
   exp = SDMExperiment(mdl, projs)
    
   scribe.insertExperiment(exp)
   print "inserted ",spname," with scribe"
   
# ...............................................
def insertWClient(spname,server="http://sporks.nhm.ku.edu"):
   
   postedExp = False
   fileType = "shapefile"
   fileName = "/tmp/naocc_LAEA.shp"
   epsgCode = 2163
   
   me = client(userId=usr,pwd=usr,server=server)
   if os.path.exists(fileName):
      try:
         CTOcc = me.sdm.postOccurrenceSet(spname, fileType, fileName, epsgCode) 
      except Exception,e:
         print str(e)," quit on post occurrence  ",spname
      else:
         # build algorithm object
         algorithm = me.sdm.getAlgorithmFromCode("GARP_BS")
         try:
            mdlScn = 45
            prjScns = [45,55,50,40]
            experiment = me.sdm.postExperiment(algorithm, mdlScn, CTOcc.id, prjScns)       
         except Exception, e:
            print str(e)," failed on post experiment ",spname
         else:
            print "posted exp "+str(experiment.id)," ",spname, "with client"
            postedExp = True
            removeTempLAEAShp()
   else:
      print "no projected occurrence set ",spname
      
   return postedExp

# # ...............................................
def createPostOccSet(scribe, logHandle, spname):
   posted = False
   try:
      tmpOcc = scribe.createOccFromGBIFByBBoxAndSimpleName(spname, NAbbox, userId=usr)
      tmpShapefile = '/tmp/naocc.shp'
      wrote = tmpOcc.writeShapefile(dlocation=tmpShapefile, overwrite=True)
      del tmpOcc
   except Exception, e:
      print str(e)
      wrote = False
   else:
      if wrote:
         clippedReProj = reprojectClip(tmpShapefile, spname)
         if clippedReProj and wrote:
            #insertWScribe(spname) 
            posted = insertWClient(spname, server="http://lifemapper.org")
         else:
            if os.path.exists("/tmp/naocc_LAEA.shp"):
               removeTempLAEAShp()
            #logHandle.write(spname+"\n")
         if not posted:
            logHandle.write(spname+"\n")
   
# ............................................................................
#  MAIN
# ............................................................................
# ...............................................
# Constants
# TODO:
#    'fagaceae.list', 'brassicaceae.list', 'poales.list', 'ericaceae.list', 
#    'orthoptera.list', 'apoidea.list'
# ...............................................
# Current Taxa; list must be in APP_DIR/data
fname = 'passeriformes.list'
inpth = APP_DIR + '/data/'
tmppth = '/tmp/'
NAbbox = (-170.0,7.0,-50.0,75.0)

usr = 'CT_SongBirds'
algCode = 'GARP_BS'

mdlScenCode = 'NA_worldclim_1.4'
prjScenCodes = ['NA_worldclim_1.4', 
                'NA_NIES_A1B_7099',
                'NA_NIES_A2_7099', 
                'NA_NIES_B1_7099']
# ...............................................
scribe = Scribe(ConsoleLogger(), openGBC=True ) 
scribe.openConnections()

mdlScen = scribe.getScenario(mdlScenCode)
prjScens = []
for psc in prjScenCodes:
   pscen = scribe.getScenario(psc)
   prjScens.append(pscen)
alg = Algorithm(algCode)
alg.fillWithDefaults()  # added this Jeff

###############################
# Get the geom Ref for the clip mask in dd
NAHandle = ogr.Open(os.path.join(inpth, 'BufferedMultiPartNA_dd.shp'))
northAmerica = NAHandle.GetLayer(0)
feature = northAmerica.GetNextFeature()
NAGeom = feature.GetGeometryRef()
geomType = ogr.wkbPoint
# ...............................................

# open log files
logHandle = open(os.path.join(tmppth, fname + ".log"),'w')
f = open(os.path.join(inpth, fname))
for spname in f:
   spname = spname.strip()
   print spname
   # ....................................................
   # Create, insert, write changeThinking occurrenceset in 2163
   # ....................................................
   posted = False
   try:
      tmpOcc = scribe.createOccFromGBIFByBBoxAndSimpleName(spname, NAbbox, userId=usr)
      tmpShapefile = '/tmp/naocc.shp'
      wrote = tmpOcc.writeShapefile(dlocation=tmpShapefile, overwrite=True)
      del tmpOcc
   except Exception, e:
      print str(e)
      wrote = False
   else:
      if wrote:
         clippedReProj = reprojectClip(tmpShapefile, spname)
         if clippedReProj:
            posted = insertWClient(spname, server="http://lifemapper.org")
         else:
            if os.path.exists("/tmp/naocc_LAEA.shp"):
               removeTempLAEAShp()
            #logHandle.write(spname+"\n")
         if not posted:
            logHandle.write(spname+"\n")
            
logHandle.close()
