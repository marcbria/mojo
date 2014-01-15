#!/bin/bash

#===============================================================================
#          FILE:    mojo.sh
#
#         USAGE:    ./mojo.sh <action> [<subaction>] <shortname> [<other>]
#
#   DESCRIPTION:    Administers the structure of folders and database for
#                   independent OJS with one preconfigured magazine inside.
#
#    PARAMETERS:
#
#         <action>: help (h):           Script syntax.
#                   list (l):           List all the magazines of the service.
#                      |_ magazines (m):Lists the name of all the magazines.
#                      |_ count (c):    Returns the total number of magazines.
#                   create:             Create files, folder structure and/of db.
#                      |_ files (cf):   Create the folder structure (code & data).
#                      |_ db (cdb):     Create the DB of an ojs-magazine from BASE template.
#                      |_ all (call):   Create a full ojs-magazine from the BASE template.
#                   d-createfiles (cf):   (deprecated) Create the folder structure of an ojs-magazine.
#                   d-createdb (cdb):     (deprecated) Create the DB of an ojs-magazine from BASE template.
#                   d-createall (call):   (deprecated) Create a full ojs-magazine from the BASE template.
#                   delete:             Delete the folder structure and/or the DB of an ojs-magazine.
#                      |_ files:        Delete the code & of an ojs-magazine (first backups)
#                      |_ db:           Delete the DB of an specific ojs-magazine.
#                      |_ all:          COMPLETE remove of a ojs-magazine (scripts, files and DB)
#                   deletefiles:          Delete the code & of an ojs-magazine (first backups)
#                   deletedb:             Delete the DB of an specific ojs-magazine.
#                   deleteall:            COMPLETE removes of a ojs-magazine (scripts, files and DB)
#                   backup (bck):       Backup the files (code or-and data) and DB of an specific ojs-magazine.
#                      |_ files:        Backup code & webdata of an specific ojs-magazine.
#                      |_ db:           Backup the DB of an specific ojs-magazine.
#                      |_ all:          COMPLETE backup specific ojs-magazine (scripts, files and DB)
#                      |_ code:         Backup code of an specific ojs-magazine.
#                      |_ data:         Backup webdata of an specific ojs-magazine.
#                   backupdb (bdb):       Backup DB of an specific ojs-magazine.
#                   backupall (ball):     COMPLETE backup of a magazine (scripts, files and DB)
#                   restore:            Recover the files (code or-and data) of a formely backup for ojs-magazine.
#                      |_ files:        Recover code & webdata of an specific ojs-magazine.
#                      |_ db:           Recover the DB of an specific ojs-magazine.
#                      |_ all:          COMPLETE recovery of an specific ojs-magazine (scripts, files and DB)
#                      |_ code:         Recover code of an specific ojs-magazine.
#                      |_ data:         Recover webdata of an specific ojs-magazine.
#                   d-restorecode:        (deprecated) Recovers the code of a formely backup for ojs-magazine.
#                   d-restoredb:          (deprecated) Recover a formely DB backup for ojs-magazine.
#                   filldb:               (dev) Executes an sql script against the selected ojs-magazine.
#                   htaccess:           Recreate the global htaccess file.
#                   crontab:            Recreate the global crontab file.
#                   r-links:            Recover symlinks for an specific site.
#                   link2fold:          Replace a symlink with the folder's content. BE CAREFULL!!
#                   setdomain:          Recreate config files to let the magazine respond under a domain.
#                   cleancache (cc):    Clean OJS Cache.
#                   sethome:            Replace index.php with an alternative page.
#                      |_ open:         Opens the magazine (revcvers OJS original index.php).
#                      |_ lock:         The magazine is Locked.
#                      |_ work:         The magazine is in Mantainance.
#                   tools (t):          Call pkp-tools (see your OJS /tools folder)
#                   upgrade:            (ToDo) Replaces [current] links to [new] version and upgrade ojs-DB.
#    <shortname>:   Short name (aka. alias) of the magazine to be operated.
#                   The tag ALL is reserved to operate against every magazine
#                   of the system (Not implemented yet).
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
#       UPDATED:  21/10/13 10:32:33 CEST
#      REVISION:  0.28
#===============================================================================

