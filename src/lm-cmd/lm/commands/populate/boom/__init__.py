#

import lm.commands

class Command(lm.commands.populate.command):
   """
   Populate lifemapper with inputs for a BOOM archive
   
   <param type='string' name='configFile'>
   The absolute path of configuration file for this BOOM archive
   </param>
   
   <example cmd='init populate boom'>
   Populate lifemapper database with inputs for the default archive
   </example>

   <example cmd='init populate boom /tmp/boom_sample.ini'>
   Populate lifemapper database with inputs for boom_sample archive
   </example>
   """
   def run(self, params, args):
      print "TESTME lm populate boom", self.version
      from LmDbServer.boom.boominput import ArchiveFiller
      
      configFname = None
      if len(args)> 0 :
         configFname = args[0]
         if not os.path.exists(configFname):
            raise Exception('Missing BOOM configuration file {}'
                            .format(configFname))
            
      filler = ArchiveFiller(configFname=configFname)
      logFname = filler.logFilename
      userPath = filler.userPath
      
      filler.open()
      filler.initBoom()
      filler.close()
      
      print 'Logfile written to {}'.format(logFname)

RollName = "lifemapper-server"

