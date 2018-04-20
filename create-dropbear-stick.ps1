param($TargetDir = "")

$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -lt 4) {
  Throw "This script requires PowerShell version 4.0 and above"
  Exit 1
}

if (($TargetDir -eq $null) -or ($TargetDir -eq "")) {
  Add-Type -AssemblyName System.Windows.Forms
  $SaveChooser = New-Object -Typename System.Windows.Forms.FolderBrowserDialog
  $SaveChooser.Description = "Save Drop Bear to ..."
  if ($SaveChooser.ShowDialog() -ne "OK") {
    Throw "Drop Bear needs a target location"
    Exit 1
  }
  $TargetDir = $SaveChooser.SelectedPath
}

if (-Not (Test-Path -Path $TargetDir)) {
  Throw "Drop Bear target of $TargetDir does not exist"
  Exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$DownloadDir = Join-Path -Path $TargetDir -ChildPath 'downloads'

$VSCodeExtensions = @(
  @{ 'publisher' = 'jpogran'; 'name' = 'puppet-vscode'; 'vsix' = 'jpogran-puppet-vscode'}
  @{ 'publisher' = 'ms-vscode'; 'name' = 'PowerShell'; 'vsix' = 'ms-vscode-PowerShell'}
)

# Use TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Function Invoke-DirExists($Root, $Filter) {
  $result = $null
  if (Test-Path -Path $Root) {
   $result = (Get-ChildItem -Path $Root | Where-Object { $_.Name -like $Filter })
  }
  if ($result -eq $null) {
    Write-Output $false
  } else {
    Write-Output $true
  }
}

Write-Output "Initialising..."
Write-Output "Target directory is $TargetDir"
Write-Output "Download directory is $DownloadDir"
if (-Not (Test-Path -Path $DownloadDir)) { New-Item -ItemType Directory -Path $DownloadDir | Out-Null }
if (-Not (Test-Path -Path $TargetDir)) { New-Item -ItemType Directory -Path $TargetDir | Out-Null }

#---------------
# Gather installers
#---------------

# VSCODE
$VSCodeZIP = Join-Path -Path $DownloadDir -ChildPath 'VSCode.zip'
if (-Not (Test-Path -Path $VSCodeZIP)) {
  Write-Output "Getting VS Code..."
  Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?Linkid=850641' -OutFile $VSCodeZIP
} else { Write-Output "Getting VS Code (SKIPPED) ..." }

# VSCODE EXTENSIONS
$VSCodeExtensions | ForEach-Object {
  $item = $_
  $URI = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$($item.publisher)/vsextensions/$($item.name)/latest/vspackage"
  $OutFile = Join-Path -Path $DownloadDir -ChildPath ($item.vsix + '.vsix')

  if (-Not (Test-Path -Path $OutFile)) {
    Write-Output "Getting VS Code Extension $($item.vsix) ..."
    Invoke-WebRequest -Uri $URI -OutFile $OutFile
  } else {   Write-Output "Getting VS Code Extension $($item.vsix) (SKIPPED) ..." }
}

# PUPPET AGENT
$PuppetMSI = Join-Path -Path $DownloadDir -ChildPath 'puppet-agent-x64.msi'
if (-Not (Test-Path -Path $PuppetMSI)) {
  Write-Output "Getting Puppet Agent..."
  Invoke-WebRequest -Uri 'http://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi' -OutFile $PuppetMSI
} else { Write-Output "Getting Puppet Agent (SKIPPED) ..." }

# PDK
$PDKMSI = Join-Path -Path $DownloadDir -ChildPath 'pdk-x64.msi'
if (-Not (Test-Path -Path $PDKMSI)) {
  Write-Output "Getting PDK..."
  Invoke-WebRequest -Uri 'http://downloads.puppetlabs.com/windows/pdk-1.4.1.2-x64.msi' -OutFile $PDKMSI
} else { Write-Output "Getting PDK (SKIPPED) ..." }

# PE CLIENT TOOLS
$PECTMSI = Join-Path -Path $DownloadDir -ChildPath 'pe-client-tools-x64.msi'
if (-Not (Test-Path -Path $PECTMSI)) {
  Write-Output "Getting PE Client Tools..."
  Invoke-WebRequest -Uri 'https://pm.puppetlabs.com/pe-client-tools/2017.3.4/17.3.3/repos/windows/pe-client-tools-17.3.3-x64.msi' -OutFile $PECTMSI
} else { Write-Output "Getting PE Client Tools (SKIPPED) ..." }

# CMDER SHELL
$CMDERZIP = Join-Path -Path $DownloadDir -ChildPath 'cmder-x64.zip'
if (-Not (Test-Path -Path $CMDERZIP)) {
  Write-Output "Getting CMDER ..."
  Invoke-WebRequest -Uri 'https://github.com/cmderdev/cmder/releases/download/v1.3.5/cmder.zip' -OutFile $CMDERZIP
} else { Write-Output "Getting CMDER (SKIPPED) ..." }


#---------------
# Install the installers
#---------------

# PUPPET AGENT
$PuppetInstallRoot = Join-Path -Path (Join-Path -Path $ENV:ProgramFiles -ChildPath 'Puppet Labs') -ChildPath 'Puppet'
if (-Not (Test-Path -Path $PuppetInstallRoot)) {
  Write-Output "Installing Puppet Agent..."
  $args = @('/i', $PuppetMSI, 'ALLUSERS=1', '/qb-', 'REBOOT=REALLYSUPPRESS', 'PUPPET_AGENT_STARTUP_MODE=MANUAL')
  Start-Process -FilePath 'msiexec.exe' -ArgumentList $args -NoNewWindow:$true -Wait:$true
} else { Write-Output "Installing Puppet Agent (SKIPPED) ..." }

