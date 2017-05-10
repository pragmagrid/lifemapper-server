#

import lm.commands

class Command(lm.commands.init.command):

   """
   Populate lifemapper with inputs for a BOOM archive
   
   <param type='string' name='configFile'>
   The absolute path of configuration file for this BOOM archive
   </param>
   
   <example cmd='init populate taxonomy'>
   Populate lifemapper database with GBIF Backbone taxonomy values from 
   default GBIF-exported taxonomy CSV file.
   </example>

   <example cmd='init populate taxonomy /tmp/new_gbif_taxonomy.txt'>
   Populate lifemapper database with GBIF Backbone taxonomy values from 
   new GBIF-exported taxonomy CSV file.
   """

   def run(self, params, args):
      """
      @todo: Add keyword parameters, defaults are: 
                 taxonomySourceName=TAXONOMIC_SOURCE['GBIF']['name'] 
                 taxonomyFname=GBIF_TAXONOMY_DUMP_FILE
                 delimiter='\t'\
      @note: For now just accept an optional filename, assumed to be a
             tab-delimited GBIF taxonomy text file. 
      """
      print "TESTME lm populate taxonomy", self.version
      from LmDbServer.tools.readTaxonomy import TaxonFiller
      
      if len(args)> 0 :
         taxonFname = args[0]
         if not os.path.exists(taxonFname):
            raise Exception('Missing BOOM configuration file {}'
                            .format(configFname))
         filler = TaxonFiller(taxonFname)
      else:
         filler = TaxonFiller()
      
      logFname = filler.logFilename
      
      filler.open()
      filler.readAndInsertTaxonomy()
      filler.close()
      print 'Logfile written to {}'.format(logFname)

RollName = "lifemapper-server"

