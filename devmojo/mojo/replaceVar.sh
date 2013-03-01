#!/bin/bash

# Syntax: ./replaceVar.sh <Var> <valorActual> <valorDeseado>
# Example: ./replaceVar.sh require_validation Off On

FILENAME="$1"
OLDVALUE="$2"
NEWVALUE="$3"


echo "==========================="
echo "OPERATION:"
echo "  File: $FILENAME"
echo "  Old Value: $OLDVALUE";
echo "  New Value: $NEWVALUE";
echo "---------------------------"
# echo "OLD VARS:"
grep "$OLDVALUE" * -R | grep $FILENAME 
perl -pi -e 's/'"$OLDVALUE"'/'"$NEWVALUE"'/g' `find ./ -name $FILENAME`
# echo "---------------------------"
# echo "NEW VARS:"
# grep "$NEWVALUE" * -R | grep config.inc.php
echo "==========================="
