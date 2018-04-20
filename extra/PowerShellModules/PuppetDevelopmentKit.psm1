# From - https://github.com/puppetlabs/pdk-vanagon/tree/ddc3923192bba8d02d47d45627348f53853f9a04/resources/files/windows/PuppetDevelopmentKit

$fso = New-Object -ComObject Scripting.FileSystemObject

$env:DEVKIT_BASEDIR = Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..') -ChildPath 'pdk'
# Windows API GetShortPathName requires inline C#, so use COM instead
$env:DEVKIT_BASEDIR = $fso.GetFolder($env:DEVKIT_BASEDIR).ShortPath
$env:RUBY_DIR       = "$($env:DEVKIT_BASEDIR)\private\ruby\2.1.9"
$env:SSL_CERT_FILE  = "$($env:DEVKIT_BASEDIR)\ssl\cert.pem"
$env:SSL_CERT_DIR   = "$($env:DEVKIT_BASEDIR)\ssl\certs"

function pdk {
  if ($env:ConEmuANSI -eq 'ON') {
    &$env:RUBY_DIR\bin\ruby -S -- $env:RUBY_DIR\bin\pdk $args
  } else {
    &$env:DEVKIT_BASEDIR\private\tools\bin\ansicon.exe $env:RUBY_DIR\bin\ruby -S -- $env:RUBY_DIR\bin\pdk $args
  }
}

Export-ModuleMember -Function pdk -Variable *
