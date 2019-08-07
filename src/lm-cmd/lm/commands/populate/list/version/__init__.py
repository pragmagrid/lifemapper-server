#

import lm.commands

class Command(lm.commands.list.command):

        """
        List lifemapper version

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='list version'>
        List lifemapper version 
        </example>
        """
        def run(self, params, args):
            print "Lifemapper", self.version

RollName = "lifemapper-server"

