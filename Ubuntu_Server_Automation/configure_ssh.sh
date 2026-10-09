#!/bin/bash
DEST_USER=$1
DEST_IP=$2

if [ -z "$DEST_USER" ] || [ -z "$DEST_IP" ]; then
	echo "ERROR: Missing arguments. Usage: ./configure_ssh.sh <username> <ip>"
	exit 1
fi

echo"=============================================="
echo"SSH Configuration Script"
echo"=============================================="
echo""
echo"Checking for an existing key..."

if [ -f ~/.ssh/id_rsa ]; then
	echo "SSH key already exists."
else
	echo "Generating a new SSH key..."
	ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
fi

echo ""
echo "Copying SSH key to $DEST_USER DEST_IP ..."
ssh-copy-id "$DEST_USER@$DEST_IP"

echo ""
echo "Testing SSH connection..."

ssh -o BatchMode=yes "$DEST_USER@$DEST_IP" "echo SSH connection successful."

echo ""
echo "========================================================"
echo "SSH confrguration completed."
echo "========================================================"
