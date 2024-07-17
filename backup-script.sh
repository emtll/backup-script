#!/bin/bash

# Prerequisites:
# - rsync
# - inotify-tools

# Directories for backup (Update these to match your setup)
DIR_LNBITS="/path/to/lnbits/data"
DIR_CASHU="/path/to/cashu/data/mint/"

# Directories for monitoring database changes (Update these to match your setup)
DIR_LNBITSDATA="/path/to/lnbits/data"
DIR_CASHUDATA="/path/to/cashu/data"

# Local and remote destination directories (Update these to match your setup)
DIR_BACKUP_LOCAL_LNBITS="/path/to/local/backups/lnbits"
DIR_BACKUP_LOCAL_CASHU="/path/to/local/backups/cashu"
DIR_BACKUP_REMOTE_LNBITS="user@remote.server:/path/to/remote/backups/lnbits"
DIR_BACKUP_REMOTE_CASHU="user@remote.server:/path/to/remote/backups/cashu"

# Destination directory names (Optional: Update if desired)
DIRNAME_LNBITS="lnbits-backup"
DIRNAME_CASHU="cashu-backup"

# Backup function
backup() {
    rsync -av --delete --update "$DIR_LNBITS" "$DIR_BACKUP_LOCAL_LNBITS/$DIRNAME_LNBITS"
    rsync -av --delete --update "$DIR_CASHU" "$DIR_BACKUP_LOCAL_CASHU/$DIRNAME_CASHU"

    rsync -av --delete --update "$DIR_LNBITS" "$DIR_BACKUP_REMOTE_LNBITS/$DIRNAME_LNBITS"
    rsync -av --delete --update "$DIR_CASHU" "$DIR_BACKUP_REMOTE_CASHU/$DIRNAME_CASHU"

    if [ $? -eq 0 ]; then
        echo "Backup successfully completed on $(date)"
    else
        echo "Error performing backup on $(date)"
    fi
}

# Minimum time between backups (in seconds)
MIN_INTERVAL=30
LAST_RUN=0

# Monitor directory changes and execute backup
inotifywait -m -r -e modify,create,delete,move "$DIR_LNBITSDATA" "$DIR_CASHUDATA" | while read path action file; do
    NOW=$(date +%s)
    if (( NOW - LAST_RUN > MIN_INTERVAL )); then
        echo "Detected change in $path$file due to $action"
        backup
        LAST_RUN=$NOW
    fi
done
