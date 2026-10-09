param(
    [Parameter(Mandatory=$true)]
    [string]$PeerIP
)

Write-Host "============================================="
Write-Host " Windows PowerShell Remoting Configuration"
Write-Host "============================================="
Write-Host ""
Write-Host "Enabling PowerShell Remoting..."
Enable-PSRemoting -Force

Write-Host ""
Write-Host "Configuring Windows Firewall..."
Enable-NetFirewallRule -DisplayGroup "Windows Remote Management"

Write-Host ""
Write-Host "Configuring TrustedHosts to: $PeerIP ..."
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $PeerIP -Force

Write-Host ""
Write-Host "Checking WinRM service..."
Get-Service WinRM

Write-Host ""
Write-Host "Testing WinRM connectivity to $PeerIP ..."
Test-WSMan $PeerIP

Write-Host ""
Write-Host "============================================="
Write-Host " WinRM configuration completed successfully"
Write-Host "============================================="