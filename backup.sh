#!/bin/bash

# MySQL credentials
USER="root"
PASSWORD="L@E9p[Kc=~Ev2tQ+"
HOST="localhost"

# Backup directory
BACKUP_DIR="/Users/jofreynyamasheki/Downloads/BackupLocalDB"

# List of databases
DATABASES=(
    "xpawa_accountsdb"
    "xpawa_auxiliarydb"
    "xpawa_communicationsdb"
    "xpawa_kycdb"
    "xpawa_lmsdb"
    "xpawa_marketing_db"
    "xpawa_reportsdb"
    "xpawa_searchdb"
    "xpawa_svmsdb"
)

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Check if the backup directory was created successfully
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory could not be created at $BACKUP_DIR"
    exit 1
fi

# Backup each database
for DB in "${DATABASES[@]}"; do
    BACKUP_FILE="$BACKUP_DIR/${DB}_backup_$(date +%F_%H-%M-%S).sql"
    echo "Backing up $DB to $BACKUP_FILE..."

    # Run mysqldump inside the MySQL container
    docker exec mysql mysqldump -u $USER -p$PASSWORD -h $HOST $DB > $BACKUP_FILE

    # Check if the backup was successful
    if [ $? -eq 0 ]; then
        echo "Backup of $DB completed successfully!"
    else
        echo "Error: Backup of $DB failed!"
    fi
done

echo "All backups completed!"
