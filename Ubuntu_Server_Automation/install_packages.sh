#!/bin/bash
DEST_USER=$1
DEST_IP=$2

if [ -z "$DEST_USER" ] || [ -z "$DEST_IP" ]; then
	echo"ERROR: Missing arguments. Usage: ./install_packages.sh <username> <ip>"
	exit 1
fi

echo"==========================================================="
echo"Ubuntu Server Package Sychronization"
echo"==========================================================="
echo""
echo"Exporting installed packages..."

dpkg --get-selections > installed_packages.txt

echo "Package list exported."

echo ""
echo "Copying package list to destination server..."

scp installed_packages.txt  "$DEST_USER@$DEST_IP:/tmp/"

echo ""
echo "Installing packages on destination server..."

ssh -t $DEST_USER@$DEST_IP << EOF
sudo apt-get update
sudo dpkg --set-selections < /tmp/installed_packages.txt
sudo apt-get dselect-upgrade -y
EOF

if [ $? -eq 0 ]; then
	echo ""
	echo "==============================================="
	echo "Package Synchmronization Complete"
	echo "==============================================="
fi
