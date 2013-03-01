#!/bin/bash 

#===============================================================================
#          FILE:  mojo.sh
# 
#         USAGE:  ./mojo.sh <action> <magazine-tag>
# 
#   DESCRIPTION:  Administers the structure of folders and database for
#                 independent OJS with one preconfigured magazine inside.
# 
#    PARAMETERS: 
#         <action>: help:      Script syntax.
#                   list:      Lists all the magazines of the service.
#                   createall: Creates a full ojs-magazine from the BASE template.
#                   deleteall: Deletes the folder structure and DB of an ojs-magazine.
#                   createdb:  Creates the DB of an ojs-magazine from BASE template.
#                   deletedb:  Deletes the DB of an specific ojs-magazine (ToDo: backup dump).
#                   filldb:    (dev) Executes an sql script against the selected ojs-magazine.
#                   create:    (dev) Creates the folder structure of an ojs-magazine.
#                   delete:    Backups and deletes the folder structure of an ojs-magazine.
#                   backup:    (dev) Backups folders and DB of an specific ojs-magazine.
#                   restore:   (dev) Recovers a formely backup ojs-magazine.
#                   htaccess:  Recreates the global htaccess file.
#                   crontab:   Recreates the global crontab file.
#                   setdomain: Recreates config files to let the magazine respond under a domain.
#                   r-links:   Recover symlinks for an specific site.
#                   link2fold: Replaces a symlink with the folder's content.
#                   upgrade:   Todo: Replaces "current" links to "new" version links and upgrades ojs
#                              (Equivalent to ./mojo.sh r-links traduccio new)
#
#   <magazine-tag>: Short name of the magazine that will be used as an ID 
#                   (folders and DB) and as an URL (pe: magazine01).
#                   The tag ALL is reserved to operate against every magazine
#                   of the system (Not implemented yet).
#
#           <mail>: (optional) Email (without @uab.cat postfix) of the main magazine contact
#                   (Pe: john.doe)
#
#    <responsible>: (optional) Full name of the magazine's responsible
#                   (Pe: "John Doe")
#
#          <title>: (optional) Title of the magazine
#                   (Pe: "Athenea Digital")
#
#       OPTIONS:  ---
#  REQUIREMENTS:  sed, mysqlhotdump (underdev)
#          BUGS:  Parameters are taken in order.
#         NOTES:  ---
#        AUTHOR:  Marc Bria (MBR), marc.bria[add]uab.cat
#       COMPANY:  UAB - SdP - ReDi
#       CREATED:  06/04/11 16:53:15 CEST
#       UPDATED:  08/10/12 19:30:18 CEST
#      REVISION:  0.18
#===============================================================================

# SCRIPT CONFIGURATION CONSTANTS: ==============================================

MYSQLPWD="qbMwkHT6"

# Path of the service root (P.e: /home/ojs)
PATHBASE="/home/ojs"

# Path of the folder with the current version (P.e: $URLBASE/source/versions/current)
PATHMOTOR="$PATHBASE/source/versions/current"
# PATHMOTOR="$PATHBASE/source/versions/trad"

# Path of the web root (P.e: $PATHBASE/htdocs)
PATHWEB="$PATHBASE/htdocs"

# Path of the storage folder (P.e: $PATHBASE/webdata)
PATHDATA="$PATHBASE/webdata"

# Base URL for the service (P.e: http://revistes.uab.cat)
URLBASE="http://ojs.projecteictineo.com"

# DB dump of the OJS model
# DBDUMP="baseFinal.sql"
# DBDUMP="baseFormacio.sql"
DBDUMP="dumpBaseNew.sql"
#===============================================================================

TODAY="$(date +"%Y%m%d")"

case $1 in
    help)
        echo "Syntax: ./mojo.sh <action> <shortname> [<contact-mail> [<owner-name> [<magazine-title>]]]"
        echo ""

        echo "        <action>: help:      Script syntax."
        echo "                  list:      Lists all the magazines of the service."
        echo "                  createall: Creates a full ojs-magazine from the BASE template."
        echo "                  deleteall: Deletes the folder structure and DB of an ojs-magazine."
        echo "                  createdb:  Creates the DB of an ojs-magazine from BASE template."
        echo "                  deletedb:  Deletes the DB of an specific ojs-magazine (ToDo: backup dump)."
