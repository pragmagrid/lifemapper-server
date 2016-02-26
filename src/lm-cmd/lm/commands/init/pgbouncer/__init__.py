#

import lm.commands

class Command(lm.commands.list.command):

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
            print "Lifemapper", self.version

RollName = "lifemapper-server"

