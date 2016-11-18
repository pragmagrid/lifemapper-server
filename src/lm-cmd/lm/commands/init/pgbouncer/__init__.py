#

import lm.commands

class Command(lm.commands.init.command):

        """
        Initialize  pgbouncer configuration

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='init pgbouncer'>
        Initialize  pgbouncer configuration
        </example>
        """
        def run(self, params, args):
            print "FIXME lm init pgbouncer", self.version

RollName = "lifemapper-server"

