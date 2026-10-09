#!/bin/bash
# master_install.sh

# 1. Load Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/server_config.env"

echo "========================================================"
echo "Unattended Ubuntu Master Installation"
echo "Role: $ROLE | Peer IP: $SECONDARY_IP"
echo "========================================================"

# 2. Run Initial Setup (Packages, Nginx, SSH services)
echo ""
echo "[1/4] Running Initial Ubuntu Setup..."
bash "$SCRIPT_DIR/setup.sh"

# 3. Run SSH Configuration
echo ""
echo "[2/4] Configuring Passwordless SSH..."
bash "$SCRIPT_DIR/configure_ssh.sh" "$SSH_USER" "$SECONDARY_IP"

# 4. Run Package Migration
echo ""
echo "[3/4] Migrating Installed Packages..."
bash "$SCRIPT_DIR/install_packages.sh" "$SSH_USER" "$SECONDARY_IP"

# Run the sync script once immediately
bash "$SCRIPT_DIR/sync_server.sh" "$SSH_USER" "$SECONDARY_IP"

# Setup Cron Job for automated syncing
echo "Registering Cron job: #SYNC_SCHEDULE"
CRON_JOB="$SYNC_SCHEDULE sudo bash $SCRIPT_DIR/sync_server.sh $SSH_USER $SECONDARY_IP >> ?var/log/server_sync.log 2>&1"

# Remove any old version of this cron job, then add the new one
(sudo cronlab -l 2>/dev/null | grep -v "$SCRIPT_DIR/sync_server.sh"; echo "$CRON_JOB")

echo ""
echo "========================================================"
echo " MASTER INSTALLATION COMPLETE!"
echo " Sync scheduled via Cron: $SYNC_SCHEDULE"
echo " Verify with: sudo crontab -l"
echo "========================================================"
