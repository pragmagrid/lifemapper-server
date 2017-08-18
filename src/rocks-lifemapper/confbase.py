#!/opt/rocks/bin/python

import os
import sys
import time
import glob
import stat
import confconst
import subprocess
import shutil
from pprint import pprint
from IPy import IP


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
        self.feCPUCount    = None        # number of CPUs on frontend
        self.users         = confconst.USERS_FILE
        self.userlist      = confconst.USER_LIST 
        self.adminlist     = confconst.ADMIN_LIST
        self.sqldir        = confconst.SQLDIR 
        self.role          = confconst.ROLE 
        self.roletempl     = confconst.ROLETEMPL
        self.unixSocketDir = confconst.UNIX_SOCKET_DIR
        self.ip = None
        self.iface         = None        # need to establish for each host
        self.reconfigure   = False       # indicates if need to rerun configuration

    def parseArgs(self):
        """ check input arguments, and print usage"""
        if len(self.args) == 0:
            return
        if self.args[0] in ('-h', '--help', 'help'):
            self.help()
        # set flag - need to reconfigure based on new network info
        if self.args[0] in ('reconfigure'):
            self.reconfigure = True

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


    def backupFile(self, fname):
        """ backup file """
        if os.path.exists(fname):
            self.findTime()
            basename, ext = os.path.splitext(fname)
            bakname = basename + self.time
            content = self.readFileText(fname)
            self.writeFile(bakname, content)
            try:
                os.remove(fname)
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
            self.saveOrigFile(conf, templ) #FIXME check this out
            print "Created template %s " % (templ)

    def saveOrigFile(self, orig, copy):
        """ save file as a copy """
        shutil.copy2(orig, copy)
        self.getPerms(orig)
        os.chown(copy, self.uid, self.gid)

    def runTest(self):
        """ test output """
        pprint (self.__dict__)

    def getNetworkInfo(self):
        """ find host network info for public interface """
        cmd = "/opt/rocks/bin/rocks list host attr localhost | grep Kickstart_Public"
        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        lines = info.split("\n")
        for line in lines:
            if len(line):
                parts = line.split()
                if parts[1]  == "Kickstart_PublicAddress": self.ip = parts[2]
                if parts[1]  == "Kickstart_PublicNetwork": self.network = parts[2]
                if parts[1]  == "Kickstart_PublicNetmaskCIDR": self.cidr = parts[2]
                if parts[1]  == "Kickstart_PublicInterface": self.iface = parts[2]

        if self.iface == None:
            print "Missing information about public interface "
            sys.exit(1)

        if self.ip == None or self.network == None or self.cidr == None:
            (self.ip, self.network, self.cidr ) = self.findIfaceVals(self.iface)

        if self.ip == None or self.network == None or self.cidr == None:
            print "Missing information about public interface "
            sys.exit(1)

    def getFrontendCPUCount(self):
        """ find total number of CPUs for frontend """
        cpuCount = 0
        cmd = "/opt/rocks/bin/rocks list host | grep Frontend"
        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        line = info.split("\n")
        parts = line.split()
        cpuCount = int(parts[2])
        self.feCPUCount = cpuCount

    def findIfaceVals(self, iface):
        """find ip, netmask, subnet, cidr, broadcast for a given interface. return as a tuple"""
        __name__ = "findIfaceVals"

        cmd = '/sbin/ifconfig %s | grep Mask' % iface

        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        if err: 
            print "/sbin/ifconfig returned error: %s" % err
        parts = info.split()
        try:
            tmp, ip = parts[1].split(':')
            tmp, netmask = parts[3].split(':')
        except:
            print "ERROR: can't find information for %s interface" % iface
            sys.exit(1)

        i = IP(ip).make_net(netmask)
        broadcast = i.broadcast().strNormal()
        subnet, cidr = (i.strNormal()).split('/')

        return (ip, subnet, cidr )

