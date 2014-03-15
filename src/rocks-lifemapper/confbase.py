
import os
import sys
import time
import glob
import stat
import confconst
import shutil
from pprint import pprint

class Baseconfig:
    """ base class for all configurations"""
    def __init__(self, argv):
        self.usage_command = os.path.basename(argv[0])
        self.usage_version = "1.0"
        self.args          = argv[1:]
        self.base          = glob.glob("/var/lib/pgsql/*/data/")[0] # postgres installation dir
        self.descinfo      = ''
        self.nameinfo      = ''
        self.specinfo      = ''
        self.space         = '    '
        self.time          = None        # time stamp of running the script
        self.uid           = None        # file owner  (for config files)
        self.gid           = None        # file group  (for config files)
        self.users         = confconst.USERS_FILE
        self.userlist      = confconst.USER_LIST 
        self.adminlist     = confconst.ADMIN_LIST
        self.sqldir        = confconst.SQLDIR 
        self.role          = confconst.ROLE 
        self.roletempl     = confconst.ROLETEMPL
        self.unixSocketDir = confconst.UNIX_SOCKET_DIR


    def parseArgs(self):
        """ check input arguments, and print usage"""
        if len(self.args) == 0:
            return
        if self.args[0] in ('-h', '--help', 'help'):
            self.help()

    def help(self):
        self.printName()
        self.printSynopsis()
        self.printDescription()
        self.printSpecific()
        sys.exit(0)

    def printName(self):
        print "\nNAME\n%s%s - %s." % (self.space, self.usage_command, self.nameinfo)
        print "%sversion - %s" % (self.space, self.usage_version)

    def printSynopsis(self):
        print '\nSYNOPSIS\n', self.space + self.usage_command, "[-h|--help|help]"

    def printDescription(self):
        print '\nDESCRIPTION\n', self.space +  self.descinfo

    def printSpecific(self):
        print self.specinfo


    def readFile(self, fname):
        """ read file, return content as array of lines"""
        try:
            fin = open(fname, "r")
            lines = fin.readlines()
            fin.close()
        except IOError as e:
            print "ERROR: ", e.strerror, "%s" % fname
            sys.exit(1)
        return lines


    def readFileText(self, fname):
        """ read file, return content as char array """
        try:
            fin = open(fname, "r")
            content = fin.read()
            fin.close()
        except IOError as e:
            print "ERROR: ", e.strerror, "%s" % fname
            sys.exit(1)
        return content


    def writeFile(self, fname, content):
        """ write file """
        try:
            fout = open(fname, "w")
            fout.write(content)
            fout.close()
            print "Created %s file" % fname
        except IOError as e:
            print "ERROR: ", e.strerror, "%s" % fname
            sys.exit(1)


    def findTime(self):
        """ create a time stamp of running the script. 
            Time stamp is used as a  suffix for saved files """
        secs = time.time()
        tuple = time.localtime(secs)
        self.time = ".%s" % time.strftime("%Y%m%d-%H%M", tuple)


    def getPerms(self, file):
        """ find permissions and ownership for the file """
        stats = os.stat(file)
        self.uid = stats[stat.ST_UID]
        self.gid = stats[stat.ST_GID]


    def checkTemplates(self, conf, templ):
        """ check if there is a template for config file, if not (1st time run) create from orig config
            files deposited by RPMs."""
        if not os.path.isfile(templ):
            shutil.copy2(conf, templ)
            self.getPerms(conf)
            os.chown(templ, self.uid, self.gid)
            print "Created template %s " % (templ)

    def runTest(self):
        """ test output """
        pprint (self.__dict__)

