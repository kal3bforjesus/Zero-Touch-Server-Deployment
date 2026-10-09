#!/bin/bash

echo "=============================================="
echo " Ubuntu Server Initial Setup "
echo "=============================================="

echo ""
echo " Updating package list... "
sudo apt update

echo ""
echo "Checking and Installing required packages..."

packages=(
 	openssh-server
 	rsync
 	nginx
 	curl
 	git
)

for package in "${packages[@]}"; do
	if dpkgv -l | grep -q "^ii $package"; then
		echo "$package is already installed."
	else
		echo " Installing $package..."
		sudo apt install -y "$package"
	fi
done

echo ""
echo "Starting SSH service..."
sudo systemctl enable ssh
sudo systemctl start ssh

echo ""
echo "Starting Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo ""
echo "Checking installed services..."
systemctl is-active ssh
systemctl is-active nginx

echo ""
echo "============================================"
echo "Setup completed successfully."
echo "============================================"
