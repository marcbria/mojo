#!/bin/bash

#===============================================================================
#          FILE:    mojo.sh
#
#         USAGE:    ./mojo.sh <action> <magazine-tag>
#
#   DESCRIPTION:    Administers the structure of folders and database for
#                   independent OJS with one preconfigured magazine inside.
#
#    PARAMETERS:
#         <action>: help:       Script syntax.
#                   list:       Lists all the magazines of the service.
#                   create:     (dev) Creates the folder structure of an ojs-magazine.
#                   createdb:   Creates the DB of an ojs-magazine from BASE template.
#                   createall:  Creates a full ojs-magazine from the BASE template.
#                   delete:     Backups and deletes the folder structure of an ojs-magazine.
#                   deletedb:   Deletes the DB of an specific ojs-magazine (ToDo: backup dump).
#                   deleteall:  Deletes the folder structure and DB of an ojs-magazine.
#                   backupdb:   Backups folders and DB of an specific ojs-magazine.
#                   backupall:  Backups scripts, files and db.
#                   restoredb:  (dev) Recovers a formely backup ojs-magazine.
#                   htaccess:   Recreates the global htaccess file.
#                   crontab:    Recreates the global crontab file.
#                   setdomain:  Recreates config files to let the magazine respond under a domain.
#                   r-links:    Recover symlinks for an specific site.
#                   link2fold:  Replaces a symlink with the folder's content.
#                   upgrade:    (ToDo) Replaces "current" links to "new" version links and upgrades ojs
#                               (Equivalent to ./mojo.sh r-links traduccio new)
#
#   <magazine-tag>: Short name of the magazine that will be used as an ID
#                   (folders and DB) and as an URL (pe: magazine01).
#                   The tag ALL is reserved to operate against every magazine
#                   of the system (Not implemented yet).
#
#           <mail>: (optional) Email (without @uab.cat postfix) of the main magazine contact
#                   (Pe: marc.bria)
#
#    <responsible>: (optional) Full name of the magazine's responsible
#                   (Pe: "Marc Bria")
#
#          <title>: (optional) Title of the magazine
#                   (Pe: "Athenea Digital")
#
#       OPTIONS:  ---
#  REQUIREMENTS:  sed, mysqlhotdump (underdev)
#          BUGS:  Parameters are taken in order.
#         NOTES:  ---
#        AUTHOR:  Marc Bria (MBR), marc.bria@uab.cat
#       COMPANY:  UAB - SdP - ReDi
#       CREATED:  06/04/11 16:53:15 CEST
#       UPDATED:  03/07/13 10:32:33 CEST
#      REVISION:  0.20
#===============================================================================

# SCRIPT CONFIGURATION CONSTANTS: ==============================================

# Path of the service root (P.e: /home/ojs)
PATHBASE="/home/ojs"

# Path of the folder with the current version (P.e: $URLBASE/source/versions/current)
PATHMOTOR="$PATHBASE/source/versions/current"

# Build your own aternative bases:
# PATHMOTOR="$PATHBASE/source/versions/ojs-2.4-redi-git-alec"
# PATHMOTOR="$PATHBASE/source/versions/fastrad"

# Working fine:
# PATHMOTOR="$PATHBASE/source/versions/trad24"

# Path of the web root (P.e: $PATHBASE/htdocs)
PATHWEB="$PATHBASE/htdocs"

# Path of the storage folder (P.e: $PATHBASE/webdata)
PATHDATA="$PATHBASE/webdata"

# Base URL for the service (P.e: http://revistes.uab.cat)
# URLBASE="http://revistes.uab.cat"
URLBASE="http://magazine.localhost.net"

# DB dump of the OJS model
DBDUMP="dumpBaseNew.sql"

# Refer your own alternative DB dumps:
# DBDUMP="baseFinal.sql"
# DBDUMP="baseFormacio.sql"
#===============================================================================

NOW="$(date +"%Y%m%d-%M%S")"

# FUNCTIONS: ===================================================================

