Write-Host "========================================="
Write-Host " Windows Server Package Installation"
Write-Host "========================================="

$RequiredFeatures = @(
    "Web-Server"
)

foreach ($Feature in $RequiredFeatures) {

    Write-Host ""
    Write-Host "Checking feature: $Feature"

    $InstalledFeature = Get-WindowsFeature -Name $Feature

    if ($InstalledFeature.Installed) {
        Write-Host "$Feature is already installed."
    }
    else {
        Write-Host "$Feature is not installed."
        Write-Host "Installing $Feature..."

        Install-WindowsFeature -Name $Feature -IncludeManagementTools

        Write-Host "$Feature installation completed."
    }

    Write-Host "Verifying $Feature..."

    $Verification = Get-WindowsFeature -Name $Feature

    if ($Verification.Installed) {
        Write-Host "$Feature verification successful."
    }
    else {
        Write-Host "ERROR: $Feature is not installed."
        exit 1
    }
}

Write-Host ""
Write-Host "========================================="
Write-Host " Package Verification Complete"
Write-Host "========================================="