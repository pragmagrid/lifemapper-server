#

import lm.commands

class Command(lm.commands.populate.command):
   """
   Populate lifemapper with inputs for a BOOM archive
   
   <param type='string' name='configFile'>
   The absolute path of configuration file for this BOOM archive. This 
   parameter is optional, if not provided, default values from 
   LMHOME/config/config.lmserver.ini and config.site.ini are used.
   </param>
   
   <example cmd='populate boom input'>
   Populate lifemapper database with inputs for a boom archive
   </example>

   <example cmd='populate boom input /tmp/boom_sample.ini'>
   Populate lifemapper database with inputs for boom_sample archive
   </example>
   """
   def run(self, params, args):
      print "TESTME lm populate boom input", self.version
      from LmDbServer.boom.initboom import BoomFiller
      
      configFname = None
      if len(args)> 0 :
         configFname = args[0]
         if not os.path.exists(configFname):
            raise Exception('Missing BOOM configuration file {}'
                            .format(configFname))
            
      filler = BoomFiller(configFname=configFname)
      filler.initializeInputs()
      logFname = filler.logFilename
      userPath = filler.userPath

      filler.initBoom()
      filler.close()
      
#       print('Check permissions on {}; must be writeable for `lmwriter`'
#             .format(userPath))
      print('Logfile written to {}'.format(logFname))

RollName = "lifemapper-server"

