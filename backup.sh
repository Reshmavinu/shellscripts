#!/bin/bash
src_dir="/opt/log/"
bckup_dir="/var/log/backup"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
bckupname="backup_app$DATE.tar.gz"
mkdir -p "$bckup_dir"
tar -cvf "$bckup_dir/$bckupname" -C "$src_dir" .
if [ $? -eq 0 ]; then
 echo " backup suceeded"
else
 echo "backup failed"
fi
find "/var/log/backup" -type f -name "*.tar.gz" -mtime +1  -exec rm -f {} \;
