#!/bin/bash
DEST_USER=$1
DEST_IP=$2

if [ -z "$DEST_USER" ] || [ -z "$DEST_IP" ]; then
	echo "ERROR: Missing arguments. Usage: ./sync_server.sh <username> <ip>"
	exit 1
fi
echo "========================================================="
echo "Ubuntu Server Synchronization"
echo "========================================================="
echo ""
echo "Starting synchronization to $DEST_USER@$DEST_IP ..."
echo ""

rsync -aAXHv \
--delete \
--rsync-path="rsync" \
--exclude=/proc \
--exclude=/sys \
--exclude=/dev \
--exclude=/run \
--exclude=/tmp \
--exclude=/media \
--exclude=/mnt \
--exclude=/lost+found \
--exclude=/swap.img \
-e ssh \
/ \
${DEST_USER}@${DEST_IP}:/

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ] || [ $EXIT_CODE -eq 23 ]; then
	echo "========================================================"
	echo "Synchronization Complete (or Partial Success)"
	echo "Exit Code: $EXIT_CODE (23 is normal for live systems)"
	echo "======================================================="
else
	echo "========================================================"
	echo "Synchronization Failed."
	echo "Exit code: $EXIT_CODE"
	echo "======================================================="
fi
