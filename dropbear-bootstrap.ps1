$ErrorActionPreference = 'Stop'

# This is a bootstrapper script which downloads this repo as a zip file and then executes it
#
# Example usage;
# Invoke-WebRequest 'https://raw.githubusercontent.com/glennsarti/puppet-usb-stick/master/dropbear-bootstrap.ps1' | Invoke-Expression
#

if ($PSVersionTable.PSVersion.Major -lt 4) {
  Throw "This script requires PowerShell version 4.0 and above"
  Exit 1
}

Write-Output "Bootstrapping a Drop Bear installation"
Add-Type -AssemblyName System.IO.Compression.FileSystem

$DropBearZIP = Join-Path -Path $ENV:Temp -ChildPath 'dropbear.zip'
$DropBearPath = Join-Path -Path $ENV:Temp -ChildPath 'dropbear-master'

if (-Not (Test-Path -Path $DropBearZIP)) {
  # Use TLS1.2
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $DownloadURL = 'https://github.com/glennsarti/puppet-usb-stick/archive/master.zip'
  $webClient = New-Object System.Net.WebClient;
  Write-Output "Downloading Drop Bear..."
  $webClient.DownloadFile($DownloadURL, $DropBearZIP);
} else { Write-Output "Drop Bear has already been downloaded" }

if (-Not (Test-Path -Path $DropBearPath)) {
  Write-Output "Extracting Drop Bear..."
  [System.IO.Compression.ZipFile]::ExtractToDirectory($DropBearZIP, $DropBearPath)
} else { Write-Output "Drop Bear has already been extracted" }

Write-Output "Locating the Drop Bear..."
$DropBearInit = Get-ChildItem -Path $DropBearPath -Filter 'create-dropbear-stick.ps1' -Recurse -ErrorAction SilentlyContinue -Force | Select-Object -First 1

Write-Output "Poking the Drop Bear..."
& $DropBearInit.Fullname
