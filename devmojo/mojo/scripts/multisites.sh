#!/bin/sh

#===============================================================================
#          FILE:  multisites.sh
#
#	  USAGE:  ./multisites.sh [help | show | create] [file(.csv)]"
#
#   DESCRIPTION:  Generate multiple sites from a CSV file.
#
#    PARAMETERS:
#         <action>: help:      Script syntax.
#                   show:      Preprocess the CSV file and shows the columns. (CSV param is required)
#                   create:    Processes the CSV file and create the sites. (CSV param is required)
#                   (Pe: "Athenea Digital")
#
#       OPTIONS:  ---
#  REQUIREMENTS:  magazine.sh 
#          BUGS:  Parameters are taken in order.
#         NOTES:  ---
#        AUTHOR:  Marc Bria (MBR), marc.bria@uab.cat
#       COMPANY:  UAB - SdP - ReDi
#       CREATED:  11/04/12 16:26:15 CEST
#      REVISION:  0.5
#===============================================================================

case $1 in
  help)
  echo "Syntax: ./multisites.sh [help | show | create] [file(.csv)]"
  echo "    help:            Show this brief help."
  echo "    show   "file":   Preprocess the CVS file and shows the columns."
  echo "    create "file":   Processes the CVS file and creates the sites."
  echo " "
  echo "Example: ./multisites.sh show 201106"
  echo ""
  ;;
  show)
    while IFS=, read col1 col2 col3 col4 col5 col6
        do
          echo "Nom:      [${col1}]"
          echo "Mail:     [${col2}]"
          echo "Alias:    [${col3}]"
          echo "MailUAB:  [${col4}]"
	  echo "ID:       [${col5}]"
          echo ""
        done < ./cursos/$2.csv
  ;;
  create)
    while IFS=, read col1 col2 col3 col4 col5 col6
	do
	    echo "Creant site $2-${col3} per: ${col1}"
            ./mojo.sh createall $2-${col3} "${col4}" "${col1}" "Revista Num.${col5}"
	done < ./cursos/$2.csv
  ;;
  delete)
    while IFS=, read col1 col2 col3 col4 col5 col6
        do
            echo "Eliminando site $2-${col3} per: ${col1}"
            ./mojo.sh deleteall $2-${col3}
        done < ./cursos/$2.csv
  ;;
  *)
    ./multisites.sh help
esac
