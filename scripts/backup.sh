#!/bin/bash
## Use to backup the whole project
##
## By brimonzzy
## Email: zzzy218@foxmail.com
##

cd ..

mkdir -p backup

cur_date=$(date +%Y-%m-%d-%H-%M)
echo $cur_date
prj_folder=$(basename "$PWD")

## check pigz command
if command -v pigz > /dev/null 2>&1; then
  echo "$(pigz -V)"
else
  echo "*** 'pigz' no found, please install 'pigz' ***"
  exit 1
fi

cd ..

tar -cvf - --exclude=backup --exclude=*.fsdb --exclude=*.tar.gz  $prj_folder | pigz --best -k > ${prj_folder}-${cur_date}.tar.gz
mv ${prj_folder}-${cur_date}.tar.gz $prj_folder/backup
