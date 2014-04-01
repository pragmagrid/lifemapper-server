"""
@license: gpl2
@copyright: Copyright (C) 2014, University of Kansas Center for Research
 
          Lifemapper Project, lifemapper [at] ku [dot] edu, 
          Biodiversity Institute,
          1345 Jayhawk Boulevard, Lawrence, Kansas, 66045, USA
    
          This program is free software; you can redistribute it and/or modify 
          it under the terms of the GNU General Public License as published by 
          the Free Software Foundation; either version 2 of the License, or (at 
          your option) any later version.
   
          This program is distributed in the hope that it will be useful, but 
          WITHOUT ANY WARRANTY; without even the implied warranty of 
          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
          General Public License for more details.
   
          You should have received a copy of the GNU General Public License 
          along with this program; if not, write to the Free Software 
          Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 
          02110-1301, USA.
"""
from LmServerCommon.sdm.algorithm import Algorithm
from LmServerCommon.common.geotools import GeoFileInfo
from LmCommon.common.lmconstants import DEFAULT_USER, ALGORITHM_DATA, \
                                        SAN_DATA_DIR
from LmServerCommon.common.log import DebugLogger
from LmServerCommon.db.scribe import Scribe
from LmServerCommon.sdm.envlayer import EnvironmentalType, EnvironmentalLayer                    
from LmServerCommon.sdm.scenario import Scenario
 
import osgeo.gdal as gdal
from osgeo.gdalconst import GA_ReadOnly
import mx.DateTime as DT
import os

# FIXME: Also in test/tstparams
## Environmental output file name
ENV_OUTPUT_FILENAME = 'envoutput.txt'
 
