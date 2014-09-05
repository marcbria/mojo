#!/bin/bash

# =================================================================================================
#          FILE:    mojo.sh
#
#         USAGE:    ./mojo.sh <action> [<subaction>] <shortname> [<other>]
#
#   DESCRIPTION:    Administers the structure of folders and database for
#                   independent OJS with one preconfigured magazine inside.
#
#    PARAMETERS:
#      <action>: help (h):           Script syntax.
#                list (l):           List all the magazines of the service.
#                   |_ magazines (m):List all the name of all the magazines.
#                   |_ count (c):    Return the total number of magazines.
#                create:             Create the folder structure of an ojs-magazine.
#                   |_ files (cf):   Create the folder structure of an ojs-magazine.
#                   |_ db (cdb):     Create the DB of an ojs-magazine from BASE template.
#                   |_ all (call):   Create a full ojs-magazine from the BASE template.
#                   |_ config:       Create a config file for the magazine specified.
##                  d-createfiles (cf): (deprecated) Create the folder structure of an ojs-magazine.
##                  d-createdb (cdb):   (deprecated) Create the DB of an ojs-magazine from BASE template.
##                  d-createall (call): (deprecated) Create a full ojs-magazine from the BASE template.
#                delete:             Delete the folder structure and/or the DB of an ojs-magazine.
#                   |_ files:        Delete the code & of an ojs-magazine (first backups)
#                   |_ db:           Delete the DB of an specific ojs-magazine.
#                   |_ all:          COMPLETE remove of a ojs-magazine (scripts, files and DB)
#                   |_ config:       Deletes the config file for the magazine specified.
##                  d-deletefiles:      (deprecated) Delete the code & of an ojs-magazine (first backups)
##                  d-deletedb:         (deprecated) Delete the DB of an specific ojs-magazine.
##                  d-deleteall:        (deprecated) COMPLETE remove of a ojs-magazine (scripts, files and DB)
#                backup (bck):       Backup the files (code or-and data) and DB of an specific ojs-magazine.
#                   |_ files:        Backup code & webdata of an specific ojs-magazine.
#                   |_ db:           Backup the DB of an specific ojs-magazine.
#                   |_ all:          COMPLETE backup specific ojs-magazine (scripts, files and DB)
#                   |_ code:         Backup code of an specific ojs-magazine.
#                   |_ data:         Backup webdata of an specific ojs-magazine.
#                   d-backupdb (bdb):   (deprecated) Backup DB of an specific ojs-magazine.
#                   d-backupall (ball): (deprecated) COMPLETE backup of a magazine (scripts, files and DB)
#                restore:            Recover the files (code or-and data) of a formely backup for ojs-magazine.
#                   |_ files:        Recover code & webdata of an specific ojs-magazine.
#                   |_ db:           Recover the DB of an specific ojs-magazine.
#                   |_ all:          COMPLETE recovery of an specific ojs-magazine (scripts, files and DB)
#                   |_ code:         Recover code of an specific ojs-magazine.
#                   |_ data:         Recover webdata of an specific ojs-magazine.
##                  d-restorecode:      (deprecated) Recovers the code of a formely backup for ojs-magazine.
##                  d-restoredb:        (deprecated) Recover a formely DB backup for ojs-magazine.
##                  filldb:             (ToDo) Executes an sql script against the selected ojs-magazine.
#                htaccess:           Recreate the global htaccess file.
#                crontab:            Recreate the global crontab file.
#                r-links:            Recover symlinks for an specific site.
#                link2fold:          Replace a symlink with the folder's content. BE CAREFULL!!
#                setdomain:          Recreate config files to let the magazine respond under a domain.
#                cleancache (cc):    Clean OJS Cache.
#                sethome:            Replace index.php with an alternative page.
#                   |_ open:         Opens the magazine (revcvers OJS original index.php).
#                   |_ lock:         The magazine is Locked.
#                   |_ work:         The magazine is in Mantainance.
#                tools (t):          Call pkp-tools (see your OJS /tools folder)
##                  upgrade:            (ToDo) Replaces [current] links to [new] version and upgrade ojs-DB.
# <shortname>:   Short name (aka. alias) of the magazine to be operated.
#                ToDO: The tag ALL is reserved to operate against every magazine
#                      of the system (Not implemented yet).
#
#       OPTIONS:  ---
#  REQUIREMENTS:  sed, mysql
#     TODO/BUGS:  Parameters are taken in order (ToDo: getopt or getopts)
#                 Parameters can't include quotes.
#                 Warn harmful operations.
#         NOTES:  ---
#        AUTHOR:  Marc Bria (MBR), marc.bria@uab.cat
#       COMPANY:  UAB - SdP - ReDi
#       LICENSE:  GPL 3
#       CREATED:  06/04/11 16:53:15 CEST
#       UPDATED:  05/09/14 12:28:33 PDT
#      REVISION:  0.41
#===============================================================================

# SCRIPT CONFIGURATION: See config.mojo.TEMPLATE

# Elevates the permissions of the script if the operation requieres it
case $1 in
    help|h|list|l|clearcache|cc)
        # Those operations are not harmfull and/or don't require root.
    ;;
    *)
        [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
    ;;
esac

# Get current path (to come back after mOJO)
SCRIPT="`readlink -e $0`"
SCRIPTPATH="`dirname $SCRIPT`"


# LOAD CONFIGURATION FILE ======================================================
# Load global config file (if exists)
if [ -f $SCRIPTPATH/config.mojo ] ; then
    . $SCRIPTPATH/config.mojo
else
    echo "ERROR: Configuration file \"config.mojo\" does NOT exist."
    echo "Modify a copy of the \"config.mojo.TEMPLATE\" example and save it as \"config.mojo\" in your /scripts folder."
    exit 1
fi


#===============================================================================

# Time is useful for logs and backups:
NOW="$(date +"%Y%m%d-%M%S")"


# FUNCTIONS: ===================================================================

# Loads Mojo's config variables.
# Those variables are read (and overwiten) in following order:
# 1) Global config: /home/ojs/script/config.mojo
# 2) Journal config: /home/ojs/webdata/journalTag/config.mojo
# A global config.mojo is mandatory to run mOJO.
# Each journal config define specific config settings.
# If jounal config don't exist and it's not silent mode, config.mojo it's created.
#
# $1: The journal tag (optional)
#
function loadConfig() {

    # FORCE temporary to verbose:
    DEBUG=true

    # Load global config file (if exists)
    if [ -f $SCRIPTPATH/config.mojo ] ; then
        . $SCRIPTPATH/config.mojo
    else
        echo "ERROR: Configuration file \"config.mojo\" does NOT exist."
        echo "Modify a copy of the \"config.mojo.TEMPLATE\" example and save it as \"config.mojo\2 in your /scripts folder."
        exit 1
    fi

    # Load specific config file (if exists)
    if [ "$1" ] ; then
        if [ -f $PATHDATA/$1/config.mojo ] ; then
            . $PATHDATA/$1/config.mojo
        else
            if [ "$2" != "silent" ] ; then 
                echo "--> Warning: Journal's configuration file \"config.mojo\" does NOT exist."
                confirm "--> Do you want to run \"mojo create config $1\" to fix (y/N)? "
                myChoice=$?

                echo "DEBUG myChoice: [$myChoice]"
                if [ "$myChoice" == 1 ] ; then
                    ./mojo.sh create config $1
                else
                    confirm "--> Ignore this warning and continue with your command... (y/N)? " && exit 1
                fi
            # else
                # echo "--> Warning: Journal's configuration file \"config.mojo\" does NOT exist."
                # echo "--> Creating your config..."
                # ./mojo.sh create config "$1"
            fi
        fi
    fi
}


# Creates OJS config file for the specified journal.
#
# $1: The journal tag
# $2: domain name (optional)
#
function createOjsConfig() {

    loadConfig "$1" 

    if [ "$1" ] ; then
        rm -f $PATHWEB/ojs-$1/config.inc.php
        if [ "$2" ] ; then
            echo "-->DEBUG: Creating a domain..."
            # As a domain (Pe: http://myJournal.org)
            sed -e "s!%MOJO_JOURNAL_DOMAIN%!$2!g" "$PATHBASE/source/templates/config.inc.php.Domain.base" > $PATHWEB/ojs-$1/config.inc.php
        else
            echo "-->DEBUG: Creating a sub-domain..."
            # As subdomain (Pe: http://mojo.localhost.com/myJournal)
            sed -e "s!%URLBASE%!$URLBASE!g" "$PATHBASE/source/templates/config.inc.php.base" > $PATHWEB/ojs-$1/config.inc.php
        fi
        sed -i "s!%ROOTDOMAIN%!$ROOTDOMAIN!g" "$PATHWEB/ojs-$1/config.inc.php"
        sed -i "s!%MOJO_JOURNAL_TAG%!$1!g" "$PATHWEB/ojs-$1/config.inc.php"
        sed -i "s!%PATHDATA%!$PATHDATA!g" "$PATHWEB/ojs-$1/config.inc.php"
        sed -i "s!%MOJO_MYSQL_USER%!$MOJO_MYSQL_USER!g" "$PATHWEB/ojs-$1/config.inc.php"
        sed -i "s!%MOJO_MYSQL_PWD%!$MOJO_MYSQL_PWD!g" "$PATHWEB/ojs-$1/config.inc.php"
    else
        echo "ERROR in code: When calling \"createOjsConfig()\" you need to specify, at least, the journal's tag."
        echo "DEVELOPER: Review each createOjsConfig() call. "
        exit 1
    fi
}


function getMyPwd() {
    # Get mySql pwd from each journal's config.mojo
    # ToDo: Probably is better taking it directly from OJS' configs files?

    loadConfig "$1"

    if [ ! "$MOJO_MYSQL_USER" ] ; then
        # If not defined, asks for passwd:
        if [ ! $MOJO_MYSQL_USER ] ; then
            read -s -p "Enter MYSQL user: " MOJO_MYSQL_USER
            echo -e
        fi
        if [ ! $MOJO_MYSQL_PWD ] ; then
            read -s -p "Enter MYSQL password: " MOJO_MYSQL_PWD
            echo -e
        fi
        while ! mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD  -e ";" ; do
            read -s -p "Can't connect, please retry username: " MOJO_MYSQL_USER
            echo -e
            read -s -p "Can't connect, please retry password: " MOJO_MYSQL_PWD
            echo -e
            # echo "Trying with: $MOJO_MYSQL_PWD" >> /home/ojs/scripts/pwd.log
        done
        # echo $MOJO_MYSQL_PWD
    fi
}


function confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            false
        ;;

        *)
            true
        ;;
    esac
}

function folderExist() {
    # echo "logic:  $1"
    # echo "folder: $2"
    # echo "message: [$3]"

    if [ $1 == "NOT" ] || [ $1 == "NO" ] || [ $1 == "false" ] ; then
        # Checking if folder NOT exists
        if [ ! -r "$2" ] ; then
            echo -e "${3:-Folder NOT exists: $2}"
            true
        else
            false
        fi
    else
        # Checking if folder exists
        if [ -r "$2" ] ; then
            echo -e "${3:-Folder exists: $2}"
            true
        else
            false
        fi
    fi
}


# TO BE DEVELOPED (ToDo)
# What about replace Bash params to make code more readable?
# Some calls are now introducing this new approach.
# TO THINK: Parameters are taken in order (and sometimes order is mixed).
# Think if is valueable (ToDo: getopt or getopts)

pAction=""
pJournal=""
pSubAction=""

function showParams() {
    echo ""
    echo "SETPARAMS:   $@"
    echo "pJournal:    $pJournal"
    echo "pAction:     $pAction"
    echo "pSubAction:  $pSubAction"
    echo "pBackupId:   $pBackupId"
    echo "pPreBackup:  $pPreBackup"
    echo "pCheckpoint: $pCheckpoint"
}

function setParams() {
    #op = $1
    #shift $((OPTIND-1))

    case $2 in
        list|l)
            pAction="$1"
            pSubAction="$2"
        ;;

        create)
            # geting params in usual order:
            pJournal="$1"
            pAction="$2"
            pSubAction="$3"
        ;;

        *)
            # geting params in usual order:
            pJournal="$1"
            pAction="$2"
            pSubAction="$3"
            pBackupId="$4"
            pPreBackup="$4"
            pCheckpoint="$4"
        ;;
    esac
    
    showParams
}


