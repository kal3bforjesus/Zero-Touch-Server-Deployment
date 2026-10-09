param(
    [Parameter(Mandatory=$true)]
    [string]$DestIP
)

Write-Host "========================================="
Write-Host " Windows Server Synchronization"
Write-Host "========================================="
Write-Host ""
Write-Host "Destination Server: $DestIP"

# =========================================
# 1. IIS Website Synchronization
# =========================================
$SourcePath = "C:\inetpub\wwwroot"
$DestinationPath = "\\$DestIP\C$\inetpub\wwwroot"

Write-Host ""
Write-Host "-----------------------------------------"
Write-Host "Source:      $SourcePath"
Write-Host "Destination: $DestinationPath"
Write-Host "-----------------------------------------"
Write-Host "Starting synchronization..."

robocopy $SourcePath $DestinationPath /E /COPY:DAT /R:3 /W:5
$RobocopyExitCode = $LASTEXITCODE

if ($RobocopyExitCode -le 7) {
    Write-Host "Synchronization successful. (Exit Code: $RobocopyExitCode)" -ForegroundColor Green
} else {
    Write-Host "Synchronization failed. (Exit Code: $RobocopyExitCode)" -ForegroundColor Red
}

# =========================================
# 2. Server Automation Synchronization
# =========================================
$SourcePath = "C:\ServerAutomation"
$DestinationPath = "\\$DestIP\C$\ServerAutomation"

Write-Host ""
Write-Host "-----------------------------------------"
Write-Host "Source:      $SourcePath"
Write-Host "Destination: $DestinationPath"
Write-Host "-----------------------------------------"
Write-Host "Starting synchronization..."

robocopy $SourcePath $DestinationPath /E /COPY:DAT /R:3 /W:5
$RobocopyExitCode = $LASTEXITCODE

if ($RobocopyExitCode -le 7) {
    Write-Host "Synchronization successful. (Exit Code: $RobocopyExitCode)" -ForegroundColor Green
} else {
    Write-Host "Synchronization failed. (Exit Code: $RobocopyExitCode)" -ForegroundColor Red
}

# =========================================
# 3. Public User Data Synchronization
# =========================================
$SourcePath = "C:\Users\Public"
$DestinationPath = "\\$DestIP\C$\Users\Public"

Write-Host ""
Write-Host "-----------------------------------------"
Write-Host "Source:      $SourcePath"
Write-Host "Destination: $DestinationPath"
Write-Host "-----------------------------------------"
Write-Host "Starting synchronization..."

robocopy $SourcePath $DestinationPath /E /COPY:DAT /R:3 /W:5
$RobocopyExitCode = $LASTEXITCODE

if ($RobocopyExitCode -le 7) {
    Write-Host "Synchronization successful. (Exit Code: $RobocopyExitCode)" -ForegroundColor Green
} else {
    Write-Host "Synchronization failed. (Exit Code: $RobocopyExitCode)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================="
Write-Host " Synchronization Complete"
Write-Host "========================================="