[CmdletBinding()]
param()

$scoopRoot = 'D:\Home\scoop'
$scoopShims = Join-Path $scoopRoot 'shims'

New-Item -ItemType Directory -Path $scoopRoot -Force | Out-Null
$env:SCOOP = $scoopRoot
[Environment]::SetEnvironmentVariable('SCOOP', $scoopRoot, 'User')

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
  Write-Host "Installed Scoop in: $scoopRoot"
}
else {
  Write-Host "Scoop is already available: $((Get-Command scoop).Source)"
}

if ((Test-Path $scoopShims) -and (($env:Path -split [IO.Path]::PathSeparator) -notcontains $scoopShims)) {
  $env:Path = "$scoopShims$([IO.Path]::PathSeparator)$env:Path"
}

$sourceProfile = Join-Path $PSScriptRoot 'Microsoft.PowerShell_profile.ps1'
$destinationProfile = $PROFILE.CurrentUserCurrentHost
$profileDirectory = Split-Path -Parent $destinationProfile

New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null

if (Test-Path $destinationProfile) {
  $existingProfile = Get-Content -Path $destinationProfile -Raw
  $newProfile = Get-Content -Path $sourceProfile -Raw

  if ($existingProfile -eq $newProfile) {
    Write-Host "PowerShell profile is already current: $destinationProfile"
    exit 0
  }

  $backupProfile = "$destinationProfile.backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
  Copy-Item -Path $destinationProfile -Destination $backupProfile
  Write-Host "Backed up existing profile to: $backupProfile"
}

Copy-Item -Path $sourceProfile -Destination $destinationProfile -Force
Write-Host "Installed PowerShell profile to: $destinationProfile"