function getMyPwd()
{
    local mysqlRootPwd
    read -s -p "Enter MYSQL root password: " mysqlRootPwd
    while ! mysql -u root -p$mysqlRootPassword  -e ";" ; do
        read -s -p "Can't connect, please retry: " mysqlRootPwd
    done

    echo $mysqlRootPwd
}
#===============================================================================

# Main: ========================================================================

case $1 in
    help)
        echo "Syntax: ./mojo.sh <action> <shortname> [<contact-mail> [<owner-name> [<magazine-title>]]]"
        echo ""
        echo "        <action>: help:      Script syntax."
        echo "                  list:      Lists all the magazines of the service."
        echo "                  create:    (dev) Creates the folder structure of an ojs-magazine."
        echo "                  createdb:  Creates the DB of an ojs-magazine from BASE template."
        echo "                  createall: Creates a full ojs-magazine from the BASE template."
        echo "                  delete:    Backups and deletes the folder structure of an ojs-magazine."
        echo "                  deletedb:  Deletes the DB of an specific ojs-magazine (ToDo: backup dump)."
        echo "                  deleteall: Deletes the folder structure and DB of an ojs-magazine."
        echo "                  backupdb:  (dev) Backups folders and DB of an specific ojs-magazine."
        echo "                  backupall: Backups scripts, files and db."
        echo "                  restoredb: (dev) Recovers a formely backup ojs-magazine."