# SCRIPT CONFIGURATION CONSTANTS TAKEN FROM config.mojo=========================
# Taken variables are:
# Path of the service root (P.e: /home/ojs)
# PATHBASE="/home/ojs"
#
# Path of the folder with the current version (P.e: $URLBASE/source/versions/current)
# PATHMOTOR="$PATHBASE/source/versions/current"
#
# Path of the web root (P.e: $PATHBASE/htdocs)
# PATHWEB="$PATHBASE/htdocs"
#
# Path of the storage folder (P.e: $PATHBASE/webdata)
# PATHDATA="$PATHBASE/webdata"
#
# Path of the backup folder (P.e: $PATHBASE/backup)
# PATHBACKUP="$PATHBASE/backup"
#
# Base URL for the service (P.e: http://revistes.uab.cat)
# URLBASE="http://revistes.uab.cat"
# Path of the temporal folder (Pe: /tmp/mojo)
# PATHTMP="/tmp/mojo"
#
# DB dump of the OJS model
# DBDUMP="dumpBaseNew.sql"
#
# Even more verbose
# DEBUG=false

# LOAD CONFIGURATION FILE
#
# Get current path
SCRIPT="`readlink -e $0`"
SCRIPTPATH="`dirname $SCRIPT`"
# Load file if exists
if [ -f $SCRIPTPATH/config.mojo ] ; then
  . $SCRIPTPATH/config.mojo
else
  echo "ERROR: Configuration file config.mojo doesn't exists"
  exit 
fi


#===============================================================================

NOW="$(date +"%Y%m%d-%M%S")"

# Don't change this variables: Place your MySql usr/pwd in .secrets file
mysqlUsr=""
mysqlPwd=""

# FUNCTIONS: ===================================================================

