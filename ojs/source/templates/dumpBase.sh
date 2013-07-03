#!/bin/sh
mysqldump -u root -p ojs_base --default-character-set=utf8 > $1
