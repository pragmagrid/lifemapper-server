
# config files templates
TEMPLDIR = "/opt/lifemapper/rocks/etc/" # config files templates directory
SQLDIR = "/opt/lifemapper/rocks/sql/"   # sql files directory
EXT = ".template"                       # template file extension
ROLE = SQLDIR + "roles.sql"             # file for postgres DB users creation
ROLETEMPL = ROLE + EXT                  # template file for postgres users creation

# postgres configuration
UNIX_SOCKET_DIR = "/var/run/postgresql" # unix socket directory
PERCENT_SB = 0.4                        # allocation of memory to shared buffers,  no more than 40%
                                        # see  http://www.postgresql.org/docs/9.1/static/runtime-config-resource.html
PERCENT_ECS = 0.33                      # allocation of memory to effective cache size, 1/3 og physical memory
                                        # see  https://communities.coverity.com/thread/2110
PGCONF = "postgresql.conf"              # config file
CACONF = "pg_hba.conf"                  # client auth file
PGTEMPL = TEMPLDIR + PGCONF + EXT       # template config file
CATEMPL = TEMPLDIR + CACONF + EXT       # template client auth file

# pgbouncer configuration
PGBINI = "/etc/pgbouncer/pgbouncer.ini"     # config file
PGBAUTH = "/etc/pgbouncer/userlist.txt"     # authentication file
PGBTEMPL = TEMPLDIR + "pgbouncer.ini" + EXT # template config file

# user info
USERS_FILE = "/opt/lifemapper/rocks/etc/users"         # users file
USER_LIST = ["sdlapp", "mapuser", "wsuser", "jobuser"] # postgres and pgbouncer users
ADMIN_LIST = ["postgres", "admin"]                     # admin users
MKPASSWD = "mkpasswd -l 12 -d 3 -s 0"   # use to create passwd: 12c lon, 3 digits, no special chars
