#

import lm.commands

class Command(lm.commands.init.command):

        """
        Initialize  user configuration

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='init user'>
        Initialize  user configuration
        </example>
        """
        def run(self, params, args):
            print "FIXME lm init user", self.server_config

RollName = "lifemapper-server"