#        echo "                  filldb:    (dev) Executes an sql script against the selected ojs-magazine."
#        echo "                  create:    (dev) Creates the folder structure of an ojs-magazine."
        echo "                  delete:    Backups and deletes the folder structure of an ojs-magazine."
#        echo "                  backup:    (dev) Backups folders and DB of an specific ojs-magazine."
#        echo "                  restore:   (dev) Recovers a formely backup ojs-magazine."
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
        ls -1 $PATHWEB | grep ojs
        ;;

    create)
        echo "--> Folder structure for magazine: $2"

        # Building the folder structure of the new magazine
        cp -a "$PATHDATA/base/files" "$PATHDATA/$2"	# From the BASE model.
        cp -a "$PATHDATA/base/registry" "$PATHDATA/$2"

        # Uncomment those 2 lines for an independent model.
        # mkdir -p "$PATHDATA/$2/files"                         # Creates the data folder
        # mkdir -p "$PATHDATA/$2/registry"                      #   ... and registry.

        mkdir -p "$PATHWEB/ojs-$2"		    		# Crates the web folder

        cp -a "$PATHMOTOR/index.php" "$PATHWEB/ojs-$2/index.php"	# Comment: A symlink won't work.

        cp -a "$PATHWEB/ojs-base/public" "$PATHWEB/ojs-$2"		# Some predefined public files (pe: banners).

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

        /usr/bin/mysql -u root --password=$MYSQLPWD < /tmp/$2-create.sql
        ;;

    createall)
        #if [ "$2" = "" ]
        #then
	        echo "-> CREATING MAGAZINE: $2"

		#Nor $@ neither $* are working fine with spaces so let's do it in the old fashion way:
