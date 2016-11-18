#

import lm.commands

class Command(lm.commands.init.command):

        """
        Initialize  lifemapper configuration

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='init config'>
        Initialize  lifemapper configuration
        </example>
        """
        def run(self, params, args):
            print "FIXME lm init config", self.version

RollName = "lifemapper-server"

