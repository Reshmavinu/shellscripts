#!/bin/bash
src_dir="/opt/log/"
bckup_dir="/var/log/backup"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
bckupname="backup_app$DATE.tar.gz"
mkdir -p "$bckup_dir"
tar -cvzf "$bckup_dir/$bckupname" -C "$src_dir" .
if [ $? -eq 0 ]; then
 echo " backup suceeded"
else
 echo "backup failed"
fi
find "$bckup_dir" -type f -name "*.tar.gz" -mtime +1  -exec rm -f {} \;
######################################################################################################
#!/bin/bash

# Script to back up log files and clean up old backups

set -euo pipefail

# Variables
SRC="/var/log/app"
BACKUP="/var/log/backup"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
LOG_FILE="/var/log/backup_script.log"
RETENTION_DAYS=7

# Ensure backup directory exists
mkdir -p "$BACKUP"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Backup process
log "Starting backup process..."
if tar -czf "$BACKUP/log_backup_$DATE.tar.gz" -C "$SRC" .; then
    log "Backup completed successfully: $BACKUP/log_backup_$DATE.tar.gz"
else
    log "Backup failed!"
    exit 1
fi

# Cleanup old backups
log "Cleaning up backups older than $RETENTION_DAYS days..."
if find "$BACKUP" -type f -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -exec rm -f {} \;; then
    log "Old backups cleaned up successfully."
else
    log "Failed to clean up old backups."
    exit 1
fi

log "Backup script completed successfully."

