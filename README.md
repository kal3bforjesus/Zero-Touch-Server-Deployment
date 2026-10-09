# Cross-Platform Server Automation (Zero-Touch Deployment)

A configuration-driven automation framework designed to provision, configure, and synchronize Windows and Ubuntu servers without manual intervention. 

## 🚀 Project Overview
Manual server configuration is repetitive and prone to human error. This project eliminates manual typing and interactive prompts by using a **Master Orchestrator** architecture. An administrator simply updates a central configuration file and runs a single script to fully deploy and schedule automated weekly backups.

## ✨ Key Features
- **Zero-Touch Deployment:** No manual IP entry or interactive prompts.
- **Configuration-Driven:** Separates execution logic from environment variables (JSON for Windows, ENV for Linux).
- **Automated Scheduling:** Automatically registers Windows Task Scheduler and Linux Cron for weekly syncs.
- **Cross-Platform Parity:** Maps Linux tools (Bash, SSH, rsync) to Windows equivalents (PowerShell, WinRM, Robocopy).

## ️ Tech Stack
### Windows Server
- PowerShell
- WinRM / PowerShell Remoting
- Robocopy
- Windows Task Scheduler
- IIS / OpenSSH

### Ubuntu Linux
- Bash
- SSH / SSH-Keys
- rsync
- Cron
- Nginx / Netplan

## 📂 Project Structure
```text
├── Windows_Server_Automation/
│   ├── server_config.json      # Admin edits IPs and schedules here
│   ├── Master-Install.ps1      # The Orchestrator script
│   ├── Setup-Windows.ps1       # Installs IIS, SSH
│   ├── configure_winrm.ps1     # Sets up WinRM/TrustedHosts
│   ├── sync_server.ps1         # Robocopy logic
│   └── install_packages.ps1    # Installs Windows Features
│
└── Ubuntu_Server_Automation/
    ├── server_config.env       # Admin edits IPs and schedules here
    ├── master_install.sh       # The Orchestrator script
    ├── setup.sh                # Installs Nginx, SSH, updates
    ├── configure_ssh.sh        # Sets up SSH keys
    ├── sync_server.sh          # rsync logic
    └── install_packages.sh     # Migrates dpkg packages
