@ECHO OFF
setlocal
set VSCODE_DEV=
set ELECTRON_RUN_AS_NODE=1
call "%~dp0..\vscode-app\Code.exe" "%~dp0..\vscode-app\resources\app\out\cli.js" "--user-data-dir" "%~dp0..\vscode-user" "--extensions-dir" "%~dp0..\vscode-ext" %*
endlocal