#===============================================================================
# Main: ========================================================================
#===============================================================================

# Loads global config:
loadConfig

# Mojo expects to run in it's own script folder:
BACKCD=$(pwd)
cd $PATHBASE/scripts

case $1 in
    setup)
        # Autoinstallation of mOJO:
        echo "NOT IMPLEMENTED YET"
        exit 0

        confirm "You are going to install mOJO in your gnu/linux. Are you sure? [y/N]" && exit 0
        echo "Check requirements & version numbers"
        echo "Ask for config variables..."
        echo "Create user"
        echo "Create folder structure"
        echo "Download OJS code: current"
        echo "Create mysql user: mojo"
        #Add mojo to /usr/bin
        ln -s /home/ojs/scripts/mojo.sh /usr/bin/mojo
    ;;

    test)
        # Testing params: Rethink taking in consideration "list" param... 
        # Delay until getopts/getopt introduction.

        # Testing config.inc.php generation:

        createOjsConfig $2
        cat /home/ojs/htdocs/ojs-$2/config.inc.php
        exit 0

        # Testing new config files:

        echo "Loads global:"
        loadConfig

        echo "Loads journal silent:"
        loadConfig "$2" silent

        echo "Loads journal:"
        loadConfig "$2"

        echo "ends"

        exit 0


        # geting params in usual order:
        pJournal=""
        pAction=""
        pSubAction=""
        pBackupId=""
        pPreBackup=""
        pCheckpoint=""

        setParams "$@"
        echo "DO -> $pAction !!"

        # Testing of snippets

        # getMyPwd
        # echo "MOJO_MYSQL_USER: $MOJO_MYSQL_USER" 
        # echo "MOJO_MYSQL_PWD: $MOJO_MYSQL_PWD" 

        #confirm "You are going to install mOJO in your linux. Are you sure? [y/N]" && exit 0
        #echo "Keep running..."

        # confirm "We will DELETE this file. Are you sure? [y/N]"
        # delete="$?"
        # echo "DELETE: $delete"
        # if [ $delete == 1 ]
        # then 
        #   echo "Delete"
        # else
        #   echo "Keep"
        # fi

        # message="WARNING: Code folder NOT exists for magazine: $3 [$PATHWEB/ojs-$3] \nOperation aborted!!"
        # message="Inside function..."
        # folderExist "NOT" "$PATHWEB/ojs-$2" "$message" && exit 0
        # folderExist "YES" "$PATHWEB/ojs-$2" && exit 0

        # Nor $@ neither $* work fine with spaces so let's do it in the old fashion way:
        # if [ $# -le 2 ]
        # then
        #     ./mojo.sh createdb $2
        # else
        #     if [ $# -le 3 ]
        #     then
        #         ./mojo.sh createdb $2 "$3"
        #     else
        #   if [ $# -le 4 ]
        #         then
        #     ./mojo.sh createdb $2 "$3" "$4"
        #         else
        #             ./magazine.sh createdb $2 "$3" "$4" "$5"
        #         fi
        #     fi
        # fi
        ;;

    help|h)
        # ToDo: Levels of detail.
        # ToDo: Action detailed help.

        echo "Version: 0.31"
        echo "Syntax: ./mojo.sh <action> [<subaction>] <shortname> [<other>]"
        echo ""
        echo "        <action>: help (h):           Script syntax."
        echo "                  list (l):           List all the magazines of the service."
        echo "                     |_ magazines (m):List all the name of all the magazines."
        echo "                     |_ count (c):    Return the total number of magazines."
        echo "                  create:             Create the folder structure of an ojs-magazine."
        echo "                     |_ files (cf):   Create the folder structure of an ojs-magazine."
        echo "                     |_ db (cdb):     Create the DB of an ojs-magazine from BASE template."
        echo "                     |_ all (call):   Create a full ojs-magazine from the BASE template."
        echo "                     |_ config:       Create a config file for the magazine specified."
        # echo "                  d-createfiles (cf):   (deprecated) Create the folder structure of an ojs-magazine."
        # echo "                  d-createdb (cdb):     (deprecated) Create the DB of an ojs-magazine from BASE template."
        # echo "                  d-createall (call):   (deprecated) Create a full ojs-magazine from the BASE template."
        echo "                  delete:             Delete the folder structure and/or the DB of an ojs-magazine."
        echo "                     |_ files:        Delete the code & of an ojs-magazine (first backups)"
        echo "                     |_ db:           Delete the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE remove of a ojs-magazine (scripts, files and DB)"
        echo "                     |_ config:       Delete a config file for the magazine specified."
        # echo "                  d-deletefiles:          Delete the code & of an ojs-magazine (first backups)"
        # echo "                  d-deletedb:             Delete the DB of an specific ojs-magazine."
        # echo "                  d-deleteall:            COMPLETE removes of a ojs-magazine (scripts, files and DB)"
        echo "                  backup (bck):       Backup the files (code or-and data) and DB of an specific ojs-magazine."
        echo "                     |_ files:        Backup code & webdata of an specific ojs-magazine."
        echo "                     |_ db:           Backup the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE backup specific ojs-magazine (scripts, files and DB)"
        echo "                     |_ code:         Backup code of an specific ojs-magazine."
        echo "                     |_ data:         Backup webdata of an specific ojs-magazine."
        # echo "                  d-backupdb (bdb):       Backup DB of an specific ojs-magazine."
        # echo "                  d-backupall (ball):     COMPLETE backup of a magazine (scripts, files and DB)"
        echo "                  restore:            Recover the files (code or-and data) of a formely backup for ojs-magazine."
        echo "                     |_ files:        Recover code & webdata of an specific ojs-magazine."
        echo "                     |_ db:           Recover the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE recovery of an specific ojs-magazine (scripts, files and DB)"
        echo "                     |_ code:         Recover code of an specific ojs-magazine."
        echo "                     |_ data:         Recover webdata of an specific ojs-magazine."
        echo "                  clone:              Clone the files (code or-and data) of an existing ojs-magazine."
        echo "                     |_ files:        Clone code & webdata of an specific ojs-magazine."
        echo "                     |_ db:           Clone the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE clone of an specific ojs-magazine (scripts, files and DB)"
        echo "                     |_ code:         Clone code of an specific ojs-magazine."
        echo "                     |_ data:         Clone webdata of an specific ojs-magazine."
        echo "                  upgrade:            Upgades code and db of an existing ojs-magazine."
        # echo "                  d-restorecode:        (deprecated) Recovers the code of a formely backup for ojs-magazine."
        # echo "                  d-restoredb:          (deprecated) Recover a formely DB backup for ojs-magazine."
        # echo "                  filldb:               (dev) Executes a sql script against the selected ojs-magazine."
        echo "                  set:                (dev) Define the value of a variable (in config.mojo, ojs settings, etc)"
        echo "                     |_ mojovar:      Define the vaule of a config.mojo variable for an specific magazine."
        echo "                  execute:            (dev) Executes a script against the selected ojs-magazine."
        echo "                     |_ sqlparam:     Executes the sql query passed by param."
        # echo "                     |_ sqlfile:      Executes the sql query included in the file."
        # echo "                     |_ phpparam:     Executes the php script passed by param."
        # echo "                     |_ phpfile:      Executes the php script included in the file."
        echo "                  show:               Displays info."
        echo "                     |_ mconfig:      Shows global mojo configuration."
        echo "                     |_ jconfig:      Shows journal mojo configuration."
        # echo "                     |_ oconfig:      (ToDo) Shows journal OJS configuration."
        echo "                  user:               Operations over users."
        echo "                     |_ setpwd:       Sets user's password."
        echo "                  htaccess:           Recreate the global htaccess file."
        echo "                  crontab:            Recreate the global crontab file."
        echo "                  r-links:            Recover symlinks for an specific site."
        echo "                  link2fold:          Replace a symlink with the folder's content. BE CAREFULL!!"
        echo "                  setdomain:          Recreate config files to let the magazine respond under a domain."
        echo "                  cleancache (cc):    Clean OJS Cache."
        echo "                  sethome:            Replace index.php with an alternative page."
        echo "                     |_ open:         Open the magazine (recovers OJS original index.php)."
        echo "                     |_ lock:         The magazine is Locked."
        echo "                     |_ work:         The magazine is in Mantainance."
        echo "                  tools (t):          Call pkp-tools (see your OJS /tools folder)"
        # echo "                    upgrade:            (ToDo) Replaces [current] links to [new] version and upgrade ojs-DB."
        echo "   <shortname>:   Short name (aka. alias) of the magazine to be operated."
        # echo "                  Comment: The tag ALL is reserved to operate against every magazine"
        # echo "                  of the system (Not implemented yet)."
        # echo "          <mail>: (opcional) Email of the main magazine contact"
        # echo "                  (Pe: marc.bria@uab.es)"
        # echo ""
        # echo "Description:  ToDo"
        # echo "Examples:     ToDo"
        # echo "Comments:     Potentialy harmful operations intentionally don't include a short alias."
        # echo "              Use single or double quotes if the param include spaces"
        echo ""
    ;;

    list|l)
        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the sub-action."
            echo "Syntax: ./mojo.sh list [magazines|total]"
            exit 0
        else

            case $2 in
                magazines|m)
                    # ToDo: Exclude non ojs folders from this list (maybe checking if they really are OJS).
                    # ToDo: Extends "list" with params like "list status" (to show active and inactive magazines) or "list version"...

                    if [ $DEBUG == true ] ; then 
                        echo "DEBUG-->  List of magazines:"
                    fi
                    ls -1 $PATHWEB | grep ojs | grep -v "\-base"
                    ;;

                total|t)
                    numMag=$(ls -1 $PATHWEB | grep ojs | grep -v "\-base" | wc -l)

                    echo "================================================================="
                    echo ">>> Number of magazines: $numMag" 
                    echo "================================================================="
                ;;

                *)
                    ./mojo.sh list
                ;;
            esac
        fi
    ;;

    create)
        # ToDo: Ask for confirmation (pe: when overwriting!!)
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        # $2: op (files|db|all)
        # $3: <shortname>
        # $4: last|<backupId

        if [ "$3" = "" ] ; then
            if [ "$2" = "all" ] || [ "$2" = "db" ] ; then
                echo "Error: You must indicate the the magazine's alias."
                echo "Syntax: ./mojo.sh create $2 <shortname> [<contact-mail> [<owner-name> [<magazine-title>]]]"
                exit 0
            else
                echo "Error: You must indicate the sub-action and the magazine's alias."
                echo "Syntax: ./mojo.sh create (files|db|all|config) <shortname> [<magazineValues>]"
                exit 0
            fi
        else

            case $2 in
                files)
                    # Load journal specific config.mojo variables:
                    loadConfig "$2"
                    ./mojo.sh d-createfiles "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;

                db)
                    # Load journal specific config.mojo variables:
                    loadConfig "$2"
                    ./mojo.sh d-createdb "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;

                all)
                    # Load journal specific config.mojo variables:
                    loadConfig "$2"
                    ./mojo.sh create config "$3" 
                    ./mojo.sh d-createall "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;

                code)
                    echo "NOT IMPLEMENTED YET: You can create code structure with ./mojo.sh d-createfiles <shortname>"
                    exit 0
                ;;

                data)
                    echo "NOT IMPLEMENTED YET: You can create data structure with ./mojo.sh d-createfiles <shortname>"
                    exit 0

                    # DEBUG: echo "create data with: $@"
                    # Checking if data folder exists!!
                    message="WARNING: Data folder exists for magazine: $3 [$PATHDATA/$3] \nOperation aborted!!"
                    folderExist "YES" "$PATHDATA/$3" "$message" && exit 0
                ;;

                config)
                    # Load global config.mojo variables:
                    loadConfig

                    if [ -e "$PATHDATA/$3/config.mojo" ] ; then 
                        echo "Warining: Config file exists for journal $3. You need to remove it before creating."
                        echo "Try with \"mojo delete config $3\""
                        exit 1
                    else
                        echo "Creating an specific config file for journal $3..."
                        mkdir -p $PATHDATA/$3
                        cp "$PATHBASE/source/templates/config.mojo.base" $PATHDATA/$3/config.mojo 
                        chown ojs:ojs $PATHDATA/$3/config.mojo
                        chmod 700 $PATHDATA/$3/config.mojo

                        # printf "\n\n# Specific variables for journal [$3] \n\n" >> $PATHDATA/$3/config.mojo
                        # echo "" >> $PATHDATA/$3/config.mojo

                        # TAG is not a variable and should not be changed.
                        echo "MOJO_JOURNAL_TAG=\"$3\"" >> $PATHDATA/$3/config.mojo
                        MOJO_JOURNAL_TAG=$3

                        #ALL VARS: ( "MOJO_MYSQL_USER" "MOJO_MYSQL_PWD" "URLBASE" "PATHBASE" "PATHVERSION" "OJSENGINE" "PATHWEB" "PATHDATA" "PATHBACKUP" "PATHFILELOCK" "PATHFILEWORK" "PATHTMP" "INTERACTIVE" "DBDUMP" "DEBUG" "NEWMODEL" "MOJO_ADMIN_SERVICENAME" "MOJO_ADMIN_NAME" "MOJO_ADMIN_LASTNAME" "MOJO_JOURNAL_DESCRIPTION" "MOJO_JOURNAL_CONTACT_NAME" "MOJO_JOURNAL_CONTACT_MAIL" "MOJO_JOURNAL_SUPPORT_NAME" "MOJO_JOURNAL_SUPPORT_MAIL" "MOJO_JOURNAL_TITLE" "MOJO_JOURNAL_ABBR" )

                        mojoVars=( "OJSENGINE" \
                            "DBDUMP" \
                            "MOJO_JOURNAL_DESCRIPTION" \
                            "MOJO_JOURNAL_CONTACT_NAME" \
                            "MOJO_JOURNAL_CONTACT_MAIL" \
                            "MOJO_JOURNAL_SUPPORT_NAME" \
                            "MOJO_JOURNAL_SUPPORT_MAIL" \
                            "MOJO_JOURNAL_TITLE" \
                            "MOJO_JOURNAL_ABBR" \
                            "MOJO_JOURNAL_DOMAIN"
                            # "MOJO_EDITOR_MAIL" \
                            # "MOJO_EDITOR_NAME" \
                            # "MOJO_EDITOR_LASTNAME" \
                            # "MOJO_JOURNAL_TITLE" \
                            # "MOJO_ADMIN_SERVICENAME" \
                            # "MOJO_ADMIN_NAME" \
                            # "MOJO_ADMIN_LASTNAME" \
                            # "MOJO_CONTACT_NAME" \
                            # "MOJO_CONTACT_MAIL"
                        )


                        # IMPORTANT: It all only will work in interactive mode. 
                        # Commandline version still need to be implemented.
                        for i in "${mojoVars[@]}"
                        do
                            # EXTRA VARIABLES: When "interactive mode" extra variables are requested.
                            if [ $INTERACTIVE = "true" ] ; then
                                eval "defaultVar=\$$i"
                                read -p "Variable $i (default: $defaultVar): " userVar
                                if [ "$userVar" ] ; then
                                    echo "$i=\"$userVar\"" >> $PATHDATA/$3/config.mojo
                                    if [ $DEBUG == true ] ; then 
                                        echo "DEBUG--> [$i=\"$userVar\"]" 
                                    fi
                                else
                                    echo "$i=\"$defaultVar\"" >> $PATHDATA/$3/config.mojo
                                    if [ $DEBUG == true ] ; then 
                                        echo "DEBUG--> [$i=\"$defaultVar\"]"
                                    fi
                                fi
                                # sed -i "s/$i/$configVar/g" $PATHTMP/$2-fill.sql
                            fi
                        done
                        exit 0
                    fi
                ;;

                *)
                    # Show syntax:
                    ./mojo.sh create
                    ;;
            esac
        fi
    ;;

    d-createfiles)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-createfiles <shortname>"
            exit 0
        else
            echo "--> Creating the folder structure for magazine: $2"

            # Load journal specific config.mojo variables:
            loadConfig "$2"

            # Checking if data&code folders exists:
            message="WARNING: Code folder exists for magazine: $2 [$PATHWEB/ojs-$2] \nOperation aborted!!"
            folderExist "YES" "$PATHWEB/ojs-$2" "$message" && exit 0
            message="WARNING: Data folder exists for magazine: $2 [$PATHDATA/$2] \nOperation aborted!!"
            folderExist "YES" "$PATHDATA/$2/journals" "$message" && exit 0

            # Building the folder structure of the new magazine
            if [ $NEWMODEL == true ] ; then 
                # An independent model (clean version instead of base copy)
                mkdir -p "$PATHDATA/$2/files"                                       # Creates the data folder
                mkdir -p "$PATHWEB/ojs-$2/public"                                   # ... the public folder 
                cp -a $PATHVERSIONS/$OJSENGINE/registry "$PATHDATA/$2/registry"     # And copies the registry.
            else
                if [ -n $BASEMODEL ] ; then
                    cp -a "$PATHDATA/$BASEMODEL/files" "$PATHDATA/$2"    # From the BASE model.
                    cp -a "$PATHDATA/$BASEMODEL/registry" "$PATHDATA/$2"
                    cp -a "$PATHWEB/ojs-$BASEMODEL/public" "$PATHWEB/ojs-$2"          # Some predefined public files (pe: logos, banners).
                else
                    echo "ERROR: Base model dir name not set, check the config file"
                    exit 0
                fi
            fi

            mkdir -p "$PATHWEB/ojs-$2"                                  # Crates the web folder

            cp -a "$PATHVERSIONS/$OJSENGINE/index.php" "$PATHWEB/ojs-$2/index.php"    # Comment: A symlink won't work.


            # Building the structure for NON SHARED folders:
            mkdir -p "$PATHWEB/ojs-$2/cache/t_cache"
            mkdir -p "$PATHWEB/ojs-$2/cache/t_compile"
            mkdir -p "$PATHWEB/ojs-$2/cache/t_config"
            mkdir -p "$PATHWEB/ojs-$2/cache/_db"

            # Building the SHARED folders (same files between ALL OJS instalations):
            SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

            for x in ${SHARED}
            do
                ln -s -f "$PATHVERSIONS/$OJSENGINE/${x}" "$PATHWEB/ojs-$2"
            done

            # Generates the magazine's OJS config file.
            createOjsConfig "$2" "$3"

            # Setting permissions:
            chown -R ojs:www-data "$PATHDATA/$2"
            chown -R ojs:www-data "$PATHWEB/ojs-$2"
            chmod -R 774 "$PATHDATA/$2"
            chmod -R 775 "$PATHWEB/ojs-$2"

            # Creates the htaccess chunk for the magazine (RESTful urls) and recreates the global htaccess.
            ./mojo.sh htaccess $2
            ./mojo.sh htaccess

            # Creates the crontab chunk for the magazine and recreates the global cronMagazine.sh script.
            ./mojo.sh crontab $2
            ./mojo.sh crontab

        fi
    ;;

    d-createdb)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-createdb <shortname>"
            exit 0
        else
            echo "--> Creating the OJS-DB named: ojs_$2"

            # Load journal specific config.mojo variables:
            loadConfig "$2"

            mkdir -p "$PATHTMP"

            # Creates the DB named "ojs_MOJO_JOURNAL_TAG"
            sed -e "s/%MOJO_JOURNAL_TAG%/$2/g" "$PATHBASE/source/templates/createDB.sql" > $PATHTMP/$2-create.sql
            sed -i "s/%MOJO_MYSQL_USER%/$MOJO_MYSQL_USER/g" $PATHTMP/$2-create.sql

            if [ $DEBUG == true ] ; then 
                echo "DEBUG--> sed -i \"s/%MOJO_MYSQL_USER%/$MOJO_MYSQL_USER/g\" $PATHTMP/$2-create.sql"
                echo "DEBUG--> sed -e \"s/%MOJO_JOURNAL_TAG%/$2/g\" \"$PATHBASE/source/templates/createDB.sql\" > $PATHTMP/$2-create.sql"
            fi

            # Create not replaced fill.sql file
            cp "$PATHBASE/source/templates/$DBDUMP" $PATHTMP/$2-fill.sql
            
            # Replaces MOJO_JOURNAL_TAG tag in the BASE dump:
            if grep -q "MOJO_JOURNAL_TAG" $PATHBASE/source/templates/$DBDUMP ; then
                sed -i "s/MOJO_JOURNAL_TAG/$2/g" $PATHTMP/$2-fill.sql
            else
                echo "WARNING: MOJO_JOURNAL_TAG to replace not found, first journal path will be replaced for $2 "
                echo "UPDATE ojs_$2.journals SET path = '$2' WHERE journals.journal_id = 1;" >> $PATHTMP/$2-tag.sql
            fi

            mojoDbVars=( "MOJO_JOURNAL_DESCRIPTION" \
                "MOJO_JOURNAL_CONTACT_NAME" \
                "MOJO_JOURNAL_CONTACT_MAIL" \
                "MOJO_JOURNAL_SUPPORT_NAME" \
                "MOJO_JOURNAL_SUPPORT_MAIL" \
                "MOJO_JOURNAL_TITLE" \
                "MOJO_JOURNAL_ABBR" \
                "MOJO_JOURNAL_DOMAIN"
                # "MOJO_EDITOR_MAIL" \
                # "MOJO_EDITOR_NAME" \
                # "MOJO_EDITOR_LASTNAME" \
                # "MOJO_JOURNAL_TITLE" \
                ## "MOJO_ADMIN_SERVICENAME" \
                ## "MOJO_ADMIN_SERVICEMAIL" \
                # "MOJO_ADMIN_NAME" \
                # "MOJO_ADMIN_LASTNAME" \
                # "MOJO_CONTACT_NAME" \
                # "MOJO_CONTACT_MAIL"
            )


            for i in "${mojoDbVars[@]}"
            do
                # EXTRA VARIABLES: When "interactive mode" extra variables are requested.
                if [ $INTERACTIVE = "true" ] ; then
                    eval "defaultVar=\$$i"
                    userVar=$defaultVar

                    if [ "$defaultVar" ] ; then
                        if [ $DEBUG == true ] ; then 
                            echo "DEBUG--> Ignoring variable formely defined in config.mojo as [$i = \"$defaultVar\"]"
                        fi
                    else
                        echo "The variable $i is not defined in your journal's config. Do you want to set it now?"
                        read -p "Variable $i (default: $defaultVar): " userVar

                        # Save the value in journal's config.mojo
                        echo "$i=\"$userVar\"" >> $PATHDATA/$2/config.mojo

                        if [ $DEBUG == true ] ; then 
                            echo "DEBUG--> Setting variable as [$i = \"$userVar\"] in journal's config.mojo" 
                        fi
                    fi

                    # Template replacement:
                    # ToDo: Special chars replacement.
                    sed -i "s/$i/$userVar/g" $PATHTMP/$2-fill.sql

                fi
            done

            cat $PATHTMP/$2-fill.sql >> $PATHTMP/$2-create.sql
            if [ -e $PATHTMP/$2-tag.sql ] ; then
              cat $PATHTMP/$2-tag.sql >> $PATHTMP/$2-create.sql
            fi

            # Get MySql root pwd:
            # MOJO_MYSQL_PWD=$(getMyPwd)
            # Not required anymore if we use journal configs.
            # getMyPwd $2

            # Let's execute this query:
            /usr/bin/mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD < $PATHTMP/$2-create.sql
            if [ $DEBUG == true ] ; then 
                echo "DEBUG--> /usr/bin/mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD < $PATHTMP/$2-create.sql"
            fi

            echo "Magazine's DB was created."
        fi
    ;;

    d-createall)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-createall <shortname>"
            exit 0
        else
            echo "CREATING MAGAZINE: $2"

            ./mojo.sh d-createfiles $2
            ./mojo.sh d-createdb $2 "$3" "$4" "$5"

            echo ""
            echo "================================================================="
            echo ">>> New OJS system at $URLBASE/ojs-$2"
            echo ">>> New magazine avaliable at $URLBASE/$2"
            echo "================================================================="
        fi

        #else
        #    echo "Error: Magazine alias is required."
        #    echo "Try with. ./mojo.sh MagazineShortName"
        #fi
    ;;

    delete)
        # ToDo: Ask for confirmation
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        # $2: op (files|db|all)
        # $3: <shortname>
        # $4: last|<backupId

        if [ "$3" = "" ] ; then
            if [ "$2" = "all" ] || [ "$2" = "db" ] ; then
                echo "Error: You must indicate the the magazine's alias."
                echo "Syntax: ./mojo.sh delete $2 <shortname> [<forceDelete> [<doBackup>]]"
                echo "Example: mojo delete all testjournal"
                exit 0
            else
                echo "Error: You must indicate the sub-action and the magazine's alias."
                echo "Syntax: ./mojo.sh delete (files|db|all|backup) <shortname> [<forceDelete> [<doBackup>]]"
                echo "Example: mojo delete all testjournal"
                exit 0
            fi
        else

            case $2 in
                files)
                    # Load journal specific config.mojo variables:
                    loadConfig "$3" silent
                    ./mojo.sh d-deletefiles "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;

                db)
                    ./mojo.sh d-deletedb "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;

                all)
                    ./mojo.sh d-deleteall "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;

                code)
                    echo "NOT IMPLEMENTED YET: You can create code structure with ./mojo.sh d-createfiles <shortname>"
                    exit 0
                ;;

                data)
                    echo "NOT IMPLEMENTED YET: You can create data structure with ./mojo.sh d-createfiles <shortname>"
                    exit 0

                    # DEBUG: echo "create data with: $@"
                    # Checking if data folder exists!!
                    message="WARNING: Data folder exists for magazine: $3 [$PATHDATA/$3] \nOperation aborted!!"
                    folderExist "YES" "$PATHDATA/$3/journal" "$message" && exit 0
                ;;

                backup)
                    if [ -e "$PATHBACKUP/all/$3" ] ; then 
                        confirm "Remove [$PATHBACKUP/dbs/$3] (y/N)" || rm "$PATHBACKUP/dbs/$3" -Rf > /dev/null 2>&1
                        confirm "Remove [$PATHBACKUP/data/$3] (y/N)" || rm "$PATHBACKUP/data/$3" -Rf > /dev/null 2>&1
                        confirm "Remove [$PATHBACKUP/code/$3] (y/N)" || rm "$PATHBACKUP/code/$3" -Rf > /dev/null 2>&1
                        confirm "Remove [$PATHBACKUP/all/$3/*] (y/N)" || rm "$PATHBACKUP/all/$3/*" -Rf > /dev/null 2>&1
                        confirm "Remove [$PATHBACKUP/all/$3] (y/N)" || rm "$PATHBACKUP/all/$3" -Rf > /dev/null 2>&1
                    else
                        echo "No backup files for journal [$3]"
                    fi
                ;;

                config)
                    if [ -e "$PATHDATA/$3/config.mojo" ] ; then 
                        rm "$PATHDATA/$3/config.mojo"
                    else
                        echo "Warining: Journal [$3] don't include a config.mojo file. You need to create it."
                        echo "Try with \"mojo create config $3\""
                        exit 0
                    fi
                ;;

                *)
                    # Show syntax:
                    ./mojo.sh delete
                    ;;
            esac
        fi
    ;;

    d-deletefiles)
        # ToDo: Protect "base" files and BD
        # ToDo: Ask for confirmation (meanwhile dbpwd request does the job).
        # ToDo: Option to delete without confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-deletefiles <shortname> [<forceDelete>]"
            exit 0
        else
            echo "CODE & DATA of magazine [ojs_$2] are going to be REMOVED."

            # Load journal specific config.mojo variables:
            loadConfig "$2" silent

            forceDelete=false
            if [ "$3" ] ; then forceDelete="$3" ; fi

            if [ "$forceDelete" == false ] || [ "$forceDelete" == 0 ] ; then
                confirm "--> Are you sure? [y/N]" && exit 0
            fi            

            doBackup=true
            if [ "$4" ] ; then doBackup="$4" ; fi

            if [ "$doBackup" == 0 ] || [ "$doBackup" == false ] ; then
                echo "--> Backup DB before deleting (without checkpoint)."
                ./mojo.sh backup files $2
            fi

            rm -Rf $PATHWEB/ojs-$2
            rm -f $PATHTMP/ojs-$2.sql
            rm -Rf $PATHDATA/$2

            # echo "----> htaccess renewed..."
            ./mojo.sh htaccess
            # echo "----> crontab renewed..."
            ./mojo.sh crontab

            echo "Files of magazine $2 are DELETED now!"
        fi
    ;;

    d-deletedb)
        # ToDo: Ask for confirmation (meanwhile dbpwd request does the job).
        # ToDo: Backup before delete?
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-deletedb <shortname> [<forceDelete>]"
            exit 0
        else
            echo "DB of magazine [ojs_$2] is going to be REMOVED."

            # Load journal specific config.mojo variables:
            loadConfig "$2" silent

            forceDelete=false
            if [ "$3" ] ; then forceDelete="$3" ; fi

            if [ "$forceDelete" == false ] || [ "$forceDelete" == 0 ] ; then
                confirm "--> Are you sure? [y/N]" && exit 0
            fi            

            doBackup=true
            if [ "$4" ] ; then doBackup="$4" ; fi

            if [ "$doBackup" == 0 ] || [ "$doBackup" == false ] ; then
                echo "--> Backup DB before deleting (without checkpoint)."
                ./mojo.sh backup db "$2"
            fi

            mkdir -p "$PATHTMP" 

            # Delete BD with "ojs_MOJO_JOURNAL_TAG"
            sed -e "s/%MOJO_JOURNAL_TAG%/$2/g" "$PATHBASE/source/templates/deleteDB.sql" > $PATHTMP/$2-delete.sql

            # Get MySql root pwd:
            # MOJO_MYSQL_PWD=$(getMyPwd)
            # echo ""
            # getMyPwd $2

            /usr/bin/mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD < $PATHTMP/$2-delete.sql
            echo "--> Magazine's $2 DB is DELETED now!"
        fi
    ;;

    d-deleteall)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-deleteall <shortname> [<forceDelete> [<doBackup>]]"
            exit 0
        else
            echo "Magazine [ojs_$2] is going to be FULL REMOVED (code, data and DB)"

            # Load journal specific config.mojo variables:
            loadConfig

            forceDelete=false
            if [ "$3" ] ; then forceDelete="$3" ; fi

            if [ "$forceDelete" == false ] || [ "$forceDelete" == 0 ] ; then
                confirm "--> Are you sure? [y/N]" && exit 0
            fi            


            doBackup=true
            if [ "$4" ] ; then doBackup="$4" ; fi

            # echo "----> DB to remove..."
            ./mojo.sh d-deletedb $2 true "$doBackup"

            # echo "----> Files to remove..."
            ./mojo.sh d-deletefiles $2 false "$doBackup"

            echo ""
            echo "================================================================="
            echo ">>> Magazine's $2 is FULL DELETED now! "
            echo "================================================================="
        fi
    ;;

    backup|bck)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.
        # ToDo: I have doubts some doubts about backups: folder structure? git based? ninjabackup? ...

        # $2: op (code|data|files|all)
        # $3: <shortname>
        # $4: <isCheckpoint>

        if [ "$3" = "" ] ; then
            echo "Error: You must indicate the sub-action and the magazine's alias."
            echo "Syntax: ./mojo.sh backup (code|data|files|db|all) <shortname> [<isCheckPoint>]"
            exit 0
        else

            # Load journal specific config.mojo variables:
            loadConfig "$3"

            mkdir -p "$PATHTMP"
            mkdir -p "$PATHBACKUP/all/$3"
            mkdir -p "$PATHBACKUP/code/$3"
            mkdir -p "$PATHBACKUP/data/$3"

            case $2 in
                code)
                    echo "Running CODE backup for magazine: $3"

                    # Checking if code folder exist:
                    message="WARNING: Code folder NOT exists for magazine: $3 [$PATHWEB/ojs-$3] \nOperation aborted!!"
                    folderExist "NOT" "$PATHWEB/ojs-$3" "$message" && exit 0

                    tar cvzf "$PATHBACKUP/code/$3/$NOW.tgz" -C $PATHWEB "ojs-$3" >> $PATHTMP/$3.log

                    # Magazines' code backups are stored in a different folder an symlinked.
                    ln -s -f $PATHBACKUP/code/$3/$NOW.tgz $PATHBACKUP/all/$3/$NOW-code.tgz

                    # Is this backup a checkpoint?
                    if [ $# -eq 4 ] ; then
                        if [ $4 == "true" ] || [ $4 == 1 ] ; then
                            echo "--> This backup is a CHECKPOINT: will be considered the last code version by mojo."
                            ln -s -f $PATHBACKUP/code/$3/$NOW.tgz $PATHBACKUP/all/$3/last-code.tgz
                        fi
                    fi

                    echo "--> Destination folder is: $PATHBACKUP/code/$3"
                    echo "Backup for CODE is done!"
                ;;
                    
                data)
                    echo "Running DATA backup for magazine: $3"

                    # Checking if data folder exist:
                    message="WARNING: Data folder NOT exists for magazine: $3 [$PATHDATA/$3] \nOperation aborted!!"
                    folderExist "NOT" "$PATHDATA/$3" "$message" && exit 0

                    tar cvzf "$PATHBACKUP/data/$3/$NOW.tgz" -C $PATHDATA "$3" >> $PATHTMP/$3.log
                    # echo "tar cvzf $PATHBACKUP/data/$3/$NOW.tgz -C $PATHDATA $3"

                    # Magazines' data backups are stored in a different folders an symlinked.
                    ln -s -f $PATHBACKUP/data/$3/$NOW.tgz $PATHBACKUP/all/$3/$NOW-data.tgz

                    # Is this backup a checkpoint?
                    if [ $# -eq 4 ] ; then
                        if [ $4 == "true" ] || [ $4 == 1 ] ; then
                            echo "--> This backup is a CHECKPOINT: will be considered the last data version by mojo."
                            ln -s -f $PATHBACKUP/data/$3/$NOW.tgz $PATHBACKUP/all/$3/last-data.tgz
                        fi
                    fi

                    echo "--> Destination folder is: $PATHBACKUP/data/$3"
                    echo "Backup for DATA is done!"
                ;;

                files)
                    echo "Running CODE & DATA backup for magazine: $3"

                    # Checking if data&web folders exists!!
                    message="WARNING: Code folder NOT exists for magazine: $3 [$PATHWEB/ojs-$3] \nOperation aborted!!"
                    folderExist "NOT" "$PATHWEB/ojs-$3" "$message" && exit 0
                    message="WARNING: Data folder NOT exists for magazine: $3 [$PATHDATA/$3] \nOperation aborted!!"
                    folderExist "NOT" "$PATHDATA/$3" "$message" && exit 0


                    tar cvzf "$PATHBACKUP/code/$3/$NOW.tgz" -C $PATHWEB "ojs-$3" >> $PATHTMP/$3.log
                    tar cvzf "$PATHBACKUP/data/$3/$NOW.tgz" -C $PATHDATA "$3" >> $PATHTMP/$3.log

                    # Magazines' code & data backups are stored in a different folder an symlinked.
                    ln -s -f $PATHBACKUP/code/$3/$NOW.tgz $PATHBACKUP/all/$3/$NOW-code.tgz
                    ln -s -f $PATHBACKUP/data/$3/$NOW.tgz $PATHBACKUP/all/$3/$NOW-data.tgz

                    # Is this backup a checkpoint?
                    if [ $# -eq 4 ] ; then
                        if [ $4 == "true" ] || [ $4 == 1 ] ; then
                            echo "--> This backup is a CHECKPOINT: will be considered the last code & data version by mojo."
                            ln -s -f $PATHBACKUP/code/$3/$NOW.tgz $PATHBACKUP/all/$3/last-code.tgz
                            ln -s -f $PATHBACKUP/data/$3/$NOW.tgz $PATHBACKUP/all/$3/last-data.tgz
                        fi
                    fi

                    echo "--> Destination folder is: $PATHBACKUP/all/$3"
                    echo "Backup for CODE & DATA is done!"
                ;;

                db)
                    ./mojo.sh d-backupdb $3 $4
                ;;

                all)
                    ./mojo.sh d-backupall $3 $4
                ;;

                *)
                    # Show syntax:
                    ./mojo.sh backup
                ;;
            esac
        fi
    ;;

    d-backupdb|bdb)
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh d-backupdb <shortname> [<isCheckpoint>]"
            echo "To get a list of every magazine: ./mojo.sh list"
            exit 0
        else

            # Load journal specific config.mojo variables:
            loadConfig "$2"

            # Get MySql root pwd:
            # MOJO_MYSQL_PWD=$(getMyPwd)
            # echo ""
            # getMyPwd $2

            mkdir -p "$PATHBACKUP/dbs/$2"
            mkdir -p "$PATHBACKUP/all/$2"
            mkdir -p "$PATHTMP"

            # echo "DEBUG: mysqldump -uroot --password=$MOJO_MYSQL_PWD ojs_$2 --default-character-set=utf8 > $PATHTMP/ojs-$2.sql"
            mysqldump -u$MOJO_MYSQL_USER --password=$MOJO_MYSQL_PWD ojs_$2 --default-character-set=utf8 > $PATHTMP/ojs-$2.sql

            # echo "DEBUG: tar cvzf $PATHBACKUP/dbs/$2/$NOW.tgz -C $PATHTMP ojs-$2.sql >> $PATHTMP/$2.log"
            tar cvzf "$PATHBACKUP/dbs/$2/$NOW.tgz" -C $PATHTMP "ojs-$2.sql" >> $PATHTMP/$2.log

            # Magazines' DB backups are stored in a different folder an symlinked.
            ln -s -f $PATHBACKUP/dbs/$2/$NOW.tgz $PATHBACKUP/all/$2/$NOW-db.tgz

            # Is this backup is a checkpoint?
            if [ $# -eq 3 ] ; then
                if [ $3 == "true" ] || [ $3 == 1 ] ; then
                    echo "--> This backup is a CHECKPOINT: will be considered the last DB version by mojo."
                    ln -s -f $PATHBACKUP/dbs/$2/$NOW.tgz $PATHBACKUP/all/$2/last-db.tgz
                fi
            fi

            echo "--> Destination folder is: $PATHBACKUP/dbs/$2"
            echo "Backup for DB is done!"
        fi
    ;;

    d-backupall|ball)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            #echo "Backups a full magazine (db, code and docs)."
            echo "Error:  Wrong number of parameters"
            echo "Syntax: ./mojo.sh d-backupall <shortname> [<isCheckpoint]"
            exit 0
        else
            echo "Running FULL backup of magazine: $2"

            # Load journal specific config.mojo variables:
            loadConfig "$2"

            # Checking if data&web folders exists!!
            message="WARNING: Code folder NOT exists for magazine: $2 [$PATHWEB/ojs-$2] \nOperation aborted!!"
            folderExist "NOT" "$PATHWEB/ojs-$2" "$message" && exit 0
            message="WARNING: Data folder NOT exists for magazine: $2 [$PATHDATA/$2] \nOperation aborted!!"
            folderExist "NOT" "$PATHDATA/$2" "$message" && exit 0

            # Ensure backup folder structure is fine:
            mkdir -p "$PATHTMP"
            mkdir -p "$PATHBACKUP/all/$2"
            mkdir -p "$PATHBACKUP/code/$2"
            mkdir -p "$PATHBACKUP/dbs/$2"
            mkdir -p "$PATHBACKUP/data/$2"

            # Get MySql root pwd:
            # MOJO_MYSQL_PWD=$(getMyPwd)
            # echo ""
            # getMyPwd $2

            mysqldump -u $MOJO_MYSQL_USER --password=$MOJO_MYSQL_PWD ojs_$2 --default-character-set=utf8 > $PATHTMP/ojs-$2.sql

            tar cvzf "$PATHBACKUP/code/$2/$NOW.tgz" -C $PATHWEB "ojs-$2" >> $PATHTMP/$2.log
            tar cvzf "$PATHBACKUP/dbs/$2/$NOW.tgz" -C $PATHTMP "ojs-$2.sql" >> $PATHTMP/$2.log
            tar cvzf "$PATHBACKUP/data/$2/$NOW.tgz" -C $PATHDATA "$2" >> $PATHTMP/$2.log
            rm -f $PATHTMP/ojs-$2.sql

            # Magazines' DB dumps and CODE are stored in a different folder an symlinked, to facilitate additinal backups.
            ln -s -f $PATHBACKUP/code/$2/$NOW.tgz $PATHBACKUP/all/$2/$NOW-code.tgz
            ln -s -f $PATHBACKUP/dbs/$2/$NOW.tgz $PATHBACKUP/all/$2/$NOW-db.tgz
            ln -s -f $PATHBACKUP/data/$2/$NOW.tgz $PATHBACKUP/all/$2/$NOW-data.tgz

            # Is this backup the "last" backup?
            if [ $# -eq 3 ] ; then
                if [ $3 == "true" ] || [ $3 == 1 ] ; then
                    echo "--> This backup is a CHECKPOINT: will be considered the last version to be restored by mojo"
                    # Define last backups:
                    ln -s -f $PATHBACKUP/code/$2/$NOW.tgz $PATHBACKUP/all/$2/last-code.tgz
                    ln -s -f $PATHBACKUP/dbs/$2/$NOW.tgz   $PATHBACKUP/all/$2/last-db.tgz
                    ln -s -f $PATHBACKUP/data/$2/$NOW.tgz $PATHBACKUP/all/$2/last-data.tgz
                fi
            fi

            echo ""
            echo "================================================================="
            echo "--> Destination folder is: $PATHBACKUP/all/$2"
            echo ">>> Magazine's $2 is FULL BACKUP now! "
            echo "================================================================="
        fi
    ;;

    restore)
        # ToDo: Ask for confirmation (pe: when overwriting!!)
        # ToDo: Argument's validation.
        # ToDo: Error checking.
        # ToDo: Restore from full path.

        # $2: op (code|data|all)
        # $3: <shortname>
        # $4: last|<backupId>
        # $5: preBackup

        if [ "$4" = "" ] ; then
            echo "Error: You must indicate the sub-action, the magazine's alias and the backup to recover"
            echo "Syntax: ./mojo.sh restore (code|files|db|all) <shortname> (last|<backupId>)"
            echo "sub-actions:"
            echo "    * files:        Recover code & webdata of an specific ojs-magazine."
            echo "    * db:           Recover the DB of an specific ojs-magazine."
            echo "    * all:          COMPLETE recovery of an specific ojs-magazine (scripts, files and DB)"
            echo "    * code:         Recover code of an specific ojs-magazine."
            echo "    * data:         Recover webdata of an specific ojs-magazine."
            exit 0
        else
            # Load journal specific config.mojo variables:
            loadConfig "$3"

            # Checking the backup file.
            bckType=$2
            if [ $2 == "files" ] || [ $2 == "all" ] ; then bckType="code" ; fi
                if [ $3 != "last" ] && [ ! -r "$PATHBACKUP/all/$3/$4-$bckType.tgz" ] ; then
                    echo "Unable to read the Backup file: $PATHBACKUP/all/$3/$4-$bckType.tgz"
                    exit 0
                fi

            # Is pre-backup required?
            if [ $# -eq 5 ] && [[ $5 == "true" || $5 == 1 ]] ; then
                # Notice this backup it's for additional safty, and don't make sense to be a checkpoint:
                ./mojo.sh backup $2 $3 false
            fi

            case $2 in
                code)
                    if [ -r "$PATHWEB/ojs-$3" ] ; then
                        confirm "CODE folder ojs-$3 exists. Do you want to delete it before restore? [y/N]"
                        delete="$?"
                        if [ $delete == 1 ] ; then
                            rm -Rf $PATHWEB/ojs-$3
                            echo "Former code folder was REMOVED."
                            confirm "Do you want to restore your backup now? [y/N]" && exit 0
                            tar xzf $PATHBACKUP/all/$3/$4-code.tgz -C $PATHWEB
                        else
                            confirm "Do you want to restore your backup over the existing folder? [y/N]" && exit 0
                            tar xzf $PATHBACKUP/all/$3/$4-code.tgz -C $PATHWEB
                        fi
                    else
                        tar xzf $PATHBACKUP/all/$3/$4-code.tgz -C $PATHWEB
                    fi

                    ./mojo.sh htaccess
                    ./mojo.sh crontab

                    echo "CODE was RESTORED from backup: $4"
                ;;

                data)
                    if [ -r "$PATHDATA/$3" ] ; then
                        # confirm "DATA folder $3 exists. Do you want to delete it before restore? [y/N]"
                        # delete="$?"
                        # if [ $delete == 1 ]
                        confirm "DATA folder $3 exists. Do you want to delete it before restore? [y/N]"
                        delete="$?"
                        if [ $delete == 1 ] ; then
                            # Remove PATHDATA content except config.mojo
                            mv $PATHDATA/$3/config.mojo $PATHTMP/config.mojo.$3
                            rm -Rf $PATHDATA/$3
                            mkdir -p $PATHDATA/$3
                            mv $PATHTMP/config.mojo.$3 $PATHDATA/$3/config.mojo 
                            echo "Former data folder was REMOVED."

                            confirm "Do you want to restore your backup now? [y/N]" && exit 0
                            tar xzf $PATHBACKUP/all/$3/$4-data.tgz -C $PATHDATA
                        else
                            confirm "Do you want to restore your backup over the existing folder? [y/N]" && exit 0
                            tar xzf $PATHBACKUP/all/$3/$4-data.tgz -C $PATHDATA
                        fi
                    else
                        tar xzf $PATHBACKUP/all/$3/$4-data.tgz -C $PATHDATA
                    fi

                    echo "DATA was RESTORED from backup: $4"
                ;;

                files)
                    ./mojo.sh restore code "$3" "$4" "$5"
                    ./mojo.sh restore data "$3" "$4" "$5"
                ;;

                db)
                    #ToDo: Remove DB if exists
                    mkdir -p $PATHTMP            
                    pathDump=$PATHBACKUP/all/$3/$4-db.tgz

                    # Improve with:  --default_character_set utf8 ??
                    # More info: http://forums.mysql.com/read.php?103,275798,275798

                    echo "You are going to run a SQL query against your DB ojs_$3."
                    echo "--> Your source backup file is: $pathDump"
                    echo "WARNING: This could be a very harmful operation."
                    confirm "Are you sure? (if you have doubts, say NO) [y/N]" && exit 0

                    # Get MySql root pwd:
                    # MOJO_MYSQL_PWD=$(getMyPwd)
                    # echo ""
                    # getMyPwd $3

                    # Creates the DB named "$3":
                    sed -e "s/%MOJO_JOURNAL_TAG%/$3/g" "$PATHBASE/source/templates/createDB.sql" > $PATHTMP/$3-restoredb.sql
                    /usr/bin/mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD < $PATHTMP/$3-restoredb.sql

                    # Executes the tarballed dump:
                    # ToDo: Cleanup output.
                    tar -xOvzf $pathDump | mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD ojs_$3 
                    echo "Opearation DONE. Check your log."
                    # ToDo:
                    # http://mindspill.net/computing/linux-notes/run-mysql-commands-from-the-bash-command-line/
                    # Should work, but not tested yet:
                    # mysql -uroot -p$MOJO_MYSQL_PWD ojs_$3 -e \
                    #   "UPDATE `ojs_$3`.`journals` SET `path` = '$3' WHERE `journals`.`journal_id` =1 LIMIT 1;"
                    #;;
                ;;

                all)
                    ./mojo.sh restore code "$3" "$4" "$5"
                    ./mojo.sh restore data "$3" "$4" "$5"
                    ./mojo.sh restore db "$3" "$4" "$5"

                    # DEPRECATED:
                    # ./mojo.sh d-restoreall $3 $4 
                ;;

                *)
                    # Show syntax:
                    ./mojo.sh restore
                ;;

            esac
        fi
    ;;

    d-restorecode)

        # DEPRECATED !!! use ./mojo.sh restore code <shortname>

        # ToDo: Ask for confirmation (check if DB exists!!).
        # ToDo: Argument's validation.
        # ToDo: Error checking.
        # ToDo: Verbose

        # bck=0

        # Checking number of params:
        if  [ $# -ge 3 ] && [ $# -le 4  ] ; then
            # Checking the backup file.
            # if [ ! -r "$3" ] && [ $3 != "last" ]
            # then
            #  echo "Unable to read the Backup file: $3"
            #   exit 0
            # fi

            # Is pre-backup required?
            if [ $# -eq 4 ] ; then
                if [ $4 == "true" ] || [ $4 == 1 ] ; then
                    # Backup is required BEFORE restoring.
                    # bck=1
                    ./mojo.sh backup code $2
                fi
            fi
          # echo "DEBUG - Backup from: $4"
        else
              echo "Error: Wrong number of parameters"
              echo "Syntax: ./mojo.sh restorecode <shortname> [last | </path/to/backup/file>] [<preBackup>]"
              exit 0
        fi

        # Load journal specific config.mojo variables:
        loadConfig "$2"

        if [ -r "$PATHWEB/ojs-$2" ] ; then
            confirm "Folder ojs-$2 exists. Do you want to delete it before restore? " && echo "rm -Rf $PATHWEB/ojs-$2"
            confirm "Do you want to restore your backup over the existing folder? " && echo "tar xvzf $3 $PATHWEB" && echo "Backup RESTORED!!"
        else
            echo "tar xvzf $3 $PATHWEB"
            echo "Backup RESTORED!!"
        fi
    ;;

    d-restoredb)

        # DEPRECATED !! use: ./mojo.sh restore db <shortname>

        # ToDo: Ask for confirmation (meanwhile dbpwd request does the job).
        # ToDo: Argument's validation.
        # ToDo: Error checking.
        # ToDo: Verbose

        if [ "$2" = "" ] || [ "$3" = "" ] ; then
            echo "Error: You must indicate the magazine's alias and a TGZ file path"
            echo "Syntax: ./mojo.sh restoredb <dbName> [last | </path/to/dbDump.tgz>]"
            exit 0
        else

            # Load journal specific config.mojo variables:
            loadConfig "$2"

            mkdir -p $PATHTMP            
            pathDump=$3

            if [ "$3" = "last" ] ; then
                pathDump=$PATHBACKUP/all/$2/last-db.tgz
            fi

            # Improve with:  --default_character_set utf8 ??
            # More info: http://forums.mysql.com/read.php?103,275798,275798

            echo "You are going to run a SQL query against your DB ojs_$2."
            echo "--> Your source backup file is: $pathDump"
            echo "WARNING: This could be a very harmful operation."
            confirm "Are you sure? (if you have doubts, say NO) [y/N]" && exit 0

            # Get MySql root pwd:
            # getMyPwd $2

            # Creates the DB named "ojs_MOJO_JOURNAL_TAG"
            sed -e "s/%MOJO_JOURNAL_TAG%/$2/g" "$PATHBASE/source/templates/createDB.sql" > $PATHTMP/$2-restoredb.sql
            /usr/bin/mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD < $PATHTMP/$2-restoredb.sql

            # Executes the tarballed dump:
            # ToDo: Cleanup output.
            tar -xOvzf $pathDump | mysql -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD ojs_$2

            echo "The database was RESTORED!"
            # ToDo:
            # http://mindspill.net/computing/linux-notes/run-mysql-commands-from-the-bash-command-line/
            # Should work, but not tested yet:
            # mysql -uroot -p$MOJO_MYSQL_PWD ojs_$3 -e \
            #   "UPDATE `ojs_$3`.`journals` SET `path` = '$3' WHERE `journals`.`journal_id` =1 LIMIT 1;"
            #;;
        fi
    ;;

    clone)
        # ToDo: Ask for confirmation (pe: when overwriting!!)
        # ToDo: Argument's validation.
        # ToDo: Error checking.
        # ToDo: Restore from full path.

        # Params: (new approach)
        pAction="$1"        # clone
        pSubAction="$2"     # code | files | db | all
        pJournalOld="$3"    # Original journal (to be copied).
        pJournalNew="$4"    # Destination journal (to create).


        #DEBUG: showParams "$@"

        if [ ! "$pJournalNew" ] ; then
            echo "Error: You must indicate the sub-action, the two journals' aliases."
            echo "Syntax: ./mojo.sh clone (code|files|db|all) <shortname-old> <shortname-new>"
            echo "sub-actions:"
            echo "    * files:        Recover code & webdata of an specific ojs-magazine."
            echo "    * db:           Recover the DB of an specific ojs-magazine."
            echo "    * all:          COMPLETE recovery of an specific ojs-magazine (scripts, files and DB)"
            echo "    * code:         Recover code of an specific ojs-magazine."
            echo "    * data:         Recover webdata of an specific ojs-magazine."
            exit 0
        else
            # Load journal specific config.mojo variables:
            loadConfig "$pJournalOld"

            # Old Journal exists?
            if [ -d "$PATHWEB/ojs-$pJournalOld" ] ; then

                case $pSubAction in
                    code)
                        echo "Cloning CODE from journal [$pJournalOld] to [$pJournalNew]."

                        if [ -d "$PATHWEB/ojs-$pJournalNew" ] ; then
                            echo "ERROR: CODE folder [ojs-$pJournalNew] exists."
                            echo "You can REMOVE it with: \"\$ mojo backup code $pJournalNew && mojo delete code $pJournalNew\""
                            exit 1
                        else

                            # loadConfig $pJournalOld silent

                            # If not exists, clone config.mojo file and set journal's tag.
                            if [ ! -r "$PATHDATA/$pJournalNew/config.mojo" ] ; then
                                mkdir -p "$PATHDATA/$pJournalNew"
                                cp -a "$PATHDATA/$pJournalOld/config.mojo" "$PATHDATA/$pJournalNew/config.mojo"
                            fi
                            ./mojo.sh set "$pJournalNew" mojovar "MOJO_JOURNAL_TAG" "$pJournalNew"

                            loadConfig "$pJournalNew"

                            cp -a "$PATHWEB/ojs-$pJournalOld" "$PATHWEB/ojs-$pJournalNew"
                            chown ojs:www-data "$PATHWEB/ojs-$pJournalNew"

                            # Creates the new journal's OJS config file.
                            createOjsConfig $pJournalNew

                            # Cleaning cache:
                            # ./mojo.sh cc "$pJournalNew" >/dev/null 2>&1
                            ./mojo.sh cc "$pJournalNew" > /dev/null 

                            # Recreates journal and global htaccess:
                            ./mojo.sh htaccess $pJournalNew > /dev/null
                            ./mojo.sh htaccess > /dev/null

                            # Recreates journal and global crontab:
                            ./mojo.sh crontab $pJournalNew > /dev/null
                            ./mojo.sh crontab > /dev/null

                            echo "CODE was CLONED from journal: $pJournalOld"
                        fi
                    ;;

                    data)                    
                        echo "Cloning DATA from journal [$pJournalOld] to [$pJournalNew]."

                        if [ -d "$PATHDATA/$pJournalNew" ] ; then
                            echo "ERROR: DATA folder [$pJournalNew] exists."
                            echo "You can REMOVE it with: \"\$ mojo backup data $pJournalNew && mojo delete data $pJournalNew\""
                            exit 1
                        else
                            echo "Copy of webdata files. It operation could take a wide..."
                            cp -a "$PATHDATA/$pJournalOld" "$PATHDATA/$pJournalNew"

                            # Issue: Error during upgrade due path issue with emailtemplates.xml when registry is in webdata.
                            mkdir -p "$PATHDATA/$pJournalNew/lib/pkp"
                            cp -a "$PATHVERSIONS/$OJSENGINE/lib/pkp/dtd" "$PATHDATA/$pJournalNew/lib/pkp"

                            # Changes journal tag in config.mojo
                            ./mojo.sh set "$pJournalNew" mojovar "MOJO_JOURNAL_TAG" "$pJournalNew"

                            chown ojs:www-data "$PATHDATA/$pJournalNew"

                            echo "DATA was CLONED from journal: $pJournalOld"
                        fi
                    ;;

                    files)
                        ./mojo.sh clone data "$pJournalOld" "$pJournalNew" > /dev/null
                        ./mojo.sh clone code "$pJournalOld" "$pJournalNew" > /dev/null
                        echo "FILES (data and code) were CLONED from journal: $pJournalOld"
                    ;;

                    db)
                        echo "Cloning DB from journal [$pJournalOld] to [$pJournalNew]."

                        loadConfig "$pJournalNew" 
                        cmdSucced=$?

                        if [ ! $cmdSucced ] ; then
                            echo "A journal config.mojo is requiered. Clone your DATA first or create it manually."
                            exit 1                        
                        else

                            #ToDo: Remove DB if exists?
                            mkdir -p $PATHTMP/$pJournalNew

                            # Improve with:  --default_character_set utf8 ??
                            # More info: http://forums.mysql.com/read.php?103,275798,275798
                            mysql -u$MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD -e "CREATE DATABASE ojs_$pJournalNew;" && \
                                mysqldump --force --log-error=$PATHTMP/$pJournalNew/createdb.log -u$MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD "ojs_$pJournalOld" | \
                                mysql -u$MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD ojs_$MOJO_JOURNAL_TAG
                            cmdSucced=$?

                            if [ ! $cmdSucced ] ; then
                                echo "ERROR: Something fails during DB creation."
                                echo "Log from [$PATHTMP/$pJournalNew/createdb.log]."
                                cat "$PATHTMP/$pJournalNew/createdb.log"
                                exit 1
                            else
                                # Replace config.mojo vars in DB:
                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journals SET path = '$MOJO_JOURNAL_TAG' WHERE journal_id=1;"

                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_TAG' WHERE setting_name='initials';"
                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_TAG' WHERE setting_name='abbreviation';"

                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_CONTACT_NAME' WHERE setting_name='contactName';"
                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_CONTACT_EMAIL' WHERE setting_name='contactEmail';"

                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_SUPPORT_NAME' WHERE setting_name='supportEmail';"
                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_SUPPORT_EMAIL' WHERE setting_name='supportEmail';"

                                ./mojo.sh execute $pJournalNew sqlparam "UPDATE journal_settings SET setting_value = '$MOJO_JOURNAL_DESCRIPTION' WHERE setting_name='description';"
                                                
                                echo "DATABASE was CLONED from journal: $pJournalOld"
                                exit 0
                            fi
                        fi
                    ;;

                    all)
                        ./mojo.sh clone files "$pJournalOld" "$pJournalNew" 
                        ./mojo.sh clone db "$3" "$4" "$5"
                        echo "Visit your new journal at: $URLBASE/$pJournalNew"

                    ;;

                    *)
                        # Show syntax:
                        ./mojo.sh clone
                    ;;

                esac
            else
                echo "ERROR: Source journal [ojs-$pJournalOld] does NOT exist. Please, check your call."
                exit 1
            fi            
        fi
    ;;

    upgrade)
        # Params: (new approach)
        pAction="$1"    # upgrade
        pJournal="$2"   # journal's tag
        pVersion="$3"   # The version (OJSENGINE) upgrade to.
        pBackup="$4"    # Backups is done by default (but could be disabled with "0" )

        #DEBUG: showParams "$@"

        if [ ! "$pVersion" ] ; then
            echo "Error: You must indicate the journal and the desired version."
            echo "Syntax: ./mojo.sh upgrade <shortname> <version> [<backup>]"
            exit 0
        else
            if [ -d "$PATHVERSIONS/$OJSENGINE" ] ; then
                # Load journal specific config.mojo variables:
                loadConfig "$pJournal"

                # Backup full journal (with a checkpoint to rollback)
                if [ "$pBackup" != 0 ] ; then
                    ./mojo.sh backup all $pJournal 1
                fi

                # Replaces version in config.mojo:
                oldVersion=$OJSENGINE
                ./mojo.sh set "$pJournal" mojovar "OJSENGINE" "$pVersion"  > /dev/null

                # Renew all links
                # IMPORTANT: What to do with formely folder2link folders?
                ./mojo.sh r-links "$pJournal" 

                # Check before upgrade
                ./mojo.sh tools $pJournal upgrade.php check

                confirm "WARNING: You are going to upgrade [$pJournal] from version [$oldVersion] to [$pVersion]. Are you sure [y/N]? " && \
                    noUpgrade=1

                if [ "$noUpgrade" ] ; then
                    # Replaces version in config.mojo:
                    ./mojo.sh set "$pJournal" mojovar "OJSENGINE" "$oldVersion"  
                    ./mojo.sh r-links "$pJournal" > /dev/null
                    echo "Operation was canceled."
                else
                    # Copies the registry (was it moved in OJS 2.4??)
                    # Error with /home/ojs/webdata/test1/registry/locales.xml ???
                    cp -a $PATHVERSIONS/$OJSENGINE/registry "$PATHDATA/$pJournal"

                    echo "Doing the DB upgrade. It could take a few minutes..."
                    echo "===================================================="
                    ./mojo.sh tools $pJournal upgrade.php upgrade  2>&1 | tee "$PATHTMP/upgrade.log"
                    echo "===================================================="
                    echo ""
                    echo "Operation finished."
                    echo "If you found errors, check the log here: [$PATHTMP/upgrade.log]"
                fi
            else
                echo "Error: The version [$OJSENGINE] does not exist."
                echo "Review your versions folder: $PATHVERSIONS"
            fi
        fi
 
   ;;

    set)
        # Params: (new approach)
        pAction="$1"    #set
        pJournal="$2"
        pSubAction="$3"
        pVariable="$4"
        pValue="$5"

        #DEBUG: showParams "$@"

        if [ "$pValue" = "" ] ; then
            echo "Error: You must indicate all the parameters:"
            # echo "Syntax:  ./mojo.sh user <shortname> setpwd <username> <password> " 
            echo "Syntax:  ./mojo.sh set <shortname> <mojovar|ojsvar> <variable> <value>"
            echo ""
            echo "Sub-actions:"
            echo "    * mojovar:       Defines a config.mojo variable against the <shorname> journal."
            echo "    * ojsvar:        Defines a ojs variable in the journal_settings table of <shorname> journal."
            echo ""
            echo "Example: ./mojo.sh set myMagazine mojovar OJSENGINE \"current\""
            echo "You can list all your OJS variables with: \"mojo show ojsvar $pJournal list\""
            echo ""
            exit 0
        else

            # Load journal specific config.mojo variables:
            loadConfig "$pJournal"

            case $pSubAction in
                mojovar)
                    # Recreate config.mojo:

                    cp "$PATHBASE/source/templates/config.mojo.base" $PATHDATA/$pJournal/config.mojo 
                    chown ojs:ojs $PATHDATA/$pJournal/config.mojo
                    chmod 700 $PATHDATA/$pJournal/config.mojo

                    mojoVars=( "OJSENGINE" \
                        "DBDUMP" \
                        "MOJO_JOURNAL_TAG" \
                        "MOJO_JOURNAL_DESCRIPTION" \
                        "MOJO_JOURNAL_CONTACT_NAME" \
                        "MOJO_JOURNAL_CONTACT_MAIL" \
                        "MOJO_JOURNAL_SUPPORT_NAME" \
                        "MOJO_JOURNAL_SUPPORT_MAIL" \
                        "MOJO_JOURNAL_TITLE" \
                        "MOJO_JOURNAL_ABBR" 
                        # "MOJO_EDITOR_MAIL" \
                        # "MOJO_EDITOR_NAME" \
                        # "MOJO_EDITOR_LASTNAME" \
                        # "MOJO_JOURNAL_TITLE" \
                        # "MOJO_ADMIN_SERVICENAME" \
                        # "MOJO_ADMIN_NAME" \
                        # "MOJO_ADMIN_LASTNAME" \
                        # "MOJO_CONTACT_NAME" \
                        # "MOJO_CONTACT_MAIL"
                    )

                    # IMPORTANT: It all only will work in interactive mode. 
                    # Commandline version still need to be implemented.
                    for i in "${mojoVars[@]}"
                    do
                        # EXTRA VARIABLES: When "interactive mode" extra variables are requested.
                        if [ $INTERACTIVE = "true" ] ; then

                            if [ "$i" == "$pVariable" ] ; then
                                # Save the new value in journal's config.mojo
                                echo "$pVariable=\"$pValue\"" >> $PATHDATA/$2/config.mojo

                                if [ $DEBUG == true ] ; then 
                                    echo "DEBUG--> Replacing [$i = \"$pVariable\"] in journal's config.mojo"
                                fi
                            else
                                # Keep the value as formely defined.
                                eval "defaultVar=\$$i"
                                echo "$i=\"$defaultVar\"" >> $PATHDATA/$2/config.mojo

                                if [ $DEBUG == true ] ; then 
                                    echo "DEBUG--> Keeping variable as [$i = \"$defaultVar\"] in journal's config.mojo" 
                                fi
                            fi
                        fi
                    done
                    exit 0
                ;;

                ojsvar)
                    #
                    # IMPORTANT ToDo: Check if the variable exists in de DB before creating it.
                    # Think about the best way to deal with journal, site, whatever variables...
                    #

                    confirm "This operation is very BETA and will modify your journal DB. Are you sure? [y/N]" && exit 0
                    ./mojo.sh execute $pJournal sqlparam "UPDATE journal_settings SET setting_value = '$pValue' WHERE setting_name='$pVariable';"

                ;;

                *)
                    ./mojo.sh set
                ;;
            esac
        fi    
    ;;

    execute)
        # Params: (new approach)
        pAction="$1"    #execute
        pJournal="$2"
        pSubAction="$3"
        pQuery="$4"
        pVerbose="$5"

        #DEBUG: showParams "$@"

        if [ "$pQuery" = "" ] ; then
            echo "Error: You must indicate the magazine's alias, the operation and the sub-action:"
            # echo "Syntax:  ./mojo.sh user <shortname> setpwd <username> <password> " 
            echo "Syntax:  ./mojo.sh execute <shortname> sqlparam <theSqlQuery> [<verbose>]"
            echo ""
            echo "Sub-actions:"
            echo "    * sqlparam:       Executes the specified query against the <shorname> database."
            echo ""
            echo "Example: ./mojo.sh execute myMagazine sqlparam \"select * from users;\" 1"
            echo ""
            exit 0
        else

            # Load journal specific config.mojo variables:
            loadConfig "$pJournal"

            case $pSubAction in
                sqlparam)
                    # getMyPwd "$pJournal"

                    # Let's execute this query:
                    if [ "$pVerbose" ] ; then
                        /usr/bin/mysql -D ojs_$pJournal -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD -v -e "$pQuery"
                    else
                        /usr/bin/mysql -D ojs_$pJournal -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD -e "$pQuery"
                    fi
                ;;

                *)
                    ./mojo.sh user
                ;;
            esac
        fi
    ;;

    show)
        # Params: (new approach)
        pAction="$1"        # show
        pSubAction="$2"     # mconfig | jconfig | oconfig
        pJournal="$3"       # The journal (ToDo: optional if mconfig)
        pFilter="$4"        # The filter (pe: variable name?) to apply to the output (optional)
        pModifier="$5"      # Additional instructions.

        #DEBUG: showParams "$@"

        if [ "$pJournal" = "" ] ; then
            echo "Error: You must indicate the sub-action and the Journal:"
            #echo "Syntax:  ./mojo.sh sethome <shortname> <sub-action> "
            echo "Syntax:  ./mojo.sh show <subaction> <shortname> [<filter>]"
            echo "Sub-actions:"
            echo "    * mconfig:       Shows mojo global configuration."
            echo "    * jconfig:       Shows mojo journal configuration."
            echo "    * oconfig:       Shows OJS configuration."
            echo "    * ojsvar:        Shows OJS journal_settings variables."
            echo "Example: ./mojo.sh show mconfig myMagazine MOJO_CONTACT_MAIL"
            exit 0
        else

            loadConfig "$pJournal"

            case $pSubAction in
                mconfig)
                    if [ $DEBUG == true ] ; then echo "Global mojo configuration" ; fi
                    if [ "$pFilter" ] ; then
                        cat "$SCRIPTPATH/config.mojo" | grep "=" | grep "$pFilter"
                    else
                        cat "$SCRIPTPATH/config.mojo" | grep "="
                    fi
                ;;

                jconfig)
                    if [ $DEBUG == true ] ; then echo "Specific mojo configuration for journal [$pJournal]:" ; fi
                    if [ "$pFilter" ] ; then
                        cat "$PATHDATA/$MOJO_JOURNAL_TAG/config.mojo" | grep "=" | grep "$pFilter"
                    else
                        cat "$PATHDATA/$MOJO_JOURNAL_TAG/config.mojo" | grep "="
                    fi
                ;;

                oconfig)
                    if [ $DEBUG == true ] ; then echo "Specific OJS configuration for journal [$pJournal]:" ; fi
                    if [ "$pFilter" ] ; then
                        cat "$PATHWEB/ojs-$pJournal/config.inc.php" | grep "=" | grep "$pFilter"
                    else
                        cat "$PATHWEB/ojs-$pJournal/config.inc.php" | grep "="
                    fi
                ;;

                ojsvar)
                    if [ $DEBUG == true ] ; then echo "Show ojs journal variables for journal [$pJournal]:" ; fi

                    # Params change order and meaning when "ojsvar":
                    pFilter="$5"
                    pModifier="$4"

                    case $pModifier in
                        list)
                            if [ "$pFilter" ] ; then
                                ./mojo.sh execute $pJournal sqlparam "SELECT journal_id, locale, setting_name FROM journal_settings WHERE setting_name LIKE \"$pFilter\" ORDER BY setting_name"
                            else
                                ./mojo.sh execute $pJournal sqlparam "SELECT journal_id, locale, setting_name FROM journal_settings ORDER BY setting_name"
                            fi
                        ;;

                        listdata)
                            if [ "$pFilter" ] ; then
                                ./mojo.sh execute $pJournal sqlparam "SELECT journal_id, locale, setting_name, setting_value FROM journal_settings WHERE setting_name LIKE \"$pFilter\" ORDER BY setting_name"
                            else
                                ./mojo.sh execute $pJournal sqlparam "SELECT journal_id, locale, setting_name, setting_value FROM journal_settings ORDER BY setting_name"
                            fi
                        ;;

                        listall)
                            if [ "$pFilter" ] ; then
                                ./mojo.sh execute $pJournal sqlparam "SELECT * FROM journal_settings WHERE setting_name LIKE \"$pFilter\" ORDER BY setting_name"
                            else
                                ./mojo.sh execute $pJournal sqlparam "SELECT * FROM journal_settings ORDER BY setting_name"
                            fi
                        ;;

                        help)
                            echo "Syntax:  ./mojo.sh show ojsvar <modifier> [<filter>]"
                            echo "Modifiers:"
                            echo "    * list:       Shows every journal_settings variable."
                            echo "    * listdata:   Shows every journal_settings variable and it's data."
                            echo "    * listall:    Shows every journal_settings row."
                            echo "    * help:       This help."
                            echo "Example: ./mojo.sh show ojsvar myMagazine listdata \"%title%\""
                            exit 0
                        ;;

                        *)
                            ./mojo.sh show ojsvar "$pJournal" help
                        ;;
                    esac

                ;;

                *)
                    ./mojo.sh show
                ;;

            esac
        fi
    ;;


    user)
        # Params: (new approach)
        pAction="$1"  #user
        pJournal="$2"
        pSubAction="$3"
        pUser="$4"
        pPasswd="$5"

        #DEBUG: showParams "$@"

        if [ "$pPasswd" = "" ] ; then
            echo "Error: You must indicate the magazine's alias, the operation and the sub-action:"
            #echo "Syntax:  ./mojo.sh sethome <shortname> <sub-action> "
            echo "Syntax:  ./mojo.sh user <shortname> setpwd <username> <password> "
            echo "Sub-actions:"
            echo "    * setpwd:       Overwites user's pwd."
            echo "Example: ./mojo.sh user myMagazine setpwd admin myNewPwd"
            exit 0
        else

            # Load journal specific config.mojo variables:
            loadConfig "$pJournal"

            case $pSubAction in
                setpwd)
                    echo "Canviar pwd de [$pUser] per [$pPasswd] a la revista [$pJournal]"

                    # Let's execute this query:
                    /usr/bin/mysql -D ojs_$pJournal -u $MOJO_MYSQL_USER -p$MOJO_MYSQL_PWD -e "UPDATE users SET password=SHA1(CONCAT(username, '$pPasswd')) WHERE username = '$pUser';"
                ;;

                *)
                    ./mojo.sh user 
                ;;
            esac
        fi
    ;;

    htaccess)
        #ToDo: Silent mode.

        if [ "$2" != "" ] ; then
            # Load journal specific config.mojo variables:
            loadConfig "$2"

            sed -e "s/%MOJO_JOURNAL_TAG%/$2/g" "$PATHBASE/source/templates/htaccessMagazine.base" > $PATHWEB/ojs-$2/htaccess.chunk
            if [ $DEBUG == true ] ; then echo "DEBUG--> Htaccess: Created templated chunk file for magazine: $2" ; fi
            else
                sed -e "s/%TODAY%/$NOW/g" "$PATHBASE/source/templates/htaccess.base" > $PATHWEB/.htaccess
                if [ $DEBUG == true ] ; then echo "DEBUG--> Regenerated htaccess header from template htaccess.base" ; fi

            # for chunk in "$PATHBASE"/ojs-*"
            for chunk in $( find $PATHWEB -maxdepth 1 -type d -name 'ojs-*' )
            do
                # check if file exists
                # need to avoid error with non mojo instalations in same directory
                if [ -e "$chunk/htaccess.chunk" ] ; then 
                  cat "$chunk/htaccess.chunk" >> $PATHWEB/.htaccess
                  # Uncomment to verbose:
                  # echo "Attached magazine: $chunk"
                fi
            done

            chown ojs:www-data $PATHWEB/.htaccess
            chmod 775 $PATHWEB/.htaccess

            echo "--> Htaccess: Recreated global .htaccess file from each magazine's chunks."

            /etc/init.d/apache2 reload
        fi
    ;;

    crontab)
        #ToDo: Silent mode.

        if [ "$2" != "" ] ; then
            # Load journal specific config.mojo variables:
            loadConfig "$2"

            sed -e "s/%MOJO_JOURNAL_TAG%/$2/g" "$PATHBASE/source/templates/crontabMagazine.base" > $PATHWEB/ojs-$2/cron.chunk
            if [ $DEBUG == true ] ; then echo "DEBUG--> Crontab: Created chunk file for magazine: $2" ; fi
        else
            sed -e "s/%TODAY%/$NOW/g" "$PATHBASE/source/templates/crontab.base" > $PATHBASE/cronMagazines.sh

            # for chunk in "$PATHBASE"/ojs-*"
            for chunk in $( find $PATHWEB  -maxdepth 1 -type d -name 'ojs-*' )
            do
                if [ -e "$chunk/cron.chunk" ] ; then
                    cat "$chunk/cron.chunk" >> $PATHBASE/cronMagazines.sh
                fi
            done

            chown ojs:www-data $PATHBASE/cronMagazines.sh
            chmod 775 $PATHBASE/cronMagazines.sh

            echo "--> Crontab: Recreated global cronMagazines.sh script"
        fi
    ;;

    r-links)
        #ToDo: Ask for confirmation.

        if [ "$2" != "" ] ; then
            # Load journal specific config.mojo variables:
            loadConfig "$2"

            # Building the SHARED folders:
            SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

            if [ "$3" ] ; then
                # Relinks to "$3" version
                for x in ${SHARED}
                do
                    if [ $DEBUG == true ] ; then echo "DEBUG--> Remove folder-link [${x}] and linking to version $3." ; fi

                    if [ -d "$PATHWEB/ojs-$2/${x}" ] ; then
                        if [ -L "$PATHWEB/ojs-$2/${x}" ] ; then
                            if [ $DEBUG == true ] ; then echo "DEBUG--> [${x}] is a symlink." ; fi
                            ln -s -f "$PATHVERSIONS/$OJSENGINE/${x}" "$PATHWEB/ojs-$2"
                        else
                            # It's not a symlink, it's a physical folder:
                            confirm "Folder [${x}] exists. Do you want to delete it and r-link to version [$3] [y/N]? "

                            if [ $? ] ; then
                                echo "Keeping the physical folder [${x}]. Was not r-linked."
                            else
                                rm -Rf $PATHWEB/ojs-$2/${x} && \
                                ln -s -f "$PATHVERSIONS/$3/${x}" "$PATHWEB/ojs-$2"
                            fi
                        fi
                    else
                        # Not existing or broken symlinks:
                        ln -s -f "$PATHVERSIONS/$3/${x}" "$PATHWEB/ojs-$2"                        
                    fi
                done
                echo "--> R-Link: Recreated all symlinks for magazine $2 (to $3 version)"
            else
                # Relinks to config.mojo OJSENGINE.
                for x in ${SHARED}
                do
                    if [ $DEBUG == true ] ; then echo "DEBUG--> Remove link: ${x} and linking to [$OJSENGINE] version." ; fi

                    if [ -d "$PATHWEB/ojs-$2/${x}" ] ; then
                        if [ -L "$PATHWEB/ojs-$2/${x}" ] ; then
                            if [ $DEBUG == true ] ; then echo "DEBUG--> [${x}] is a symlink." ; fi
                            ln -s -f "$PATHVERSIONS/$OJSENGINE/${x}" "$PATHWEB/ojs-$2"
                        else
                            confirm "Folder [${x}] exists. Do you want to delete it and r-link to [$OJSENGINE] [y/N]? " && keep=1

                            if [ $keep ] ; then
                                echo "Keeping the physical folder [${x}]. Was not r-linked."
                            else
                                rm -Rf $PATHWEB/ojs-$2/${x} && \
                                ln -s -f "$PATHVERSIONS/$OJSENGINE/${x}" "$PATHWEB/ojs-$2"
                            fi
                        fi
                    else
                        # Not existing or broken symlinks:
                        ln -s -f "$PATHVERSIONS/$OJSENGINE/${x}" "$PATHWEB/ojs-$2"                        
                    fi
                done
                echo "--> r-link: Recreated all symlinks for magazine $2 (to $OJSENGINE version)"
            fi
            chown ojs:www-data "$PATHWEB/ojs-$2" -R
        else
            echo "ERROR: A site alias is required."
            echo "Syntax:  ./mojo.sh r-links site-name [version-folder]"
            echo "Example: ./mojo.sh r-links athenea current"
        fi
    ;;

    link2fold)
    #ToDo: Ask for confirmation.

        if [ "$2" != "" ] ; then
            # Load journal specific config.mojo variables:
            loadConfig "$2"

            if [ "$3" != "" ] ; then
                rm "$PATHWEB/ojs-$2/$3"
                cp "$PATHVERSIONS/$OJSENGINE/$3" "$PATHWEB/ojs-$2/$3" -a
                echo "--> link2fold: Folder $3 is not a link any more in magazine $2"
            else
                echo "ERROR: A folder name is required."
                echo "Syntax:  ./mojo.sh link2fold site-name [ojs-folder]"
                echo "Example: ./mojo.sh link2fold athenea templates"
            fi
        else
            echo "ERROR: A site alias is required."
            echo "Syntax:  ./mojo.sh link2fold site-name [ojs-folder]"
            echo "Example: ./mojo.sh link2fold athenea templates"
        fi
    ;;

    setdomain)
        if [ "$2" != "" ] ; then
            # Load journal specific config.mojo variables:
            loadConfig "$2"

            if [ "$2" == "reset" ] ; then
                # Resets the OJS's config file.
                createOjsConfig $3 
                echo "--> Reset config.inc.php for magazine $3."
                # Resets htaccess.chunk from base template.
                ./mojo.sh htaccess $3
                ./mojo.sh htaccess
            else
                # Generates the magazine's config file to allow domainName.
                createOjsConfig $2 $3
                echo "--> Recreated new config.inc.php for magazine $2 and domain $3."

                # Generates the domainName htaccess chunk and recreates global htaccess.
                sed -e "s/%MOJO_JOURNAL_TAG%/$2/g" "$PATHBASE/source/templates/htaccessMagazineDomain.base" > $PATHWEB/ojs-$2/htaccess.chunk
                sed -i "s!%MOJO_JOURNAL_DOMAIN%!$3!g" "$PATHWEB/ojs-$2/htaccess.chunk"
                echo "--> Recreated new htaccess.chunk for magazine $2 and domain $3."

                ./mojo.sh htaccess
                echo "WARNING: Add 'ServerAlias $3' to your vhost and reload apache."
            fi
        else
            echo "Syntax Error:"
            echo "Magazine's tag and full domain name must be specified as parameters."
            echo "Try with: ./mojo.sh setdomain magazineName www.yourdomain.com"
            echo "Or with:  ./mojo.sh setdomain reset magazineName"
        fi
    ;;

    cleancache|cc)
        if [ "$2" != "" ] ; then
            # DEBUG: echo "Cache folder: $PATHBASE/htdocs/ojs-$2/cache/"
            # find "$PATHBASE/htdocs/ojs-$2/cache/" -type f

            find "$PATHBASE/htdocs/ojs-$2/cache/" -type f -print0 | xargs -0 rm
            echo "Server Cache for magazine [$2] is now clean"
        fi
    ;;

    sethome)
        # Params: (new approach)
        pAction="$1"
        pJournal="$2"
        pSubAction="$3"
        pMail="$4"

        #DEBUG: showParams "$@"

        if [ "$pAction" = "" ] || [ "$pSubAction" = "" ] ; then
            echo "Error: You must indicate the magazine's alias, the operation and the sub-action:"
            echo "Syntax:  ./mojo.sh sethome <shortname> <sub-action> "
            echo "Sub-actions:"
            echo "    * open:         Open the magazine (recovers OJS original index.php)."
            echo "    * lock:         The magazine is Locked."
            echo "    * work:         The magazine is in Mantainance."
            echo "Example: ./mojo.sh sethome ensciencias lock"
            exit 0
        else
            # Load journal specific config.mojo variables:
            loadConfig "$pJournal"

            case $pSubAction in
                open)
                    cp -a "$PATHVERSIONS/$OJSENGINE/index.php" "$PATHWEB/ojs-$pJournal/index.php"
                    echo "Magazine $pJournal is now OPEN."
                ;;

                lock)
                    if [ "$pMail" = "" ] ; then
                        echo "Error: You must indicate a mail of contact"
                        echo "Syntax:  ./mojo.sh sethome <shortname> lock <mailOfContact>"
                    else
                        sed -e "s/MOJO_MAIL/$pMail/g" "$PATHFILEWORK" > $PATHTMP/$pJournal-lock.php
                        cp -a "$PATHTMP/$pJournal-lock.php" "$PATHWEB/ojs-$pJournal/index.php"
                        echo "Magazine $pJournal is now LOCKED."
                    fi
                ;;

                work)
                    cp -a "$PATHFILEWORK" "$PATHWEB/ojs-$pJournal/index.php"
                    echo "Magazine $pJournal is now in MANTAINANCE."
                ;;

                *)
                    ./mojo.sh sethome
                ;;
            esac
        fi
    ;;

    tools|t)
        if [ "$2" = "" ] || [ "$3" = "" ] ; then
            echo "Error: You must indicate the magazine's alias and the tool you call"
            echo "Syntax:  ./mojo.sh tools <shortname> tools/<pkp-tool> "
            echo "Example: ./mojo.sh tools athenea tools/upgrade.php check"
            exit 0
        else
            loadConfig $2

            # ISSUE: Tools won't work symlinked due relative paths (OJS code need to be changed)
            # http://pkp.sfu.ca/bugzilla/show_bug.cgi?id=7073

            # WORKARROUND: copy physical folder and symlink it again at the end.
            rm "$PATHWEB/ojs-$2/tools" -Rf
            cp "$PATHVERSIONS/$OJSENGINE/tools" "$PATHWEB/ojs-$2/tools" -a

            php "$PATHWEB/ojs-$2/$3" "$4" "$5" "$6" "$7" "$8" "$9"

            # Recovering symlink:
            rm "$PATHWEB/ojs-$2/tools" -Rf
            ln -s -f "$PATHVERSIONS/$OJSENGINE/${x}/tools" "$PATHWEB/ojs-$2/tools"
        fi
    ;;

    *)
        ./mojo.sh help
    ;;
esac

# Back to the calling folder:
cd $BACKCD > /dev/null
exit 0
