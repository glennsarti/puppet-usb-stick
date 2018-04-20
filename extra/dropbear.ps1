$StickDir = $PSScriptRoot
Start-Process -FilePath (Join-Path -Path (Join-Path -Path $StickDir -ChildPath 'cmder') -ChildPath 'cmder.exe') -ArgumentList @('/TASK','PowerShell') -NoNewWindow:$false -Wait:$false | Out-Null

# $ErrorActionPreference = 'stop'
# Write-Host "Puppet USB Stick Shell`n" -ForegroundColor Green
# Write-Host "Tools installed:" -ForegroundColor Green
# Write-Host "Visual Studio Code          - code" -ForegroundColor Green
# Write-Host "Puppet Agent                - puppet" -ForegroundColor Green
# Write-Host "Puppet Development Kit      - pdk" -ForegroundColor Green
# Write-Host "PE Client Tools Quick Start - init-pe-client-tools" -ForegroundColor Green
# Write-Host "PE Client Tools             - puppet-access" -ForegroundColor Green
# Write-Host "                            - puppet-app" -ForegroundColor Green
# Write-Host "                            - puppet-code" -ForegroundColor Green
# Write-Host "                            - puppet-db" -ForegroundColor Green
# Write-Host "                            - puppet-job" -ForegroundColor Green
# Write-Host "                            - puppet-query" -ForegroundColor Green
# Write-Host ""

# $StickDir = $PSScriptRoot

# # Add our bin to the path
# $NewPaths = @(
#   (Join-Path -Path $StickDir -ChildPath 'bin'),
#   (Join-Path -Path (Join-Path -Path $StickDir -ChildPath 'puppet-agent') -ChildPath 'bin')
#   (Join-Path -Path (Join-Path -Path $StickDir -ChildPath 'pe-client-tools') -ChildPath 'bin')
# )
# $ENV:PATH = ($NewPaths -join ';') + ';' + $ENV:PATH

# # Import any custom modules
# @('PuppetDevelopmentKit') | ForEach-Object {
#   Import-Module (Join-Path -Path (Join-Path -Path $StickDir -ChildPath 'PowerShellModules') -ChildPath $_) -Force
# }

# # Modify the Puppet VSCode Extension
# $SettingsJSON = Join-Path -Path (Join-Path -Path (Join-Path -Path $StickDir -ChildPath 'vscode-user') -ChildPath 'User') -ChildPath 'settings.json'
# $VSCodeSettings = [System.IO.File]::ReadAllText($SettingsJSON) | ConvertFrom-Json
# $VSCodeSettings.'puppet.puppetAgentDir' = Join-Path -Path $StickDir -ChildPath 'puppet-agent'
# [System.IO.File]::WriteAllText($SettingsJSON, ($VSCodeSettings | ConvertTo-JSON -Depth 10))
