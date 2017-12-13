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
            from LmServer.common.lmconstants import Algorithms

            if len(args)> 0 :
                code = args[0].upper()
                algQualities = Algorithms.get(code)
                print("{}: {}".format(code, algQualities.name))
                print("parameters:")
                for param, vals in algQualities.parameters.iteritems():
                    print("   {}: {}".format(param, str(vals)))
            else :
                algCodes  = Algorithms.codes()
                algCodes.sort()
                for code in algCodes:
                    algQualities = Algorithms.get(code)
                    for param, vals in algQualities.parameters.iteritems():
                        print("   {}: {}".format(param, str(vals)))

RollName = "lifemapper-server"


