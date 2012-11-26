#!/bin/sh

TMPPWD="myRealPwdToBeAnonymized"
NEWPWD="myPassword"

TMPURL="magazines.localhost.net"
NEWURL="magazine.localhost.net"

echo "./release.sh v0.2 --> generates: ../multiojs-v0.2.tgz"

# ./replaceVar.sh config.* $TMPPWD $NEWPWD
./replaceVar.sh config.* $TMPURL $NEWURL

mv ../multiojs-$1.tgz ../multiojs-$1.tgz.bck
# MBR: Tar with --dereference' (`-h') to package symlinks content.
tar chvzf ../multiojs-$1.tgz . --ignore-failed-read
