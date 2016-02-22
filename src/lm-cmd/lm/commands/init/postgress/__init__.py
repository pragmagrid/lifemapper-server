#

import lm.commands

class Command(lm.commands.list.command):

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
            print "Lifemapper", self.version

RollName = "lifemapper-server"