"""
select l.layerid, l.name, l.title, l.dataformat, l.dataformat, l.description, l.typedescription, l.mapunits, l.resolution, l.valattribute, l.valunits, l.typecode from lm_envlayer l, scenariolayers sl, scenario s where s.scenarioid = sl.scenarioid and sl.scenarioid = 32 and sl.layerid = l.layerid;
"""
LAYERTYPE_DATA = {'mean_pcp': {'title': 'Mean Precipitation',
                               'description': 'mean precipitation',
                               'keywords': ('precipitation', 'mean')},
                  'mean_pcp_cool_mo': {'title': 'Mean Precipitation Coolest Month',
                               'description': 'mean precipitation in coolest month',
                               'keywords': ('precipitation', 'mean', 'coolest month')},
                  'mean_pcp_cool_qtr': {'title': 'Mean Precipitation Coolest Quarter',
                               'description': 'mean precipitation in coolest quarter',
                               'keywords': ('precipitation', 'mean', 'coolest quarter')},
                  'mean_pcp_dry_mo': {'title': 'Mean Precipitation Driest Month',
                               'description': 'mean precipitation in driest month',
                               'keywords': ('precipitation', 'mean', 'driest month')},
                  'mean_pcp_dry_qtr': {'title': 'Mean Precipitation Driest Quarter',
                               'description': 'mean precipitation in driest quarter',
                               'keywords': ('precipitation', 'mean', 'driest quarter')},
                  'mean_pcp_wm_mo': {'title': 'Mean Precipitation Warmest Month',
                               'description': 'mean precipitation in warmest month',
                               'keywords': ('precipitation', 'mean', 'warmest month')},
                  'mean_pcp_wm_qtr': {'title': 'Mean Precipitation Warmest Quarter',
                               'description': 'mean precipitation in warmest quarter',
                               'keywords': ('precipitation', 'mean', 'warmest quarter')},
                  'mean_pcp_wet_mo': {'title': 'Mean Precipitation Wettest Month',
                               'description': 'mean precipitation in wettest month',
                               'keywords': ('precipitation', 'mean', 'wettest month')},
                  'mean_pcp_wet_qtr': {'title': 'Mean Precipitation Wettest Quarter',
                               'description': 'mean precipitation in wettest quarter',
                               'keywords': ('precipitation', 'mean', 'wettest quarter')},
                  'mean_pcp_frst_free_mo': 
                  {'title': 'Mean Precipitation Frost-Free Month',
                   'description': 'mean precipitation in frost free month',
                   'keywords': ('precipitation', 'mean', 'frost free month')},
                  'mean_tmp_wm_mo':
                  {'title': 'Mean Temperature Warmest Month',
                   'description': 'mean temperature in warmest month',
                   'keywords': ('mean', 'warmest month', 'temperature')},
                  'mean_diur_wm_mo':
                  {'title': 'Mean Diurnal Temperature Warmest Month',
                   'description': 'mean diurnal temperature variation in warmest month',
                   'keywords': ('mean', 'warmest month', 'diurnal')},
                  'mean_tmp_wm_qtr':
                  {'title': 'Mean Temperature Warmest Quarter',
                   'description': 'mean temperature in warmest quarter (BIO10)',
                   'keywords': ('mean', 'warmest quarter', 'temperature')},
                  'mean_frst_dys':
                  {'title': 'Mean Frost Days',
                   'description': 'mean number of frost days',
                   'keywords': ('mean', 'frost days')},
                  'mean_tmp_cool_mo':
                  {'title': 'Mean Temperature Coolest Month',
                   'description': 'mean temperature in coolest month',
                   'keywords': ('mean', 'temperature', 'coolest month')},
                  'mean_diur_cool_mo':
                  {'title': 'Mean Diurnal Temperature Coolest Month',
                   'description': 'mean diurnal temperature variation in coolest month',
                   'keywords': ('mean', 'coolest month', 'diurnal')},
                  'mean_tmp_frst_free_mo':
                  {'title': 'Mean Temperature Frost-Free Month',
                   'description': 'mean temperature in frost free month',
                   'keywords': ('mean', 'temperature', 'frost free month')},
                  'mean_tmp':
                  {'title': 'Mean Temperature',
                   'description': 'annual mean temperature (BIO1)',
                   'keywords': ('mean', 'temperature')},
                  'mean_tmp_cool_qtr':
                  {'title': 'Mean Temperature Coolest Quarter',
                   'description': 'mean temperature in coolest quarter (BIO11)',
                   'keywords': ('mean', 'temperature', 'coolest quarter')},
                  'mean_stdev_pcp':
                  {'title': 'Mean Standard Deviation of Precipitation',
                   'description': 'mean of monthly standard deviations of precipitation',
                   'keywords': ('precipitation', 'mean', 'standard deviation')},
                  'mean_stdev_tmp':
                  {'title': 'Mean Standard Deviation of Temperature',
                   'description': 'mean of monthly standard deviations of temperature',
                   'keywords': ('mean', 'standard deviation', 'temperature')},
                  'mean_wndspd':
                  {'title': 'Mean Wind Speed',
                   'description': 'mean wind speed',
                   'keywords': ('mean', 'wind speed')},
                  'mean_diur':
                  {'title': 'Mean Diurnal Temperature',
                   'description': 'mean diurnal temperature variation',
                   'keywords': ('mean', 'diurnal', 'temperature')},
                  }
# For these scenarios, the layer attributes:
#   author, mapunits, resolution, bbox, epsg all come from scenario
#   keywords come from the layertype
#   description comes from the scenario and layertype
#   nodataval, minval, maxval, gdaltype, dataformat are all read from the data
CRU_ATTRIBUTES = {'valattribute': 'pixel',
                   'valunits': 'mm',
                   'startdate': DT.DateTime(1961).mjd, 'enddate': DT.DateTime(1990).mjd,
                   'mapunits': 'dd', 'resolution': 0.166666666667, 
                   'bbox': [-180, -90, 180, 90],
                   'epsg': 4326,
                   'mapunits': 'dd'}