#		if [ $# -le 2 ]
#		then
#	        ./mojo.sh createdb $2
#		else
#			if [ $# -le 3 ]
#			then
#				./mojo.sh createdb $2 "$3"
#			else
#		                if [ $# -le 4 ]
#				then
#		                        ./mojo.sh createdb $2 "$3" "$4"
#				else
#					./mojo.sh createdb $2 "$3" "$4" "$5"
#				fi
#			fi
#		fi

	        ./mojo.sh createdb $2 "$3" "$4" "$5"
	        ./mojo.sh create $2 

		echo "New OJS system at $URLBASE/ojs-$2"
		echo "New magazine avaliable at $URLBASE/$2"
		# ToDo: Add task to htaccess.
		# ToDo: Add task to crontab.
	#else
	#	echo "Error: Magazine alias is required."
	#	echo "Try with. ./mojo.sh MagazineShortName"
	#fi
        ;;

    delete)
        #To avoid deleting every file:

	#ToDo: Protect "base" files and BD

        if [ "$2" = "" ]
        then
            echo "Must indicate the magazine's alias."
            echo "Run: ./magazine list to get a list of every magazine"
        else
            echo "Deleting magazine: $2"
            mkdir "$PATHBASE/backup/$2"

            mysqldump -uroot --password=$MYSQLPWD ojs_$2 --default-character-set=utf8 > /tmp/ojs-$2.sql

            tar cvzfP "$PATHBASE/backup/$2/$TODAY-data.tgz" "$PATHDATA/$2" >> /tmp/$2.log
            tar cvzfP "$PATHBASE/backup/$2/$TODAY-web.tgz" "$PATHWEB/ojs-$2" >> /tmp/$2.log
            tar cvzfP "$PATHBASE/backup/$2/$TODAY-db.tgz" "/tmp/ojs-$2.sql" >> /tmp/$2.log

            rm -Rf $PATHDATA/$2
            rm -Rf $PATHWEB/ojs-$2
            rm -f /tmp/ojs-$2.sql
        fi
        ;;

    deletedb)
        echo "--> The OJS database named [ojs_$2] was removed."

        # Crea BD com "ojs_revistaTag"
        sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/deleteDB.sql" > /tmp/$2-delete.sql

        /usr/bin/mysql -u root --password=$MYSQLPWD < /tmp/$2-delete.sql
        ;;

    deleteall)
        ./mojo.sh delete $2
        ./mojo.sh deletedb $2
        ;;

    htaccess)
        if [ "$2" != "" ]
        then
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/htaccessMagazine.base" > $PATHWEB/ojs-$2/htaccess.chunk
            echo "--> Htaccess: Created chunk file for magazine: $2"
	else
	    sed -e "s/%TODAY%/$TODAY/g" "$PATHBASE/source/templates/htaccess.base" > $PATHWEB/.htaccess
            echo "Regenerated htaccess header from template htaccess.base"

            # for chunk in "$PATHBASE"/ojs-*"
            for chunk in $( find $PATHWEB -type d -name 'ojs-*' )
            do
                cat "$chunk/htaccess.chunk" >> $PATHWEB/.htaccess
                echo "Attached magazine: $chunk"
            done

            chown ojs:www-data $PATHWEB/.htaccess
            chmod 775 $PATHWEB/.htaccess

            echo "--> Htaccess: Recreated global .htaccess file from magazine's chunks."
	fi
	;;

    crontab)
        if [ "$2" != "" ]
        then
            sed -e "s/%revistaTag%/$2/g" "$PATHBASE/source/templates/crontabMagazine.base" > $PATHWEB/ojs-$2/cron.chunk
            echo "--> Crontab: Created chunk file for magazine: $2"
	else
            sed -e "s/%TODAY%/$TODAY/g" "$PATHBASE/source/templates/crontab.base" > $PATHBASE/cronMagazines.sh

	    # for chunk in "$PATHBASE"/ojs-*"
	    for chunk in $( find $PATHWEB -type d -name 'ojs-*' )
	    do
	        cat "$chunk/cron.chunk" >> $PATHBASE/cronMagazines.sh
	    done

	    chown ojs:www-data $PATHBASE/cronMagazines.sh
	    chmod 775 $PATHBASE/cronMagazines.sh

	    echo "--> Crontab: Recreated global cronMagazines.sh script"
	fi
	;;

    r-links)
        if [ "$2" != "" ]
        then
	    if [ "$3" != "" ]
            then		# Links to "current" version
                # Building the SHARED folders (same files between ALL OJS instalations):
                SHARED="dbscripts help js locale plugins styles classes controllers docs lib pages rt templates tools"

                for x in ${SHARED}
                do
                    echo "Remove link: ${x} and linking to $3."
                    rm "$PATHWEB/ojs-$2/${x}" 
                    ln -s "$PATHBASE/source/versions/$3/${x}" "$PATHWEB/ojs-$2"
                done
                echo "--> R-Link: Recreated all symlinks for magazine $2 (to $3 version)"
	    else 		# Relinks to "$3" version
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
        if [ "$2" != "" ]
        then
            if [ "$3" != "" ]
            then
                rm "$PATHWEB/ojs-$2/$3"
                cp "$PATHMOTOR/$3" "$PATHWEB/ojs-$2/$3" -a
	    else
                echo "ERROR: A folder name is required."
                echo "Example: ./mojo.sh link2fold site-name [ojs-folder]"
                echo "Help: For more info about the script: ./mojo.sh help".
            fi    
        else
            echo "ERROR: A site alias is required."
            echo "Example: ./mojo.sh link2fold site-name [ojs-folder]"
            echo "Help: For more info about the script: ./mojo.sh help".
        fi
        ;;

    setdomain)
        if [ "$2" != "" ]
        then
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
        else
            echo "Syntax Error:"
            echo "Magazine's tag and full domain name must be specified as parameters."
            echo "Try with: ./mojo.sh setdomain magazineName www.yourdomain.com"
        fi
	;;

    *)
        ./mojo.sh help
	;;
esac
