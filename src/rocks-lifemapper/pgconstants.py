
# config files templates
TEMPLDIR = "/opt/lifemapper/rocks/etc/"   # config files templates directory
EXT = ".template"                       # template file extension

# postgres configuration
UNIX_SOCKET_DIR = "/var/run/postgresql" # unix socket directory
PERCENT_SB = 0.4                        # allocation of memory to shared buffers
PERCENT_ECS = 0.33                      # allocation of memory to effective cache size
PGCONF = "postgresql.conf"              # config file
CACONF = "pg_hba.conf"                  # client auth file
PGTEMPL = TEMPLDIR + PGCONF + EXT       # template config file
CATEMPL = TEMPLDIR + CACONF + EXT       # template client auth file

# pgbouncer configuration
PGBINI = "/etc/pgbouncer/pgbouncer.ini"     # config file
PGBAUTH = "/etc/pgbouncer/userlist.txt"     # authentication file
PGBTEMPL = TEMPLDIR + "pgbouncer.ini" + EXT # template config file

# user info
USERS_FILE = "/opt/lifemapper/rocks/etc/users"          # users file
USERS_LIST = ["sdlapp", "mapuser", "wsuser", "jobuser"] # postgres and pgbouncer users
