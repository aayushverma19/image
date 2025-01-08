#!/bin/bash
#mysql-backup-tool-bucket

read -p "Enter the S3 bucket name: " BUCKET_NAME
read -p "Enter the path to save the backup: " BACKUP_PATH
read -p "Enter the MySQL database username: " DB_USER
read -sp "Enter the MySQL database password: " DB_PASS
echo
read -p "Enter the MySQL database name: " DB_NAME

# MySQL database and gzip the backup
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_PATH.sql
gzip $BACKUP_PATH.sql

# Upload the backup to S3
aws s3 cp $BACKUP_PATH.sql.gz s3://$BUCKET_NAME/backups/

# after cp remove file
rm -rf $BACKUP_PATH.sql.gz

# Verify the backup upload
if [ $? -eq 0 ]; then
  echo "Database backup uploaded to S3 successfully."
else
  echo "Database backup upload to S3 failed."
fi
