# Master-Install.ps1

# 1. Load Configuration
$ConfigPath = Join-Path $PSScriptRoot "server_config.json"
if (-Not (Test-Path $ConfigPath)) {
    Write-Host "ERROR: server_config.json not found in $PSScriptRoot" -ForegroundColor Red
    exit 1
}
$Config = Get-Content $ConfigPath | ConvertFrom-Json

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Unattended Windows Master Installation"
Write-Host " Role: $($Config.Role) | Peer IP: $($Config.SecondaryIP)"
Write-Host "=========================================" -ForegroundColor Cyan

# 2. Run Initial Setup (IIS, SSH, Services)
Write-Host "`n[1/4] Running Initial Windows Setup..." -ForegroundColor Yellow
& "$PSScriptRoot\Setup-Windows.ps1"

# 3. Run WinRM Configuration (Passes Peer IP automatically)
Write-Host "`n[2/4] Configuring WinRM and Remoting..." -ForegroundColor Yellow
& "$PSScriptRoot\configure_winrm.ps1" -PeerIP $Config.SecondaryIP

# 4. Run Package Installation (Installs Windows Features)
Write-Host "`n[3/4] Installing Required Windows Components..." -ForegroundColor Yellow
& "$PSScriptRoot\install_packages.ps1"

# 5. Run Initial Sync & Setup Automated Schedule
Write-Host "`n[4/4] Running Initial Sync and Registering Schedule..." -ForegroundColor Yellow

# Run the sync script once immediately
& "$PSScriptRoot\sync_server.ps1" -DestIP $Config.SecondaryIP

# Register the Windows Task Scheduler to run the sync automatically
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$PSScriptRoot\sync_server.ps1`" -DestIP $($Config.SecondaryIP)"
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $Config.SyncIntervalMinutes)

# Register the task (Force replaces it if it already exists)
Register-ScheduledTask -TaskName "AutomatedServerSync" -Action $Action -Trigger $Trigger -RunLevel Highest -Force

Write-Host "=========================================" -ForegroundColor Green
Write-Host " MASTER INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host " Sync scheduled every $($Config.SyncIntervalMinutes) minutes." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green