LAYERS = {'mean_pcp': {'present': {'title': 'Mean Precipitation, CRU CL 2.0',
                                           'filename': 'meanPrecip.tif'},
                               'a1f': {'title': 'Mean Precipitation, 2050, IPCC TAR Scenario A1f, Hadley Centre', 
                                       'filename': 'Mean_daily_precipitation.tif'},
                               'a2c': {'title': 'Mean Precipitation, 2050, IPCC TAR Scenario A2c, Hadley Centre', 
                                       'filename': 'Mean_daily_precipitation.tif'}, 
                               'b1a': {'title': 'Mean Precipitation, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                       'filename': 'Mean_daily_precipitation.tif'}
                       },
                  'mean_pcp_cool_mo': {'present': {'title': 'Mean Precipitation Coolest Month, CRU CL 2.0',
                                                   'filename': 'meanPrecipOverCoolestM.tif'},
                                       'a1f': {'title': 'Mean Precipitation Coolest Month, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_coolest_month.tif'},
                                       'a2c': {'title': 'Mean Precipitation Coolest Month, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_coolest_month.tif'}, 
                                       'b1a': {'title': 'Mean Precipitation Coolest Month, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_coolest_month.tif'}},
                  'mean_pcp_cool_qtr': {'present': {'title': 'Mean Precipitation Coolest Quarter, CRU CL 2.0',
                                                    'filename': 'meanPrecipOverCoolestQ.tif'},
                                        'a1f': {'title': 'Mean Precipitation Coolest Quarter, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_coolest_quarter.tif'},
                                        'a2c': {'title': 'Mean Precipitation Coolest Quarter, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_coolest_quarter.tif'}, 
                                        'b1a': {'title': 'Mean Precipitation Coolest Quarter, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                                'filename': 'Mean_daily_precipitation_in_coolest_quarter.tif'}},
                  'mean_pcp_dry_mo': {'present': {'title': 'Mean Precipitation Driest Month, CRU CL 2.0',
                                                  'filename': 'meanPrecipOverDriestM.tif'},
                                      'a1f': {'title': 'Mean Precipitation Driest Month, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_driest_month.tif'},
                                      'a2c': {'title': 'Mean Precipitation Driest Month, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_driest_month.tif'}, 
                                      'b1a': {'title': 'Mean Precipitation Driest Month, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_driest_month.tif'}},
                  'mean_pcp_dry_qtr': {'present': {'title': 'Mean Precipitation Driest Quarter, CRU CL 2.0',
                                                   'filename': 'meanPrecipOverDriestQ.tif'},
                                      'a1f': {'title': 'Mean Precipitation Driest Quarter, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_driest_quarter.tif'},
                                      'a2c': {'title': 'Mean Precipitation Driest Quarter, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_driest_quarter.tif'}, 
                                      'b1a': {'title': 'Mean Precipitation Driest Quarter, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_driest_quarter.tif'}},
                  'mean_pcp_wm_mo': {'present': {'title': 'Mean Precipitation Warmest Month, CRU CL 2.0',
                                                 'filename': 'meanPrecipOverWarmestM.tif'},
                                      'a1f': {'title': 'Mean Precipitation Warmest Month, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_warmest_month.tif'},
                                      'a2c': {'title': 'Mean Precipitation Warmest Month, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_warmest_month.tif'}, 
                                      'b1a': {'title': 'Mean Precipitation Warmest Month, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_warmest_month.tif'}},
                  'mean_pcp_wm_qtr': {'present': {'title': 'Mean Precipitation Warmest Quarter, CRU CL 2.0',
                                                  'filename': 'meanPrecipOverWarmestQ.tif'},
                                      'a1f': {'title': 'Mean Precipitation Warmest Quarter, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_warmest_quarter.tif'},
                                      'a2c': {'title': 'Mean Precipitation Warmest Quarter, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_warmest_quarter.tif'}, 
                                      'b1a': {'title': 'Mean Precipitation Warmest Quarter, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_warmest_quarter.tif'}},
                  'mean_pcp_wet_mo': {'present': {'title': 'Mean Precipitation Wettest Month, CRU CL 2.0',
                                                  'filename': 'meanPrecipOverWettestM.tif'},
                                      'a1f': {'title': 'Mean Precipitation Wettest Month, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_wettest_month.tif'},
                                      'a2c': {'title': 'Mean Precipitation Wettest Month, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_wettest_month.tif'}, 
                                      'b1a': {'title': 'Mean Precipitation Wettest Month, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                              'filename': 'Mean_daily_precipitation_in_wettest_month.tif'}},
                  'mean_pcp_wet_qtr': {'present': {'title': 'Mean Precipitation Wettest Quarter, CRU CL 2.0',
                                                   'filename': 'meanPrecipOverWettestQ.tif'},
                                       'a1f': {'title': 'Mean Precipitation Wettest Quarter, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_wettest_quarter.tif'},
                                       'a2c': {'title': 'Mean Precipitation Wettest Quarter, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_wettest_quarter.tif'}, 
                                       'b1a': {'title': 'Mean Precipitation Wettest Quarter, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_daily_precipitation_in_wettest_month.tif'}},
                  'mean_tmp': {'present': {'title': 'Mean Temperature, CRU CL 2.0',
                                           'filename': 'meanTemp.tif'},
                                       'a1f': {'title': 'Mean Temperature, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_temperature.tif'},
                                       'a2c': {'title': 'Mean Temperature, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_temperature.tif'}, 
                                       'b1a': {'title': 'Mean Temperature, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_temperature.tif'}},
                  'mean_tmp_cool_mo': {'present': {'title': 'Mean Temperature Coolest Month, CRU CL 2.0',
                                                   'filename': 'meanTempOverCoolestM.tif'},
                                       'a1f': {'title': 'Mean Temperature Coolest Month, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_temperature_in_coolest_month.tif'},
                                       'a2c': {'title': 'Mean Temperature Coolest Month, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_temperature_in_coolest_month.tif'}, 
                                       'b1a': {'title': 'Mean Temperature Coolest Month, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_temperature_in_coolest_month.tif'}},
                  'mean_tmp_cool_qtr': {'present': {'title': 'Mean Temperature Coolest Quarter, CRU CL 2.0',
                                                    'filename': 'meanTempOverCoolestQ.tif'},
                                       'a1f': {'title': 'Mean Temperature Coolest Quarter, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_temperature_in_coolest_quarter.tif'},
                                       'a2c': {'title': 'Mean Temperature Coolest Quarter, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_temperature_in_coolest_quarter.tif'}, 
                                       'b1a': {'title': 'Mean Temperature Coolest Quarter, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_temperature_in_coolest_quarter.tif'}},
                  'mean_tmp_wm_mo': {'present': {'title': 'Mean Temperature Warmest Month, CRU CL 2.0',
                                                 'filename': 'meanTempOverWarmestM.tif'},
                                       'a1f': {'title': 'Mean Temperature Warmest Month, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_temperature_in_warmest_month.tif'},
                                       'a2c': {'title': 'Mean Temperature Warmest Month, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_temperature_in_warmest_month.tif'}, 
                                       'b1a': {'title': 'Mean Temperature Warmest Month, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_temperature_in_warmest_month.tif'}},
                  'mean_tmp_wm_qtr': {'present': {'title': 'Mean Temperature Warmest Quarter, CRU CL 2.0',
                                                  'filename': 'meanTempOverWarmestQ.tif'},
                                       'a1f': {'title': 'Mean Temperature Warmest Quarter, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Mean_temperature_in_warmest_quarter.tif'},
                                       'a2c': {'title': 'Mean Temperature Warmest Quarter, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Mean_temperature_in_warmest_quarter.tif'}, 
                                       'b1a': {'title': 'Mean Temperature Warmest Quarter, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Mean_temperature_in_warmest_quarter.tif'}},
                  'mean_stdev_pcp': {'present': {'title': 'Mean Standard Deviation of Precipitation, CRU CL 2.0',
                                                 'filename': 'stdevMeanPrecip.tif'},
                                       'a1f': {'title': 'Mean Standard Deviation of Precipitation, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Standard_deviation_of_mean_precipitation.tif'},
                                       'a2c': {'title': 'Mean Standard Deviation of Precipitation, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Standard_deviation_of_mean_precipitation.tif'}, 
                                       'b1a': {'title': 'Mean Standard Deviation of Precipitation, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Standard_deviation_of_mean_precipitation.tif'}},
                  'mean_stdev_tmp': {'present': {'title': 'Mean Standard Deviation of Temperature, CRU CL 2.0',
                                                 'filename': 'stdevMeanTemp.tif'},
                                       'a1f': {'title': 'Mean Standard Deviation of Temperature, 2050, IPCC TAR Scenario A1f, Hadley Centre',
                                               'filename': 'Standard_deviation_of_mean_temperature.tif'},
                                       'a2c': {'title': 'Mean Standard Deviation of Temperature, 2050, IPCC TAR Scenario A2c, Hadley Centre',
                                               'filename': 'Standard_deviation_of_mean_temperature.tif'}, 
                                       'b1a': {'title': 'Mean Standard Deviation of Temperature, 2050, IPCC TAR Scenario B1a, Hadley Centre',
                                               'filename': 'Standard_deviation_of_mean_temperature.tif'}},
                  }
LAYER_UNITS = {'mean_pcp': 'mm',
               'mean_pcp_cool_mo': 'mm',
               'mean_pcp_cool_qtr': 'mm',
               'mean_pcp_dry_mo': 'mm',
               'mean_pcp_dry_qtr': 'mm',
               'mean_pcp_wm_mo': 'mm',
               'mean_pcp_wm_qtr': 'mm',
               'mean_pcp_wet_mo': 'mm',
               'mean_pcp_wet_qtr': 'mm',
               'mean_tmp': 'degreesCelsiusTimes100',
               'mean_tmp_cool_mo': 'degreesCelsiusTimes100',
               'mean_tmp_cool_qtr': 'degreesCelsiusTimes100',
               'mean_tmp_wm_mo': 'degreesCelsiusTimes100',
               'mean_tmp_wm_qtr': 'degreesCelsiusTimes100',
               'mean_stdev_pcp': 'mm',
               'mean_stdev_tmp': 'degreesCelsiusTimes100'}

SCENARIO_DATA = {
'CRU' : 
   {'path': 'ClimateData/Present/cru_cl2',
    'descSuffix': ' CRU CL 2.0, Observed mean climate from 1961-1990 covering the global land surface at a 10 minute spatial resolution, http://www.cru.uea.ac.uk/~timm/grid/CRU_CL_2_0.html',
    'title': 'CRU, Average 1961-1990', 
    'author': 'New, M., Lister, D., Hulme, M. and Makin, I., 2002: A ' +
              'high-resolution data set of surface climate over global ' +
              'land areas. Climate Research 21:1-25', 
    'description': 'CRU CL 2.0, Climate Research Unit, Observed mean climate ' + 
                   'from 1961-1990 covering the global land surface at a 10 ' + 
                   'minute spatial resolution ' + 
                   '(http://www.cru.uea.ac.uk/~timm/grid/CRU_CL_2_0.html). ' ,
    'startdate': DT.DateTime(1961).mjd, 'enddate': DT.DateTime(1990).mjd,
    'units': 'dd', 'resolution': 0.166666666667, 
    'bbox': [-180, -90, 180, 90],
    'epsg': 4326,
    'path': os.path.join(SAN_DATA_DIR, 'ClimateData/Present/cru/cl2'),
    'keywords': ['bioclimatic variables', 'averaged 1961-1990', 'observed',
                 'present', 'climate'],
   },

'hadley_a1f' : 
   {'path': 'ClimateData/Future/hadley_diff_plus_obs/2050/A1F',
    'descSuffix': ' predicted for 2050, calculated from CRU CL 2.0 observed mean climate plus change modeled by Hadley Centre, UK for the IPCC Third Assessment Report (2001), Scenario A1f',
    'title': 'Hadley, IPCC TAR A1, 2050',
    'author': 'Pahwa, Jaspreet S., et al. "Biodiversity World: A ' + 
              'problem-solving environment for analysing biodiversity ' +
              'patterns." Cluster Computing and the Grid, 2006. CCGRID 06. ' +
              'Sixth IEEE International Symposium on. Vol. 1. IEEE, 2006.', 
    'description': 'Predicted 2050 climate calculated from CRU CL 2.0 ' + 
                   'observed mean climate plus change modeled by Hadley ' +
                   'Centre, UK for the IPCC Third Assessment Report (2001), ' +
                   'Scenario A1f',
    'startdate': DT.DateTime(2050).mjd, 'enddate': DT.DateTime(2050).mjd,
    'units': 'dd', 'resolution': 0.25, 
    'bbox': [-180, -90, 180, 90],
    'epsg': 4326,
    'keywords': ['predicted', 'economic development', 'globalization',
                 'IPCC TAR Scenario A1', '2050', 'future', 'climate'],
    },

'hadley_a2c' : 
   {'path': 'ClimateData/Future/hadley_diff_plus_obs/2050/A2c',
    'descSuffix': ' predicted for 2050, calculated from CRU CL 2.0 observed mean climate plus change modeled by Hadley Centre, UK for the IPCC Third Assessment Report (2001), Scenario A2c',
    'title': 'Hadley, IPCC TAR A2, 2050',
    'author': 'Pahwa, Jaspreet S., et al. "Biodiversity World: A ' + 
              'problem-solving environment for analysing biodiversity ' +
              'patterns." Cluster Computing and the Grid, 2006. CCGRID 06. ' +
              'Sixth IEEE International Symposium on. Vol. 1. IEEE, 2006.', 
    'description': 'Predicted 2050 climate calculated from CRU CL 2.0 ' + 
                   'observed mean climate plus change modeled by Hadley ' +
                   'Centre, UK for the IPCC Third Assessment Report (2001), ' +
                   'Scenario A2c',
    'startdate': DT.DateTime(2050).mjd, 'enddate': DT.DateTime(2050).mjd,
    'units': 'dd', 'resolution': 0.25, 
    'bbox': [-180, -90, 180, 90],
    'epsg': 4326,
    'keywords': ['predicted', 'economic development', 'regionalization',
                 'IPCC TAR Scenario A2', '2050', 'future', 'climate'],
    },

 'hadley_b1a' : 
   {'path': 'ClimateData/Future/hadley_diff_plus_obs/2050/B1a',
    'descSuffix': ' predicted for 2050, calculated from CRU CL 2.0 observed mean climate plus change modeled by Hadley Centre, UK for the IPCC Third Assessment Report (2001), Scenario B1a',
    'title': 'Hadley, IPCC TAR B1, 2050',
    'author': 'Pahwa, Jaspreet S., et al. "Biodiversity World: A ' + 
              'problem-solving environment for analysing biodiversity ' +
              'patterns." Cluster Computing and the Grid, 2006. CCGRID 06. ' +
              'Sixth IEEE International Symposium on. Vol. 1. IEEE, 2006.', 
    'description': 'Predicted 2050 climate calculated from CRU CL 2.0 ' + 
                   'observed mean climate plus change modeled by Hadley ' +
                   'Centre, UK for the IPCC Third Assessment Report (2001), ' +
                   'Scenario A2c',
    'startdate': DT.DateTime(2050).mjd, 'enddate': DT.DateTime(2050).mjd,
    'units': 'dd', 'resolution': 0.25, 
    'bbox': [-180, -90, 180, 90],
    'epsg': 4326,
    'keywords': ['predicted', 'sustainable development', 'globalization',
                 'IPCC TAR Scenario B1', '2050', 'future', 'climate'],
    }
                 }

# ...............................................
def addAlgorithms(scribe):
   """
   @summary Adds algorithms to the database from the algorithm dictionary
   """
   ids = []
   for algcode, algdict in ALGORITHM_DATA.iteritems():
      alg = Algorithm(algcode, name=algdict['name'])
      algid = scribe.insertAlgorithm(alg)
      ids.append(algid)
   return ids

# ...............................................
def addLayerTypes(scribe): 
   ids = [] 
   for typecode, typeinfo in LAYERTYPE_DATA.iteritems():
      ltype = EnvironmentalType(typecode, typeinfo['title'], 
                                typeinfo['description'], DEFAULT_USER, 
                                keywords=typeinfo['keywords'], 
                                modTime=DT.gmt().mjd)
      etypeid = scribe.getOrInsertLayerTypeCode(ltype)
      ids.append(etypeid)
   return ids

# ...............................................
def createScenarios():
   """
   @summary Adds SDL services being used for scenarios to the MAL
   """
   currtime = DT.gmt().mjd

   scenarios = {}
   layersets = {}
   for scode, scenvals in SCENARIO_DATA.iteritems():
      scen = Scenario(scode, title=scenvals['title'], author=scenvals['author'], 
                      description=scenvals['description'], 
                      startdt=scenvals['startdate'], enddt=scenvals['enddate'], 
                      units=scenvals['units'], res=scenvals['resolution'], 
                      bbox=scenvals['bbox'], modTime=currtime, 
                      keywords=scenvals['keywords'], 
                      epsgcode=scenvals['epsg'],
                      layers=None, userId=DEFAULT_USER, scenarioid=None)
      scenarios[scode] = scen
      layersets[scode] = []
   
   for ltype, lyrvals in LAYERS.iteritems():
      for timecode, morevals in lyrvals.iteritems():  
         if timecode == 'present':
            scode = 'CRU'
         else:
            scode = 'hadley_' + timecode
               
         lyrname = ltype + ': %s' % timecode
         lyrtitle = morevals['title']
         
         pos = lyrtitle.find(',') + 1
         lyrdesc = lyrtitle[:pos] + SCENARIO_DATA[scode]['descSuffix']
         
         dloc = os.path.join(SAN_DATA_DIR, SCENARIO_DATA[scode]['path'], 
                             morevals['filename'])
         
         envlyr = EnvironmentalLayer(lyrname, title=morevals['title'], layerurl=None, 
                   minVal=None, maxVal=None, nodataVal=None, 
                   valUnits=LAYER_UNITS[ltype],
                   isCategorical=False, bbox=SCENARIO_DATA[scode]['bbox'], 
                   dlocation=dloc, metalocation=None,
                   gdalType=None, gdalFormat='GTiff', 
                   startDate=SCENARIO_DATA[scode]['startdate'], 
                   endDate=SCENARIO_DATA[scode]['enddate'], 
                   mapunits=SCENARIO_DATA[scode]['units'], 
                   resolution=None, 
                   epsgcode=SCENARIO_DATA[scode]['epsg'],
                   keywords=LAYERTYPE_DATA[ltype]['keywords'], 
                   description=lyrdesc, isDiscreteData=None,
                   layerType=None, layerTypeId=None, layerTypeTitle=None, 
                   layerTypeDescription=None, layerTypeModTime=None,
                   userId=DEFAULT_USER, layerId=None,
                   createTime=currtime, modTime=currtime, metadataUrl=None)
         layersets[scode].append(envlyr)
         
   for scode, scen in scenarios.iteritems():
      scen.layers = layersets[scode]
   
   return scenarios
          
      
   
# ...............................................
if __name__ == '__main__':  
   logger = DebugLogger()
    
   scribe = Scribe(logger)
    
   scribe.openConnections()
 
   try:
      aIds = addAlgorithms(scribe)
      ltIds = addLayerTypes(scribe)
      scenarios = createScenarios()
      for scode, scen in scenarios.iteritems():
         scribe.insertScenario(scen)
   finally:
      scribe.closeConnections()
       
# '''
# \c sdltest
# delete from layersrs;
# delete from layerkeyword;
# delete from srs;
# delete from keyword;
# delete from layer;
# delete from service;
# 
# # Purge MAL database
# # Run addAlgorithms and addScenarios after purging
# 
# \c maltest
# delete from algorithmparams;
# delete from algorithm;
# 
# # Purge scenario/model/projection data
# drop table projection ;
# drop table model;
# drop table scenariolayers;
# drop table layertype;
# drop table layer;
# drop table scenariokeywords;
# drop table keyword;
# drop table scenario
# '''
#    