#!/bin/bash

SOURCE="/srv/cloud-storage/clients"
DEST="$HOME/cloud-service-provider/backups"
LOG="$HOME/cloud-service-provider/logs/backup.log"

mkdir -p "$DEST" "$(dirname "$LOG")"

STAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE="$DEST/clients_$STAMP.tar.gz"

if tar -czf "$ARCHIVE" -C "$SOURCE" .; then
    if tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
        echo "$(date '+%F %T') SUCCESS $ARCHIVE" >> "$LOG"
        echo "Backup successful: $ARCHIVE"
    else
        echo "$(date '+%F %T') ERROR archive verification failed" >> "$LOG"
        echo "ERROR: Archive verification failed."
        exit 1
    fi
else
    echo "$(date '+%F %T') ERROR backup creation failed" >> "$LOG"
    echo "ERROR: Backup creation failed."
    exit 1
fi
