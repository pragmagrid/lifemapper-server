#

import lm.commands

class Command(lm.commands.init.command):

   """
   Populate lifemapper with GBIF Backbone Taxonomy
   
   <param type='string' name='taxonomyFile'>
   The absolute path of taxonomy file containing comma-separated values of 
   GBIF backbone taxonomy. This parameter is optional, if not provided, 
   data is provided from the file GBIF_TAXONOMY_DUMP_FILE present in the  
   LMHOME/config/config.lmserver.ini file.
   </param>
   
   <example cmd='populate taxonomy GBIF'>
   Populate lifemapper database with GBIF Backbone taxonomy values from a 
   CSV file containing GBIF backbone taxonomy.
   </example>

   <example cmd='populate taxonomy GBIF /tmp/new_gbif_taxonomy.txt'>
   Populate lifemapper database with GBIF Backbone taxonomy values from 
   new GBIF-exported taxonomy CSV file.
   """

   def run(self, params, args):
      """
      """
      print "TESTME lm populate taxonomy GBIF", self.version
      from LmDbServer.tools.readTaxonomy import TaxonFiller
      
      if len(args)> 0 :
         taxonFname = args[0]
         if not os.path.exists(taxonFname):
            raise Exception('Missing taxonomy file {}'
                            .format(taxonFname))
         filler = TaxonFiller(taxonomyFname=taxonFname)
      else:
         filler = TaxonFiller()
      
      logFname = filler.logFilename
      
      filler.open()
      filler.readAndInsertTaxonomy()
      filler.close()
      print 'Logfile written to {}'.format(logFname)

RollName = "lifemapper-server"