# PDK
$PDKInstallRoot = Join-Path -Path (Join-Path -Path $ENV:ProgramFiles -ChildPath 'Puppet Labs') -ChildPath 'DevelopmentKit'
if (-Not (Test-Path -Path $PDKInstallRoot)) {
  Write-Output "Installing PDK..."
  $args = @('/i', $PDKMSI, 'ALLUSERS=1', '/qb-', 'REBOOT=REALLYSUPPRESS')
  Start-Process -FilePath 'msiexec.exe' -ArgumentList $args -NoNewWindow:$true -Wait:$true
} else { Write-Output "Installing PDK (SKIPPED) ..." }

# PE CLIENT TOOLS
$PECTInstallRoot = Join-Path -Path (Join-Path -Path $ENV:ProgramFiles -ChildPath 'Puppet Labs') -ChildPath 'Client'
if (-Not (Test-Path -Path $PECTInstallRoot)) {
  Write-Output "Installing PE Client Tools..."
  $args = @('/i', $PECTMSI, 'ALLUSERS=1', '/qb-', 'REBOOT=REALLYSUPPRESS')
  Start-Process -FilePath 'msiexec.exe' -ArgumentList $args -NoNewWindow:$true -Wait:$true
} else { Write-Output "Installing PE Client Tools (SKIPPED) ..." }


#---------------
# Extract the installer in a portable format
#---------------

# VSCODE
$VSCodeExtractDir = Join-Path -Path $TargetDir -ChildPath 'vscode-app'
if (-Not (Test-Path -Path $VSCodeExtractDir)) {
  Write-Output "Extracting VS Code..."
  [System.IO.Compression.ZipFile]::ExtractToDirectory($VSCodeZIP, $VSCodeExtractDir)
} else { Write-Output "Extracting VS Code (SKIPPED) ..." }

# VSCODE EXTENSIONS
$VSCodeExe = Join-Path -Path $VSCodeExtractDir -ChildPath 'code.exe'
$VSCodeExtDir = Join-Path -Path $TargetDir -ChildPath 'vscode-ext'
$VSCodeExtensions | ForEach-Object {
  $item = $_
  $VSIX = Join-Path -Path $DownloadDir -ChildPath ($item.vsix + '.vsix')

  if (-not (Invoke-DirExists -Root $VSCodeExtDir -Filter "*$($item.name)*")) {
    Write-Output "Extracting VS Code Extension $($item.vsix) ..."

    $ENV:ELECTRON_RUN_AS_NODE = '1'
    $args = @((Join-Path -Path $VSCodeExtractDir -ChildPath "resources\app\out\cli.js"), "--extensions-dir", $VSCodeExtDir, "--install-extension", $VSIX)
    Start-Process -FilePath $VSCodeExe -ArgumentList $args -NoNewWindow:$true -Wait:$true
  } else {   Write-Output "Extracting VS Code Extension $($item.vsix) (SKIPPED) ..." }
}

# PUPPET AGENT
$PuppetExtractRoot = Join-Path -Path $TargetDir -ChildPath 'puppet-agent'
if (-Not (Test-Path -Path $PuppetExtractRoot)) {
  Write-Output "Extracting Puppet Agent ..."
  (& xcopy $PuppetInstallRoot $PuppetExtractRoot /s /e /c /y /i) | Out-Null
} else { Write-Output "Extracting Puppet Agent (SKIPPED) ..." }

# PDK
$PDKExtractRoot = Join-Path -Path $TargetDir -ChildPath 'pdk'
if (-Not (Test-Path -Path $PDKExtractRoot)) {
  Write-Output "Extracting PDK ..."
  (& xcopy $PDKInstallRoot $PDKExtractRoot /s /e /c /y /i) | Out-Null
} else { Write-Output "Extracting PDK (SKIPPED) ..." }

# PE CLIENT TOOLS
$PECTExtractRoot = Join-Path -Path $TargetDir -ChildPath 'pe-client-tools'
if (-Not (Test-Path -Path $PECTExtractRoot)) {
  Write-Output "Extracting PE Client Tools ..."
  (& xcopy $PECTInstallRoot $PECTExtractRoot /s /e /c /y /i) | Out-Null
} else { Write-Output "Extracting PE Client Tools (SKIPPED) ..." }

# CMDER
$CMDERExtractDir = Join-Path -Path $TargetDir -ChildPath 'cmder'
if (-Not (Test-Path -Path $CMDERExtractDir)) {
  Write-Output "Extracting CMDER..."
  [System.IO.Compression.ZipFile]::ExtractToDirectory($CMDERZIP, $CMDERExtractDir)

  # Munge CMDER Configuration
  $ConemuConfigPath = Join-Path -Path $CMDERExtractDir -ChildPath 'config\ConEmu.xml'
  $ConEmuConfig = [XML](Get-Content -Path $ConemuConfigPath)

  $Task = $ConEmuConfig.SelectSingleNode('.//key[value[@name="Name" and @data="{Powershell::Powershell}"]]')
  if ($Task -ne $null) {
    Write-Host "  - Setting PowerShell as the default task..."
    $Flags = $Task.SelectSingleNode('value[@name="Flags"]')
    $Flags.data = "00000003"
  }
  $ConEmuConfig.Save($ConemuConfigPath) | Out-Null
} else { Write-Output "Extracting CMDER (SKIPPED) ..." }

# EXTRA FILES
Write-Host "Extracting extra files..."
(& xcopy "$(Join-Path -Path $PSScriptRoot -ChildPath extra)" $TargetDir /s /e /c /y /i) | Out-Null
