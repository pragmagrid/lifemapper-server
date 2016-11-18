#

import lm.commands

class Command(lm.commands.init.command):

        """
        Initialize  database configuration

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='init db'>
        Initialize  database configuration
        </example>
        """
        def run(self, params, args):
            print "FIXME lm init db", self.version

RollName = "lifemapper-server"

