# Path of the service root (P.e: /home/ojs)
PATHBASE="/home/ojs"

# Path of the folder with the current version (P.e: $URLBASE/source/versions/current)
PATHMOTOR="$PATHBASE/source/versions/current"

# Path of the web root (P.e: $PATHBASE/htdocs)
PATHWEB="$PATHBASE/htdocs"

# Path of the storage folder (P.e: $PATHBASE/webdata)
PATHDATA="$PATHBASE/webdata"

# Path of the backup folder (P.e: $PATHBASE/backup)
PATHBACKUP="$PATHBASE/backup"

# Base URL for the service (P.e: http://revistes.uab.cat)
URLBASE="http://journal-services.com"
# URLBASE="http://magazine.localhost.net"

# Path of the temporal folder (Pe: /tmp/mojo)
PATHTMP="/tmp/mojo"

# Create files from existing base instalation (true or false value)
NEWMODEL="true"

# If NEWMODEL set to false set the dir name for the base instalation (P.e. base)
BASEMODEL=""

# DB dump of the OJS model
DBDUMP="ojs_ojs243.sql"
#DBDUMP="dumpBaseNew.sql"

# Build your own aternative bases:
# PATHMOTOR="$PATHBASE/source/versions/ojs-2.4-redi-git-alec"
# PATHMOTOR="$PATHBASE/source/versions/fastrad"

# Working fine with 2.4:
# PATHMOTOR="$PATHBASE/source/versions/trad24"

# Refer your own alternative DB dumps:
# DBDUMP="baseFinal.sql"
# DBDUMP="baseFormacio.sql"

# Even more verbose
DEBUG=false

# Interactive mode true o false values allowed
INTERACTIVE="true"


