#

import lm.commands

class Command(lm.commands.list.command):

        """
        Lists lifemapper algorithm codes defined for the database 

        <param type='string' name='code'>
        The algorithm code name. If specified, returns default parameters for this algorithm.
        </param>

        <example cmd='list algorithm'>
        SVM 
        DG_GARP_BS 
        AQUAMAPS 
        RNDFOREST
        ...
        </example>
        """

        def run(self, params, args):
            from LmServer.common.lmconstants import ALGORITHM_DATA

            if len(args)> 0 :
                code = args[0].upper()
                algmeta = ALGORITHM_DATA[code]
                print("{}: {}".format(code, algmeta['name']))
                print("parameters:")
                for param, vals in algmeta['parameters'].iteritems():
                    print("   {}: {}".format(param, str(vals)))
            else :
                algorithms  = ALGORITHM_DATA.keys()
                algorithms.sort()
                for code in algorithms:
                    algmeta = ALGORITHM_DATA[code]
                    print "    {}: {}".format(code, algmeta['name'])

RollName = "lifemapper-server"


