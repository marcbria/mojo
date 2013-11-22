#!/bin/bash
rm scripts/.secret
echo "" > logs/access.log
echo "" > logs/error.log

git add .
git commit 
git push origin master