#        echo "                  filldb:    (dev) Executes an sql script against the selected ojs-magazine."
        echo "                  htaccess:  Recreates the global htaccess file."
        echo "                  crontab:   Recreates the global crontab file."
        echo "                  r-links:   Recover symlinks for an specific site."
        echo "                  link2fold: Replaces a symlink with the folder's content. BE CAREFULL!!"
        echo "                  setdomain: Recreates config files to let the magazine respond under a domain."
        echo "  <magazine-tag>: Short name of the magazine that will be used as an ID"
        echo "                  (folders and DB) and as an URL (pe: magazine01)."
        echo "                  Comment: The tag ALL is reserved to operate against every magazine"
        echo "                  of the system (Not implemented yet)."
        echo "          <mail>: (opcional) Email prefix (without @uab.cat) of the main magazine contact"
        echo "                  (Pe: marc.bria)"
        echo ""
        echo "Description: ToDo"
        echo "Examples: ToDo"
        echo ""
        echo "Comments: Use single or double quotes if the param include spaces"
        echo ""
        ;;

    list)
        echo "-> List of magazines:"
        # ToDo: Exclude "base" from this list
        ls -1 $PATHWEB | grep ojs | grep -v '-base'
        ;;

    create)
        #ToDo: Ask for confirmation.

        echo "--> Folder structure for magazine: $2"

        # Building the folder structure of the new magazine
        cp -a "$PATHDATA/base/files" "$PATHDATA/$2"    # From the BASE model.
        cp -a "$PATHDATA/base/registry" "$PATHDATA/$2"

        # Uncomment those 2 lines for an independent model.
        # mkdir -p "$PATHDATA/$2/files"                             # Creates the data folder
        # mkdir -p "$PATHDATA/$2/registry"                          #   ... and registry.

        mkdir -p "$PATHWEB/ojs-$2"                                  # Crates the web folder

        cp -a "$PATHMOTOR/index.php" "$PATHWEB/ojs-$2/index.php"    # Comment: A symlink won't work.

        cp -a "$PATHWEB/ojs-base/public" "$PATHWEB/ojs-$2"          # Some predefined public files (pe: banners).

        # Building the structure of NON SHARED folders:
        mkdir -p "$PATHWEB/ojs-$2/cache/t_cache"
        mkdir -p "$PATHWEB/ojs-$2/cache/t_compile"
        mkdir -p "$PATHWEB/ojs-$2/cache/t_config"
        mkdir -p "$PATHWEB/ojs-$2/cache/_db"

        # Building the SHARED folders (same files between ALL OJS instalations):
        SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

        for x in ${SHARED}
        do
            ln -s "$PATHMOTOR/${x}" "$PATHWEB/ojs-$2"
        done

        # Generates the magazine's config file.
        sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/config.inc.php.base" > $PATHWEB/ojs-$2/config.inc.php
        sed -i "s!%pathData%!$PATHDATA!g" "$PATHWEB/ojs-$2/config.inc.php"

        # Creates the htaccess chunk for the magazine (RESTful urls) and recreates the global htaccess.
        ./mojo.sh htaccess $2
        ./mojo.sh htaccess

        # Creates the crontab chunk for the magazine and recreates the global cronMagazine.sh script.
        ./mojo.sh crontab $2
        ./mojo.sh crontab

        # Setting privilegies:
        chown -R ojs:www-data "$PATHDATA/$2"
        chown -R ojs:www-data "$PATHWEB/ojs-$2"
        chmod -R 774 "$PATHDATA/$2"
        chmod -R 775 "$PATHWEB/ojs-$2"
        ;;

    createdb)
        #ToDo: Ask for confirmation.

        echo "--> Creates the BD-OJS named: ojs_$2"

        # Creates the DB named "ojs_revistaTag"
        sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/createDB.sql" > /tmp/$2-create.sql

        # Replaces REDI_REVISTA_TAG tag in the BASE dump:
        sed -e "s/REDI_REVISTA_TAG/$2/g" "$PATHBASE/source/templates/$DBDUMP" > /tmp/$2-fill.sql

        # Replaces REDI_REVISTA_MAIL tag with the specified mail-prefix (REDI_REVISTA_MAIL@uab.cat):
        if [ "$3" ]
        then
        echo "--> Mail: $3"
            sed -i "s/REDI_REVISTA_MAIL/$3/g" /tmp/$2-fill.sql
        fi

        # Replaces REDI_REVISTA_RESPONSABLE with the specified magazine's responsible name:
        if [ "$4" ]
        then
            echo "--> Responsible: $4"
            sed -i "s/REDI_REVISTA_RESPONSABLE/$4/g" /tmp/$2-fill.sql
        fi

        # Replaces REDI_REVISTA_TITLE with the specified magazine's title:
        if [ "$5" ]
        then
            echo "--> Title: $5"
            sed -i "s/REDI_REVISTA_TITLE/$5/g" /tmp/$2-fill.sql
        fi


        cat /tmp/$2-fill.sql >> /tmp/$2-create.sql

        mysqlRootPwd=$(getMyPwd)
        /usr/bin/mysql -u root -p$mysqlRootPwd < /tmp/$2-create.sql
        ;;

    createall)
        #ToDo: Ask for confirmation.

        #if [ "$2" = "" ]
        #then

        echo "-> CREATING MAGAZINE: $2"

        #Nor $@ neither $* are working fine with spaces so let's do it in the old fashion way:
