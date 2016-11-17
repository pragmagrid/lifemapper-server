#

import lm.commands

class Command(lm.commands.init.command):

        """
        Initialize  postgres configuration

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='init postgres'>
        Initialize  postgres configuration
        </example>
        """
        def run(self, params, args):
            print "FIXME lm init postgres", self.version

RollName = "lifemapper-server"

