#!/bin/bash

umask 077

# 备份目录
BACKUP_DIR="/home/huiyi/mysql-backups"

# 获取当前日期和时间
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 执行数据库备份
BACKUP_FILE="$BACKUP_DIR/ops_lab_$DATE.sql"

if mysqldump ops_lab > "$BACKUP_FILE"; then
    echo "Backup successful: $BACKUP_FILE"
else
    rm -f "$BACKUP_FILE"
    echo "Backup failed!"
    exit 1
fi
