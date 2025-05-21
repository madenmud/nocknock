#!/bin/bash
# scripts/backup_wallet.sh

BACKUP_DIR=~/nockchain-backup
VOLUME_PATH=/var/lib/docker/volumes/nockchain-wallet/_data
DATE=$(date +%F)

# 백업 디렉토리 생성
mkdir -p $BACKUP_DIR

# tar로 백업
sudo tar -zcvf $BACKUP_DIR/wallet-backup-$DATE.tar.gz -C $VOLUME_PATH .

# 권한 설정
chmod 700 $BACKUP_DIR/wallet-backup-$DATE.tar.gz

echo "Backup completed: $BACKUP_DIR/wallet-backup-$DATE.tar.gz"
