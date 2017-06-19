#

import lm.commands

class Command(lm.commands.init.command):

   """
   Populate lifemapper with user-provided taxonomy records
   
   <param type='string' name='taxonomyFile'>
   The absolute path of taxonomy file containing comma-separated values of 
   User-provided taxonomy. 
   </param>
   
   <example cmd='populate taxonomy user /tmp/user_taxonomy.txt'>
   Populate lifemapper database with User-provided taxonomy values.
   """
   def run(self, params, args):
      print "FIXME lm populate taxonomy user", self.version

RollName = "lifemapper-server"

