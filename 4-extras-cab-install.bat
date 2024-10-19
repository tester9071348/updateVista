@echo off

for /f "tokens=6 delims=[]. " %%# in ('ver') do if %%# geq 7600 (
		echo This script is for Vista/WS2008 only.
		pause && exit
)

set "arch=x86"
if exist "%WinDir%\SysWOW64" set "arch=x64"

for /f "tokens=6" %%v in ('Reg Query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" 2^>Nul') do set "ProductName=%%v"

if "%ProductName%" == "Ultimate" (
	pushd "%~dp0411-Ultimate-Extras"
	echo Installing ultimate extras...
	for %%f in (*%arch%*.cab) do (
		echo %%f
		mkdir tmp%%f
		start /w pkgmgr.exe /ip /m:%%f /s:"tmp%%f" /quiet /norestart
		rd /s /q tmp%%f
	)
	for %%e in (*%arch%*.exe) do (
		echo %%e
		%%e
	)
)
popd

shutdown.exe /r /t 60
echo Restarting in one minute
ping 127.0.0.1 -n 10 >nul