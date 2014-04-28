# ======================
# mOJO MySQL credentials
# ======================
MOJO_MYSQL_USER="mojo"
MOJO_MYSQL_PWD="setMyPass"

# This user needs global DB creation permissions: You can generate it with phpMyAdmin 
# or typing this in your terminal (replace "setYourPass" to fit your needs)
#   $ mysql -u root -p
#   mysql> CREATE USER 'mojo'@'localhost' IDENTIFIED BY 'setYourPass';
#   mysql> GRANT CREATE ON * . * TO 'mojo'@'localhost' IDENTIFIED BY 'setYourPass';
#   mysql> exit;


# =================
# Report your paths
# =================

# Base URL for the service (P.e: http://revistes.uab.cat)
URLBASE="http://magazine.localhost.net"
# Some real live examples:
# URLBASE="http://revistes.uab.cat"
# URLBASE="http://journal-services.com"
# Please, mail me (marc.bria@uab.es) if you use this script.

# Path of the installation folder (Recomended: /home/ojs)
PATHBASE="/home/ojs"

# Path tot the OJS code that will be shared between journals (P.e: $URLBASE/source/versions/current)
# PATHENGINE="$PATHBASE/source/versions/develop"
PATHENGINE="$PATHBASE/source/versions/current"

# Suggestion: Build your own aternative "engines" (I didn't test every version, but it will probably 
# work for OJS 2.4.x branch just descompressing your OJS code in /sources/versions/yourVersion).
# Some examples:
# PATHENGINE="$PATHBASE/source/versions/ojs-2.4.3"
# PATHENGINE="$PATHBASE/source/versions/ojs-3.01a"

# Path of the web root (P.e: $PATHBASE/htdocs)
PATHWEB="$PATHBASE/htdocs"

# Path of the storage folder
PATHDATA="$PATHBASE/webdata"

# Path of the backup folder
PATHBACKUP="$PATHBASE/backup"

# Path for the lock page
PATHFILELOCK="$PATHBASE/source/templates/lock.php"

# Path for the mantainance page
PATHFILEWORK="$PATHBASE/source/templates/work.php"

# Path of the temporal folder (Pe: /tmp/mojo)
PATHTMP="/tmp/mojo"


# ========================
# Some additional settings
# ========================

# mOJO can run in "Command Line" or "Interactive" modes (true o false allowed)
INTERACTIVE="true"

# ToDo: If "File Config" mode it is finally developed INTERACTIVE constant need 
# to change to MODE with values 1 to 3 as follows:
# 1: "Interactive" (default), 2: "Command Line" 3: "FileConfig"

# DB dump of the OJS model ("MOJO_" tags will be replaced)
DBDUMP="demo-neutral/ojs_243-mojo.sql"
#DBDUMP="demo-neutral/pkp.sql"
# Other examples:
# DBDUMP="demo-redi/dumpBaseNew.sql"
# DBDUMP="baseFormacio.sql"

# How to create your own dump? Here you have a very, very fast howto:
# 1) Probably it's a good idea to install a clean OJS
# 2) Set it up with your specific settings (for instance: create a 
#    journalmanager or set the langs of your preference). Use "MOJO_"
#    constants defined below if you like them to be replaced.
# 3) Dump your database (mysqldump it's perfectly for the job).
# 4) Place your new dumpName.sql in your PATHBASE/source/templates folder.
# 5) Change DBDUMP constant to refer your new dumpName.sql file.
# 6) $ mojo create all newjournal

# Even more verbose:
DEBUG=false

# Create files from existing base instalation (accepts true or false)
# Folders files, registry and public will be copied from "base".
# DEPRECATED: Seams more interesting CLONING than working with BASE.
# ToDo: Clone feature will need subtasks to define what to clone 
# (files, code...)
NEWMODEL="true"
# When NEWMODEL is set to false, specify the "base" installation folder.
# BASEMODEL="$PATHWEB/base"


# ===============
# mOJO Variables: 
# ===============

# If the mOJO call don't include them are the values that will be used:
MOJO_ADMIN_SERVICENAME="ReDi - Universitat Autònoma de Barcelona"
MOJO_ADMIN_NAME="Admin"
MOJO_ADMIN_LASTNAME="User"

# JOURNAL context:
MOJO_JOURNAL_DESCRIPTION=""

MOJO_JOURNAL_CONTACT_NAME=""
MOJO_JOURNAL_CONTACT_MAIL=""

MOJO_JOURNAL_SUPPORT_NAME=""
MOJO_JOURNAL_SUPPORT_MAIL=""

# Some of the following constants are reported commented, because mOJO will 
# always overwrite them because they need to be specific for every journal:
MOJO_JOURNAL_TITLE="[You need to change your Journal title]"
MOJO_JOURNAL_ABBR=""
# MOJO_JOURNAL_TAG=""
# MOJO_EDITOR_NAME=""
# MOJO_EDITOR_LASTNAME=""
# MOJO_EDITOR_MAIL=""

# ToDo:
# 1) Show the default value if this is not specificaly set by the mOJO call.
# 2) Accept the default value with "Enter" in the interactive mode. 
# 3) Let user's create new MOJO_* vars here and replace them anyway.
