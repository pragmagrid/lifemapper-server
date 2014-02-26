#!/usr/bin/env python

import os
import sys
import glob
import subprocess
import shutil
from pprint import pprint


class PGconfig:
    def __init__(self, argv):
        self.args = argv[1:]
        self.memtotal       = None    # total memory in Kb
        self.shmall         = None    # maximum number of shared memory segments
        self.shmmax         = None    # maximum shared segment size
        self.page_size      = None    # PAGE_SIZE value
        self.shared_buffers = None    # PAGE_SIZE value
        self.percent        = 0.4     # allocation of memory (%) to shared buffers, see
                                      # http://www.postgresql.org/docs/9.1/static/runtime-config-resource.html

        self.base = glob.glob("/var/lib/pgsql/*/data/")[0]

        self.findSysValues()

    def findSysValues(self):
        self.getMemory()
        self.getSHMALL()
        self.getSHMMAX()
        self.getPageSize()
        self.getSharedBuffers()

    def getMemory(self):
        """ find total memory """
        cmd = "cat /proc/meminfo | grep MemTotal"
        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        self.memtotal = int(info.split()[1])

    def getSHMALL(self):
        """ find maximum number of shared memory segments """
        cmd = "/sbin/sysctl kernel.shmall"
        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        self.shmall = int(info.split()[2])

    def getSHMMAX(self):
        """ find maximum shared segment size  (in pages)"""
        cmd = "/sbin/sysctl kernel.shmmax"
        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        self.shmmax = int(info.split()[2])

    def getPageSize(self):
        """ find PAGE_SIZE """
        cmd = "getconf PAGE_SIZE"
        info, err = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        self.page_size = int(info.split()[0])

    def getSharedBuffers(self):
        """ find shared_buffers """
        sb = self.memtotal * self.percent    # shared_buffers is % of physical memory

        # the value for 'shmall' should be greater than the value of 'shared_buffers' (in bytes) divided by 'PAGE_SIZE'. 
        if self.shmall > sb/self.page_size :
            self.shared_buffers = int(sb)
        else:
            print "Need to update kernel settings shmmax shmall "

    def make_pgConfgiFile(self):
        """ create new postgresql.conf """

        # make a copy of orig file, read defaults from it
        self.pgconf = self.base + "postgresql.conf"
        dest = self.pgconf + ".orig" 
        #TEMP dest = "/tmp/postgresql.conf.orig" 
        shutil.copy2(self.pgconf, dest)
        fin = open(self.pgconf, "r")
        lines = fin.readlines()
        fin.close()
        defaultLines = self.get_defaultConfig(lines)  

        # create new config lines and write new file
        newLines = self.make_configLines()              
        fout = open(self.pgconf, "w")
        #TEMP fout = open("/tmp/mypg.conf", "w")
        fout.write(defaultLines + newLines)
        fout.close()
        
    def get_defaultConfig(self, lines):
        """ read original postgresql.conf content
            and get all non-comment lines, skip lines to be overwritten """

        comments = ["#", " ", "\t", "\n"]
        keywords = ["listen_addresses", "password_encryption", "shared_buffers", "effective_cache_size",
                    "enable_seqscan", "logging_collector", "log_directory", "log_filename",
                    "log_truncate_on_rotation", "log_rotation_age", "log_rotation_size"]
        content = ""
        for line in lines:
            if line[0] in comments or line.split()[0] in keywords: 
                continue
            else: 
                content += line

        return content

    def make_configLines(self):
        """ create lines to add to pgsql configuration file """
        addLines = ""
        addLines += "listen_addresses = `*'\n"
        addLines += "password_encryption = on\n"
        addLines += "shared_buffers = %d\n" % self.shared_buffers
        addLines += "effective_cache_size = 750MB\n"
        addLines += "enable_seqscan = off\n"
        addLines += "logging_collector = on\n"
        addLines += "log_directory = `pg_log'\n"
        addLines += "log_filename = `postgresql-%Y-%m-%d_%H%M.log'\n"
        addLines += "log_truncate_on_rotation = off\n"
        addLines += "log_rotation_age = 1d\n"
        addLines += "log_rotation_size = 10MB\n"

        return addLines        

    def runTest(self):
        """ test output """
        pprint (self.__dict__)

    def run(self):
        #FIXME uncomment when ready
        #self.make_pgConfgiFile()
        self.runTest()

if __name__ == "__main__":
        app=PGconfig(sys.argv)
        app.run()

