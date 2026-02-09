#!/bin/bash

# Stop script if any command fails
set -e

# -------------------------
# Read input parameters
# -------------------------
BACKUP_PATH="$1"
RETENTION_DAYS="$2"

# -------------------------
# Validate inputs
# -------------------------
if [ -z "$BACKUP_PATH" ] || [ -z "$RETENTION_DAYS" ]; then
  echo "ERROR: Missing arguments"
  echo "Usage: ./backup.sh <backup_path> <retention_days>"
  exit 1
fi

if [ ! -d "$BACKUP_PATH" ]; then
  echo "ERROR: Backup path does not exist: $BACKUP_PATH"
  exit 1
fi

# -------------------------
# Backup configuration
# -------------------------
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"

# -------------------------
# Create backup directory
# -------------------------
mkdir -p "$BACKUP_DIR"

# -------------------------
# Create compressed archive
# -------------------------
echo "Creating backup..."
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$BACKUP_PATH"

echo "Backup created: $BACKUP_DIR/$ARCHIVE_NAME"

# -------------------------
# Cleanup old backups
# -------------------------
echo "Cleaning backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -delete

echo "Backup completed successfully"
