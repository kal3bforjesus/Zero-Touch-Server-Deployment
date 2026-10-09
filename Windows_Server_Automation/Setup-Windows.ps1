# ==========================================
# Windows Server Initial Setup
# ==========================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Windows Server Initial Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Checking administrator privileges..." -ForegroundColor Yellow

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    Write-Host "ERROR: Please run PowerShell as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Administrator privileges confirmed." -ForegroundColor Green


# ==========================================
# Install OpenSSH Server
# ==========================================

Write-Host ""
Write-Host "Checking OpenSSH Server..." -ForegroundColor Yellow

$sshCapability = Get-WindowsCapability -Online |
    Where-Object Name -like 'OpenSSH.Server*'

if ($sshCapability.State -eq "Installed") {

    Write-Host "OpenSSH Server is already installed." -ForegroundColor Green

}
else {

    Write-Host "Installing OpenSSH Server..." -ForegroundColor Yellow

    Add-WindowsCapability -Online -Name $sshCapability.Name

    Write-Host "OpenSSH Server installation completed." -ForegroundColor Green
}


# ==========================================
# Configure OpenSSH Server
# ==========================================

Write-Host ""
Write-Host "Configuring SSH service..." -ForegroundColor Yellow

Set-Service -Name sshd -StartupType Automatic

Start-Service -Name sshd

Write-Host "SSH service started successfully." -ForegroundColor Green


# ==========================================
# Install IIS
# ==========================================

Write-Host ""
Write-Host "Checking IIS..." -ForegroundColor Yellow

$iisFeature = Get-WindowsFeature -Name Web-Server

if ($iisFeature.Installed) {

    Write-Host "IIS is already installed." -ForegroundColor Green

}
else {

    Write-Host "Installing IIS..." -ForegroundColor Yellow

    Install-WindowsFeature -Name Web-Server -IncludeManagementTools

    Write-Host "IIS installation completed." -ForegroundColor Green
}


# ==========================================
# Configure IIS
# ==========================================

Write-Host ""
Write-Host "Configuring IIS service..." -ForegroundColor Yellow

Set-Service -Name W3SVC -StartupType Automatic

Start-Service -Name W3SVC

Write-Host "IIS service started successfully." -ForegroundColor Green


# ==========================================
# Verify Services
# ==========================================

Write-Host ""
Write-Host "Checking installed services..." -ForegroundColor Yellow

$sshStatus = Get-Service -Name sshd
$iisStatus = Get-Service -Name W3SVC

Write-Host ""
Write-Host "OpenSSH Server: $($sshStatus.Status)" -ForegroundColor Cyan
Write-Host "IIS:            $($iisStatus.Status)" -ForegroundColor Cyan


# ==========================================
# Final Result
# ==========================================

if (
    $sshStatus.Status -eq "Running" -and
    $iisStatus.Status -eq "Running"
) {

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host " Setup completed successfully." -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green

}
else {

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Red
    Write-Host " Setup completed with service errors." -ForegroundColor Red
    Write-Host "==========================================" -ForegroundColor Red
}