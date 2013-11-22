#!/bin/bash

# Secure data:
rm scripts/.secret
echo "" > logs/access.log
echo "" > logs/error.log

git add . && \
git add -u && \
git commit -m "$(read -p 'Commit description: ')" && \
git push origin master
