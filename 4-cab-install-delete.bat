:: Any cabs placed in the same folder as this script will be installed and deleted!!

@echo off

for /f "tokens=6 delims=[]. " %%# in ('ver') do if %%# geq 7600 (
		echo This script is for Vista/WS2008 only.
		pause && exit
)

set "arch=x86"
if exist "%WinDir%\SysWOW64" set "arch=x64"

for /f "tokens=3" %%v in ('Reg Query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" 2^>Nul') do set "Edition=%%v"
if "%Edition%" == "Ultimate" (
	pushd "%~dp0411-Ultimate-Extras"
	echo Installing ultimate extras...
	for %%e in (*%arch%*.exe) do (
		echo %%e
		%%e
	)
	for %%f in (*%arch%*.cab) do (
		echo %%f
		mkdir tmp%%f
		start /w pkgmgr.exe /ip /m:%%f /s:"tmp%%f" /quiet /norestart
		rd /s /q tmp%%f
	)
)
if "%Edition%" == "Enterprise" (
	pushd "%~dp0412-Enterprise-Extras"
	echo Installing enterprise extras...
	for %%f in (*%arch%*.msu) do (
		echo %%f
		Wusa.exe %%f /quiet /norestart
	)
)
popd

shutdown.exe /r /t 60
echo Restarting in one minute
ping 127.0.0.1 -n 10 >nul