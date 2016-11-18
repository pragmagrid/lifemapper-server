#

import lm.commands

class Command(lm.commands.list.command):

        """
        List lifemapper users defined in config files  

        <param type='string' name='basepath'>
        The absolute path of lm
        </param>

        <example cmd='list users'>
        List lifemapper users 
        </example>
        """

        def run(self, params, args):
            self.section = "LmServer - environment"
            self.useropt = "ARCHIVE_USER"
            import ConfigParser
            self.config = ConfigParser.SafeConfigParser()
            self.config.read(self.server_config)
            user = self.config.get(self.section, self.useropt)
            print "%s %s" % (self.useropt, user)

RollName = "lifemapper-server"