#        if [ $# -le 2 ]
#        then
#            ./mojo.sh createdb $2
#        else
#            if [ $# -le 3 ]
#            then
#                ./mojo.sh createdb $2 "$3"
#            else
#          if [ $# -le 4 ]
#                then
#            ./mojo.sh createdb $2 "$3" "$4"
#                else
#                    ./magazine.sh createdb $2 "$3" "$4" "$5"
#                fi
#            fi
#        fi

        ./mojo.sh createdb $2 "$3" "$4" "$5"
        ./mojo.sh create $2

        echo "New OJS system at $URLBASE/ojs-$2"
        echo "New magazine avaliable at $URLBASE/$2"
        # ToDo: Add task to htaccess.
        # ToDo: Add task to crontab.

    #else
    #    echo "Error: Magazine alias is required."
    #    echo "Try with. ./mojo.sh MagazineShortName"
    #fi
        ;;

    backupall)
        if [ "$2" = "" ]
        then
            echo "Must indicate the magazine's alias."
            echo "Run: ./mojo.sh list to get a list of every magazine"
        else
            echo "Running full backup of magazine: $2"
            mkdir -p "$PATHBASE/backup/all/$2"
            mkdir -p "$PATHBASE/backup/dbs/$2"

            mysqlRootPwd=$(getMyPwd)
            mysqldump -uroot --password=$mysqlRootPwd ojs_$2 --default-character-set=utf8 > /tmp/ojs-$2.sql

            tar cvzf "$PATHBASE/backup/all/$2/$NOW-data.tgz" "$PATHDATA/$2" >> /tmp/$2.log
            tar cvzf "$PATHBASE/backup/all/$2/$NOW-web.tgz" "$PATHWEB/ojs-$2" >> /tmp/$2.log
            # tar cvzfP "$PATHBASE/backup/all/$2/$NOW-db.tgz" "/tmp/ojs-$2.sql" >> /tmp/$2.log
            tar cvzf "$PATHBASE/backup/dbs/$2/$NOW-db.tgz" "/tmp/ojs-$2.sql" >> /tmp/$2.log

            # Magazines' DB dumps are stored in a different folder an symlinked, to facilitate additinal backups.
            ln -s $PATHBASE/backup/dbs/$2/$NOW-db.tgz $PATHBASE/backup/all/$2/$NOW-db.tgz
            rm -f /tmp/ojs-$2.sql

            echo "Destination folders are: "
            echo "$PATHBASE/backup/all/$2"
            echo "$PATHBASE/backup/dbs/$2"
            echo ""
            echo "Backup done!"
        fi
   ;;

   delete)
        #To avoid deleting every file:
        #ToDo: Protect "base" files and BD
        #ToDo: Ask for confirmation.

        if [ "$2" = "" ]
        then
            echo "Must indicate the magazine's alias."
            echo "Run: ./mojo.sh list to get a list of every magazine"
        else
            ./mojo.sh backupall $2

            echo "Deleting magazine: $2"
            rm -Rf $PATHDATA/$2
            rm -Rf $PATHWEB/ojs-$2
            rm -f /tmp/ojs-$2.sql
        fi
        ;;

    deletedb)
        #ToDo: Ask for confirmation.

        echo "--> The OJS database named [ojs_$2] was removed."

        # Crea BD com "ojs_revistaTag"
        sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/deleteDB.sql" > /tmp/$2-delete.sql

        mysqlRootPwd=$(getMyPwd)
        /usr/bin/mysql -u root -p$mysqlRootPwd < /tmp/$2-delete.sql
        ;;

    deleteall)
        #ToDo: Ask for confirmation.

        ./mojo.sh delete $2
        ./mojo.sh deletedb $2
        ;;

    backupdb)
        echo "Usage: ./mojo.sh backupdb <magazineTag>"
        mkdir -p "$PATHBASE/backup/dbs/$2"

        mysqlRootPwd=$(getMyPwd)
        mysqldump -uroot --password=$mysqlRootPwd ojs_$2 --default-character-set=utf8 > /tmp/ojs-$2.sql

        tar cvzf "$PATHBASE/backup/dbs/$2/$NOW-db.tgz" "/tmp/ojs-$2.sql" >> /tmp/$2.log
        ;;

    restoredb)
        #ToDo: Ask for confirmation.

        echo "Usage: ./mojo.sh restoredb </path/to/dbDump.tgz> <dbName>"
        # Improve with:  --default_character_set utf8 ??
        # More info: http://forums.mysql.com/read.php?103,275798,275798

        mysqlRootPwd=$(getMyPwd)
        tar -xOvzf $2 | mysql -uroot -p$mysqlRootPwd ojs_$3

        # ToDo: filldb
        # http://mindspill.net/computing/linux-notes/run-mysql-commands-from-the-bash-command-line/
        # Should work, but not tested yet:
        # mysql -uroot -p$mysqlRootPwd ojs_$3 -e \
        #   "UPDATE `ojs_$3`.`journals` SET `path` = '$3' WHERE `journals`.`journal_id` =1 LIMIT 1;"
        ;;

    htaccess)
        #ToDo: No verbose mode.

        if [ "$2" != "" ]
        then
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/htaccessMagazine.base" > $PATHWEB/ojs-$2/htaccess.chunk
            echo "--> Htaccess: Created templated chunk file for magazine: $2"
        else
            sed -e "s/%TODAY%/$NOW/g" "$PATHBASE/source/templates/htaccess.base" > $PATHWEB/.htaccess
            echo "Regenerated htaccess header from template htaccess.base"

            # for chunk in "$PATHBASE"/ojs-*"
            for chunk in $( find $PATHWEB -maxdepth 1 -type d -name 'ojs-*' )
            do
                cat "$chunk/htaccess.chunk" >> $PATHWEB/.htaccess
                echo "Attached magazine: $chunk"
            done

            chown ojs:www-data $PATHWEB/.htaccess
            chmod 775 $PATHWEB/.htaccess

            echo "--> Htaccess: Recreated global .htaccess file from each magazine's chunks."
        fi
    ;;

    crontab)
        #ToDo: No verbose mode.

        if [ "$2" != "" ]
        then
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/crontabMagazine.base" > $PATHWEB/ojs-$2/cron.chunk
            echo "--> Crontab: Created chunk file for magazine: $2"
        else
            sed -e "s/%TODAY%/$NOW/g" "$PATHBASE/source/templates/crontab.base" > $PATHBASE/cronMagazines.sh

            # for chunk in "$PATHBASE"/ojs-*"
            for chunk in $( find $PATHWEB  -maxdepth 1 -type d -name 'ojs-*' )
            do
                cat "$chunk/cron.chunk" >> $PATHBASE/cronMagazines.sh
            done

            chown ojs:www-data $PATHBASE/cronMagazines.sh
            chmod 775 $PATHBASE/cronMagazines.sh

            echo "--> Crontab: Recreated global cronMagazines.sh script"
        fi
    ;;

    r-links)
        #ToDo: Ask for confirmation.

        if [ "$2" != "" ]
        then
            if [ "$3" != "" ]
            then
                # Links to "current" version
                # Building the SHARED folders (same files between ALL OJS instalations):
                SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

                for x in ${SHARED}
                do
                    echo "Remove link: ${x} and linking to $3."
                    rm "$PATHWEB/ojs-$2/${x}"
                    ln -s "$PATHBASE/source/versions/$3/${x}" "$PATHWEB/ojs-$2"
                done
                echo "--> R-Link: Recreated all symlinks for magazine $2 (to $3 version)"
            else
                # Relinks to "$3" version
                # Building the SHARED folders (same files between ALL OJS instalations):
                SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

                for x in ${SHARED}
                do
                    echo "Remove link: ${x} and linking to 'current' version."
                    rm "$PATHWEB/ojs-$2/${x}"
                    ln -s "$PATHMOTOR/${x}" "$PATHWEB/ojs-$2"
                done
                echo "--> R-Link: Recreated all symlinks for magazine $2"
            fi
        else
            echo "ERROR: A site alias is required."
            echo "Syntax:  ./mojo.sh r-links site-name [version-folder]"
            echo "Example: ./mojo.sh r-links athenea current"
            echo "Help: For more info about the script: ./mojo.sh help".
        fi
        ;;

    link2fold)
        #ToDo: Ask for confirmation.

        if [ "$2" != "" ]
        then
            if [ "$3" != "" ]
            then
                rm "$PATHWEB/ojs-$2/$3"
                cp "$PATHMOTOR/$3" "$PATHWEB/ojs-$2/$3" -a
            else
                echo "ERROR: A folder name is required."
                echo "Syntax:  ./mojo.sh link2fold site-name [ojs-folder]"
                echo "Example: ./mojo.sh link2fold athenea templates"
                echo "Help: For more info about the script: ./mojo.sh help".
            fi
        else
            echo "ERROR: A site alias is required."
            echo "Syntax:  ./mojo.sh link2fold site-name [ojs-folder]"
            echo "Example: ./mojo.sh link2fold athenea templates"
            echo "Help: For more info about the script: ./mojo.sh help".
        fi
        ;;

    setdomain)
        if [ "$2" != "" ]
        then
            if [ "$2" == "reset" ]
            then
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

    *)
        ./mojo.sh help
    ;;
esac