function getMyPwd() {
    # Get mySql pwd (may be is better using config variables... or directly OJS configs):
    if [ -f .secret ] ; then
    	. .secret
    else
	    # If not defined, asks for passwd:
	    if [ ! $mysqlUsr ] ; then
	      read -s -p "Enter MYSQL user: " mysqlUsr
        echo -e
      fi
      if [ ! $mysqlPwd ] ; then
	      read -s -p "Enter MYSQL password: " mysqlPwd
        echo -e
      fi
      while ! mysql -u $mysqlUsr -p$mysqlPwd  -e ";" ; do
          read -s -p "Can't connect, please retry username: " mysqlUsr
          echo -e
          read -s -p "Can't connect, please retry password: " mysqlPwd
          echo -e
          # echo "Trying with: $mysqlPwd" >> /home/ojs/scripts/pwd.log
      done
	    # echo $mysqlPwd
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

pAction=""
pMagazine=""
pSubAction=""

function showParams() {
    echo ""
    echo "SETPARAMS: $@"
    echo "pMagazine:   $pMagazine"
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
            pMagazine="$1"
            pAction="$2"
            pSubAction="$3"
        ;;
        *)
            # geting params in usual order:
            pMagazine="$1"
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
        echo "Download OJS code"
        echo ""
        #Add mojo to /usr/bin
        ln -s /home/ojs/scripts/mojo.sh /usr/bin/mojo
    ;;

    test)
        # Testing params: Rethink taking in consideration "list" param... 
        # Delay until getopts/getopt introduction.

        # geting params in usual order:
        pMagazine=""
        pAction=""
        pSubAction=""
        pBackupId=""
        pPreBackup=""
        pCheckpoint=""

        setParams "$@"
        echo "DO -> $pAction !!"

		# Testing of snippets

        # getMyPwd
        # echo "mysqlUsr: $mysqlUsr" 
        # echo "mysqlPwd: $mysqlPwd" 

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

		echo "Version: 0.27"
        echo "Syntax: ./mojo.sh <action> [<subaction>] <shortname> [<other>]"
        echo ""
        echo "        <action>: help (h):           Script syntax."
        echo "                  list (l):           List all the magazines of the service."
        echo "                     |_ magazines (m):Lists all the name of all the magazines."
        echo "                     |_ count (c):    Returns the total number of magazines."
        echo "                  create:             Create the folder structure of an ojs-magazine."
        echo "                     |_ files (cf):   Create the folder structure of an ojs-magazine."
        echo "                     |_ db (cdb):     Create the DB of an ojs-magazine from BASE template."
        echo "                     |_ all (call):   Create a full ojs-magazine from the BASE template."
        # echo "                  d-createfiles (cf):   (deprecated) Create the folder structure of an ojs-magazine."
        # echo "                  d-createdb (cdb):     (deprecated) Create the DB of an ojs-magazine from BASE template."
        # echo "                  d-createall (call):   (deprecated) Create a full ojs-magazine from the BASE template."
        echo "                  delete:             Delete the folder structure and/or the DB of an ojs-magazine."
        echo "                     |_ files:        Delete the code & of an ojs-magazine (first backups)"
        echo "                     |_ db:           Delete the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE remove of a ojs-magazine (scripts, files and DB)"
        # echo "                  deletefiles:          Delete the code & of an ojs-magazine (first backups)"
        # echo "                  deletedb:             Delete the DB of an specific ojs-magazine."
        # echo "                  deleteall:            COMPLETE removes of a ojs-magazine (scripts, files and DB)"
        echo "                  backup (bck):       Backup the files (code or-and data) and DB of an specific ojs-magazine."
        echo "                     |_ files:        Backup code & webdata of an specific ojs-magazine."
        echo "                     |_ db:           Backup the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE backup specific ojs-magazine (scripts, files and DB)"
        echo "                     |_ code:         Backup code of an specific ojs-magazine."
        echo "                     |_ data:         Backup webdata of an specific ojs-magazine."
        # echo "                  backupdb (bdb):       Backup DB of an specific ojs-magazine."
        # echo "                  backupall (ball):     COMPLETE backup of a magazine (scripts, files and DB)"
        echo "                  restore:            Recover the files (code or-and data) of a formely backup for ojs-magazine."
        echo "                     |_ files:        Recover code & webdata of an specific ojs-magazine."
        echo "                     |_ db:           Recover the DB of an specific ojs-magazine."
        echo "                     |_ all:          COMPLETE recovery of an specific ojs-magazine (scripts, files and DB)"
        echo "                     |_ code:         Recover code of an specific ojs-magazine."
        echo "                     |_ data:         Recover webdata of an specific ojs-magazine."
        # echo "                  d-restorecode:        (deprecated) Recovers the code of a formely backup for ojs-magazine."
        # echo "                  d-restoredb:          (deprecated) Recover a formely DB backup for ojs-magazine."
        # echo "                  filldb:               (dev) Executes an sql script against the selected ojs-magazine."
        echo "                  htaccess:           Recreate the global htaccess file."
        echo "                  crontab:            Recreate the global crontab file."
        echo "                  r-links:            Recover symlinks for an specific site."
        echo "                  link2fold:          Replace a symlink with the folder's content. BE CAREFULL!!"
        echo "                  setdomain:          Recreate config files to let the magazine respond under a domain."
        echo "                  cleancache (cc):    Clean OJS Cache."
        echo "                  sethome:            Replace index.php with an alternative page."
        echo "                     |_ open:         Opens the magazine (revcvers OJS original index.php)."
        echo "                     |_ lock:         The magazine is Locked."
        echo "                     |_ work:         The magazine is in Mantainance."
        echo "                  tools (t):          Call pkp-tools (see your OJS /tools folder)"
		# echo "					upgrade:            (ToDo) Replaces [current] links to [new] version and upgrade ojs-DB."
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
                        echo "-> List of magazines:"
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
	            echo "Syntax: ./mojo.sh create (files|db|all) <shortname> [<magazineValues>]"
	            exit 0
	        fi
        else
            case $2 in
                files)
                    ./mojo.sh d-createfiles "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;
                db)
                    ./mojo.sh d-createdb "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;
                all)
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

            # Checking if data&code folders exists:
            message="WARNING: Code folder exists for magazine: $2 [$PATHWEB/ojs-$2] \nOperation aborted!!"
            folderExist "YES" "$PATHWEB/ojs-$2" "$message" && exit 0
            message="WARNING: Data folder exists for magazine: $2 [$PATHDATA/$2] \nOperation aborted!!"
            folderExist "YES" "$PATHDATA/$2" "$message" && exit 0

            # Building the folder structure of the new magazine
            if [ $NEWMODEL == true ] ; then 
              # An independent model (clean version instead of base copy)
              mkdir -p "$PATHDATA/$2/files"                             # Creates the data folder
              mkdir -p "$PATHDATA/$2/registry"                          #   ... and registry.
              mkdir -p "$PATHWEB/ojs-$2/public"                         # Some predefined public files (pe: logos, banners).
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

            cp -a "$PATHMOTOR/index.php" "$PATHWEB/ojs-$2/index.php"    # Comment: A symlink won't work.


            # Building the structure for NON SHARED folders:
            mkdir -p "$PATHWEB/ojs-$2/cache/t_cache"
            mkdir -p "$PATHWEB/ojs-$2/cache/t_compile"
            mkdir -p "$PATHWEB/ojs-$2/cache/t_config"
            mkdir -p "$PATHWEB/ojs-$2/cache/_db"

            # Building the SHARED folders (same files between ALL OJS instalations):
            SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

            for x in ${SHARED}
            do
                ln -s -f "$PATHMOTOR/${x}" "$PATHWEB/ojs-$2"
            done

            # Generates the magazine's config file.
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/config.inc.php.base" > $PATHWEB/ojs-$2/config.inc.php
            sed -i "s!%pathData%!$PATHDATA!g" "$PATHWEB/ojs-$2/config.inc.php"

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

            mkdir -p "$PATHTMP"

            # Creates the DB named "ojs_revistaTag"
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/createDB.sql" > $PATHTMP/$2-create.sql

            # Replaces REDI_REVISTA_TAG tag in the BASE dump:
            sed -e "s/REDI_REVISTA_TAG/$2/g" "$PATHBASE/source/templates/$DBDUMP" > $PATHTMP/$2-fill.sql

            # Replaces REDI_REVISTA_MAIL tag with the specified mail (REDI_REVISTA_MAIL):
            if [ $INTERACTIVE = "true" ] && [ -z $3 ] ; then
              read -p "Editor's Mail: " $3
            fi
            if [ "$3" ] ; then
            echo "----> Editor's Mail: $3"
                sed -i "s/REDI_REVISTA_MAIL/$3/g" $PATHTMP/$2-fill.sql
            fi

            # Replaces REDI_REVISTA_RESPONSABLE with the specified magazine's responsible name:
            if [ $INTERACTIVE = "true" ] && [ -z $4 ] ; then
              read -p "Editor's Full Name: " $4
            fi
            if [ "$4" ] ; then
                echo "----> Editor' Full Name: $4"
                sed -i "s/REDI_REVISTA_RESPONSABLE/$4/g" $PATHTMP/$2-fill.sql
            fi

            # Replaces REDI_REVISTA_TITLE with the specified magazine's title:
            if [ $INTERACTIVE = "true" ] && [ -z $5 ] ; then
              read -p "Magazine's Title: " $5
            fi
            if [ "$5" ] ; then
                echo "----> Magazine's Title: $5"
                sed -i "s/REDI_REVISTA_TITLE/$5/g" $PATHTMP/$2-fill.sql
            fi

            cat $PATHTMP/$2-fill.sql >> $PATHTMP/$2-create.sql

            # Get MySql root pwd:
            # mysqlPwd=$(getMyPwd)
            # echo ""
            getMyPwd

            /usr/bin/mysql -u $mysqlUsr -p$mysqlPwd < $PATHTMP/$2-create.sql
            if grep -q "REDI_REVISTA_TAG" $PATHBASE/source/templates/$DBDUMP ; then
              echo "Magazine's DB was created."
            else
              # If the base dump doesn't have the TAG the critical cells
              # will be also replaced
              echo "WARNING: TAG to replace not found, first journal path will be replaced for $2 "
              /usr/bin/mysql -u $mysqlUsr -p$mysqlPwd -e "UPDATE ojs_$2.journals SET path = '$2' WHERE journals.journal_id = 1;"
            fi
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
		        echo "Syntax: ./mojo.sh delete $2 <shortname>"
	            exit 0
	        else
            	echo "Error: You must indicate the sub-action and the magazine's alias."
	            echo "Syntax: ./mojo.sh delete (files|db|all) <shortname>"
	            exit 0
	        fi
        else
            case $2 in
                files)
                    ./mojo.sh deletefiles "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;
                db)
                    ./mojo.sh deletedb "$3" "$4" "$5" "$6" "$7" "$8" "$9"
                ;;
                all)
                    ./mojo.sh deleteall "$3" "$4" "$5" "$6" "$7" "$8" "$9"
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
                *)
                    # Show syntax:
                    ./mojo.sh delete
                ;;
            esac
        fi
    ;;

    deletefiles)
        # ToDo: Protect "base" files and BD
        # ToDo: Ask for confirmation (meanwhile dbpwd request does the job).
        # ToDo: Option to delete without confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        forceDelete=$3

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh deletefiles <shortname> [<forceDelete>]"
            exit 0
        else
            echo "CODE & DATA of magazine [ojs_$2] are going to be REMOVED."

            if [ ! $forceDelete ] ; then
            	confirm "--> Are you sure? [y/N]" && exit 0
            fi

            echo "--> Backup DB before deleting (without checkpoint)."
            ./mojo.sh backup files $2

            rm -Rf $PATHDATA/$2
            rm -Rf $PATHWEB/ojs-$2
            rm -f $PATHTMP/ojs-$2.sql

            # echo "----> htaccess renewed..."
            ./mojo.sh htaccess
            # echo "----> crontab renewed..."
            ./mojo.sh crontab

            echo "Files of magazine $2 are DELETED now!"
        fi
    ;;

    deletedb)
        # ToDo: Ask for confirmation (meanwhile dbpwd request does the job).
        # ToDo: Backup before delete?
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        forceDelete=$3

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh deletedb <shortname> [<forceDelete>]"
            exit 0
        else
            echo "DB of magazine [ojs_$2] is going to be REMOVED."

            if [ ! $forceDelete ] ; then
	            confirm "--> Are you sure? [y/N]" && exit 0
            fi            

            echo "--> Backup DB before deleting (without checkpoint)."
            ./mojo.sh backup db $2

            mkdir -p "$PATHTMP" 

            # Delete BD with "ojs_revistaTag"
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/deleteDB.sql" > $PATHTMP/$2-delete.sql

            # Get MySql root pwd:
            # mysqlPwd=$(getMyPwd)
            # echo ""
            getMyPwd

            /usr/bin/mysql -u $mysqlUsr -p$mysqlPwd < $PATHTMP/$2-delete.sql
            echo "--> Magazine's $2 DB is DELETED now!"
        fi
    ;;

    deleteall)
        # ToDo: Ask for confirmation (meanwhile dbpwd request does the job).
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        forceDelete=$3

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh deleteall <shortname> [<forceDelete>]"
            exit 0
        else
            echo "Magazine [ojs_$2] is going to be FULL REMOVED (code, data and DB)"

            if [ ! $forceDelete ] ; then
	            confirm "--> Are you sure? [y/N]" && exit 0
            fi            

            # echo "----> Files removed..."
            ./mojo.sh deletefiles $2 true
            # echo "----> DB removed..."
            ./mojo.sh deletedb $2 true

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
                    ./mojo.sh backupdb $3 $4
                    ;;
                all)
                    ./mojo.sh backupall $3 $4
                    ;;
                *)
                    # Show syntax:
                    ./mojo.sh backup
                    ;;
            esac
        fi
    ;;
 
    backupdb|bdb)
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ] ; then
            echo "Error: You must indicate the magazine's alias."
            echo "Syntax: ./mojo.sh backupdb <shortname> [<isCheckpoint>]"
            echo "To get a list of every magazine: ./mojo.sh list"
            exit 0
        else
            mkdir -p "$PATHBACKUP/dbs/$2"
            mkdir -p "$PATHBACKUP/all/$2"
            mkdir -p "$PATHTMP"

            # Get MySql root pwd:
            # mysqlPwd=$(getMyPwd)
            # echo ""
            getMyPwd

            # echo "DEBUG: mysqldump -uroot --password=$mysqlPwd ojs_$2 --default-character-set=utf8 > $PATHTMP/ojs-$2.sql"
            mysqldump -u$mysqlUsr --password=$mysqlPwd ojs_$2 --default-character-set=utf8 > $PATHTMP/ojs-$2.sql

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

    backupall|ball)
        # ToDo: Ask for confirmation.
        # ToDo: Argument's validation.
        # ToDo: Error checking.

        if [ "$2" = "" ]
        then
            #echo "Backups a full magazine (db, code and docs)."
            echo "Error:  Wrong number of parameters"
            echo "Syntax: ./mojo.sh backupall <shortname> [<isCheckpoint]"
            exit 0
        else
            echo "Running FULL backup of magazine: $2"

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
            # mysqlPwd=$(getMyPwd)
            # echo ""
            getMyPwd

            mysqldump -u $mysqlUsr --password=$mysqlPwd ojs_$2 --default-character-set=utf8 > $PATHTMP/ojs-$2.sql

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
							rm -Rf $PATHDATA/$3
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
		            # mysqlPwd=$(getMyPwd)
		            # echo ""
		            getMyPwd

		            # Creates the DB named "$3":
		            sed -e "s/%revistaTag%/$3/g" "$PATHBASE/source/templates/createDB.sql" > $PATHTMP/$3-restoredb.sql
		            /usr/bin/mysql -u $mysqlUsr -p$mysqlPwd < $PATHTMP/$3-restoredb.sql

		            # Executes the tarballed dump:
		            # ToDo: Cleanup output.
		            tar -xOvzf $pathDump | mysql -u $mysqlUsr -p$mysqlPwd ojs_$3 
		            echo "Opearation DONE. Check your log."
		            # ToDo:
		            # http://mindspill.net/computing/linux-notes/run-mysql-commands-from-the-bash-command-line/
		            # Should work, but not tested yet:
		            # mysql -uroot -p$mysqlPwd ojs_$3 -e \
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
            # mysqlPwd=$(getMyPwd)
            # echo ""
            getMyPwd

            # Creates the DB named "ojs_revistaTag"
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/createDB.sql" > $PATHTMP/$2-restoredb.sql
            /usr/bin/mysql -u $mysqlUsr -p$mysqlPwd < $PATHTMP/$2-restoredb.sql

            # Executes the tarballed dump:
            # ToDo: Cleanup output.
            tar -xOvzf $pathDump | mysql -u $mysqlUsr -p$mysqlPwd ojs_$2

            echo "The database was RESTORED!"
            # ToDo:
            # http://mindspill.net/computing/linux-notes/run-mysql-commands-from-the-bash-command-line/
            # Should work, but not tested yet:
            # mysql -uroot -p$mysqlPwd ojs_$3 -e \
            #   "UPDATE `ojs_$3`.`journals` SET `path` = '$3' WHERE `journals`.`journal_id` =1 LIMIT 1;"
            #;;
        fi
    ;;

    htaccess)
        #ToDo: Silent mode.

        if [ "$2" != "" ] ; then
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/htaccessMagazine.base" > $PATHWEB/ojs-$2/htaccess.chunk
            if [ $DEBUG == true ] ; then echo "--> Htaccess: Created templated chunk file for magazine: $2" ; fi
        else
            sed -e "s/%TODAY%/$NOW/g" "$PATHBASE/source/templates/htaccess.base" > $PATHWEB/.htaccess
            if [ $DEBUG == true ] ; then echo "Regenerated htaccess header from template htaccess.base" ; fi

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
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/crontabMagazine.base" > $PATHWEB/ojs-$2/cron.chunk
            if [ $DEBUG == true ] ; then echo "--> Crontab: Created chunk file for magazine: $2" ; fi
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
            if [ "$3" != "" ] ; then
                # Links to "current" version
                # Building the SHARED folders (same files between ALL OJS instalations):
                SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

                for x in ${SHARED}
                do
                    if [ $DEBUG == true ] ; then echo "Remove link: ${x} and linking to $3." ; fi
                    rm "$PATHWEB/ojs-$2/${x}"
                    ln -s -f "$PATHBASE/source/versions/$3/${x}" "$PATHWEB/ojs-$2"
                done
                echo "--> R-Link: Recreated all symlinks for magazine $2 (to $3 version)"
            else
                # Relinks to "$3" version
                # Building the SHARED folders (same files between ALL OJS instalations):
                SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

                for x in ${SHARED}
                do
                    if [ $DEBUG == true ] ; then echo "Remove link: ${x} and linking to 'current' version." ; fi
                    rm "$PATHWEB/ojs-$2/${x}"
                    ln -s -f "$PATHMOTOR/${x}" "$PATHWEB/ojs-$2"
                done
                echo "--> r-link: Recreated all symlinks for magazine $2"
            fi
        else
            echo "ERROR: A site alias is required."
            echo "Syntax:  ./mojo.sh r-links site-name [version-folder]"
            echo "Example: ./mojo.sh r-links athenea current"
        fi
    ;;

    link2fold)
        #ToDo: Ask for confirmation.

        if [ "$2" != "" ] ; then
            if [ "$3" != "" ] ; then
                rm "$PATHWEB/ojs-$2/$3"
                cp "$PATHMOTOR/$3" "$PATHWEB/ojs-$2/$3" -a
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
            if [ "$2" == "reset" ] ; then
                # Resets the magazine's config file.
                sed -e "s/%revistaTag%/$3/g" "$PATHBASE/source/templates/config.inc.php.base" > $PATHWEB/ojs-$3/config.inc.php
                sed -i "s!%pathData%!$PATHDATA!g" "$PATHWEB/ojs-$3/config.inc.php"
                echo "--> Reset config.inc.php for magazine $3."
                # Resets htaccess.chunk from base template.
                ./mojo.sh htaccess $3
                ./mojo.sh htaccess
            else
                # Generates the magazine's config file to allow domainName.
                sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/config.inc.php.Domain.base" > $PATHWEB/ojs-$2/config.inc.php
                sed -i "s!%pathData%!$PATHDATA!g" "$PATHWEB/ojs-$2/config.inc.php"
                sed -i "s!%domainName%!$3!g" "$PATHWEB/ojs-$2/config.inc.php"
                echo "--> Recreated new config.inc.php for magazine $2 and domain $3."

                # Generates the domainName htaccess chunk and recreates global htaccess.
                sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/htaccessMagazineDomain.base" > $PATHWEB/ojs-$2/htaccess.chunk
                sed -i "s!%domainName%!$3!g" "$PATHWEB/ojs-$2/htaccess.chunk"
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
        pMagazine="$2"
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
        	case $pSubAction in
        		open)
                    cp -a "$PATHMOTOR/index.php" "$PATHWEB/ojs-$pMagazine/index.php"
					echo "Magazine $pMagazine is now OPEN."
				;;
				lock)
                    if [ "$pMail" = "" ] ; then
                        echo "Error: You must indicate a mail of contact"
                        echo "Syntax:  ./mojo.sh sethome <shortname> lock <mailOfContact>"
                    else
                        sed -e "s/MOJO_MAIL/$pMail/g" "$PATHBASE/source/templates/lock.php" > $PATHTMP/$pMagazine-lock.php
                        cp -a "$PATHTMP/$pMagazine-lock.php" "$PATHWEB/ojs-$pMagazine/index.php"
    					echo "Magazine $pMagazine is now LOCKED."
                    fi
				;;
				work)
                    cp -a "$PATHBASE/source/templates/work.php" "$PATHWEB/ojs-$pMagazine/index.php"
					echo "Magazine $pMagazine is now in MANTAINANCE."
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
            echo "Syntax:  ./mojo.sh tools <shortname> <pkp-tool> "
            echo "Example: ./mojo.sh tools athenea upgrade.php check"
            exit 0
        else
        	cd "$PATHWEB/ojs-$2"
        	php "tools/$3" "$4" "$5" "$6" "$7" "$8" "$9"
        	cd $PATHBASE/scripts
        fi
    ;;

    *)
        ./mojo.sh help
        ;;
esac

# Back to the calling folder:
cd $BACKCD
exit 0
