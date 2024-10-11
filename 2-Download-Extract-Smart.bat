@echo off

:: '0' Will download everything, '1' will download only the missing updates for your architecture
set "backup=0"
set ping_timer=3

set "arch=x86"
set "bit=32"
if exist "%WinDir%\SysWOW64" (
	set "arch=x64"
	set "bit=64"
)

if not exist "%~dp0000-wget\%arch%\" (
	mkdir "%~dp0000-wget\%arch%\"
)

@REM set "link=https://eternallybored.org/misc/wget/1.21.3/%bit%/wget.exe"
set "link=https://eternallybored.org/misc/wget/1.21.4/%bit%/wget.exe"

:WGET
if not exist "%~dp0000-wget\%arch%\wget.exe" (
	cls
	echo [{000214A0-0000-0000-C000-000000000046}]>>"%~dp0Firefox-52.9.0esr-sha1-download.url"
	echo Prop3=19,11>>"%~dp0Firefox-52.9.0esr-sha1-download.url"
	echo [InternetShortcut]>>"%~dp0Firefox-52.9.0esr-sha1-download.url"
	echo URL=https://archive.mozilla.org/pub/firefox/releases/52.9.0esr/win32-sha1/en-US/Firefox%%20Setup%%2052.9.0esr.exe>>"%~dp0Firefox-52.9.0esr-sha1-download.url"
	echo IDList=>>"%~dp0Firefox-52.9.0esr-sha1-download.url"

	echo Firefox is needed to open wget's download link.
	echo Press any key to open the link...
	pause > nul
	"%~dp0Firefox-52.9.0esr-sha1-download.url" && del "%~dp0Firefox-52.9.0esr-sha1-download.url"
	
	echo Press any key when firefox is installed ^& made default.
	echo.
	pause > nul

	echo [{000214A0-0000-0000-C000-000000000046}]>>"%~dp0000-wget\%arch%\wget-%arch%-Download.url"
	echo Prop3=19,11>>"%~dp0000-wget\%arch%\wget-%arch%-Download.url"
	echo [InternetShortcut]>>"%~dp0000-wget\%arch%\wget-%arch%-Download.url"
	echo URL=%link%>>"%~dp0000-wget\%arch%\wget-%arch%-Download.url"
	echo IDList=>>"%~dp0000-wget\%arch%\wget-%arch%-Download.url"


	echo Press any key to open the download link for wget-%arch%.
	echo The file needs to be placed in:
	echo %~dp0000-wget\%arch%\
	echo.
	pause > nul
	"%~dp0000-wget\%arch%\wget-%arch%-Download.url" && del "%~dp0000-wget\%arch%\wget-%arch%-Download.url"
	
	echo Press any key to continue when wget-%arch% is placed in:
	echo "%~dp0000-wget\%arch%\"
	echo.
	pause>nul

	if exist "%~dp0000-wget\%arch%\wget.exe" (
		echo wget-%arch% is succesfully placed where it should, proceeding...
		echo.
		ping 127.0.0.1 -n %ping_timer% > nul
	) else (
		echo ERROR! wget-%arch% can't be found in 409-wget\%arch%\
		echo Press any key to repeat the process...
		echo.
		pause > nul
		goto :WGET
	)
)

echo ===============================================================================
if %backup% == 0 ( echo ========================= Download mode: smart ================================)
if %backup% == 1 ( echo ========================= Download mode: backup ===============================)
echo ===============================================================================
echo.
ping 127.0.0.1 -n %ping_timer% > nul

:DOWNLOADER
for /d %%a in (*) do (
	pushd "%~dp0%%a"
	if exist "%~dp0%%a\filelist.txt" (
		for /f "eol=; tokens=1,2*" %%i in (filelist.txt) do (
			if not exist "%~dp0%%a\%%i" (
				if %backup% == 1 (
					"%~dp0000-wget\%arch%\wget.exe" -q --show-progress --no-hsts --no-check-certificate -O "%%i" "%%j"
				)
				if %backup% == 0 (
					if %%a == 001-Tools (
						"%~dp0000-wget\%arch%\wget.exe" -q --show-progress --no-hsts --no-check-certificate -O "%%i" "%%j"
					) else (
						for /f "tokens=2,3,4 delims=-" %%k in ('echo "%%i"') do (
							if not exist "%SystemRoot%\servicing\packages\package_*_for_%%k*.mum" (
								if "%%l" == "%arch%" (
									"%~dp0000-wget\%arch%\wget.exe" -q --show-progress --no-hsts --no-check-certificate -O "%%i" "%%j"
								) else (
									if "%%m" == "%arch%" (
										"%~dp0000-wget\%arch%\wget.exe" -q --show-progress --no-hsts --no-check-certificate -O "%%i" "%%j"
									)
								)
							)
						)
					)
				)
			)
		)
	)
	popd
)
echo ===============================================================================
echo ========================= Downloading complete ================================
echo ===============================================================================
echo.
ping 127.0.0.1 -n %ping_timer% > nul

:7ZIP
for /f "tokens=2*" %%i in ('Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\7-Zip" /v "Path" 2^>Nul') do Set "ExePath=%%j"
if not defined ExePath (
	echo 7zip is missing, Installing...
	for %%f in ("%~dp0001-Tools\7zip-*-%arch%.exe") do (
		%%f /S /D="%programfiles%\7-Zip"
		echo 7zip has been installed in "%programfiles%\7-Zip"
		ping 127.0.0.1 -n %ping_timer% > nul
	)
	goto :7ZIP
)


REM echo ===============================================================================
REM	echo ===================== Abbodi's Tools ==========================================
REM echo ===============================================================================

if exist "%~dp0001-Tools\406-Vista_SHA2_WUC.7z" (
	if not exist "%~dp0406-Vista_SHA2_WUC\Install_WUC.cmd" (
		echo Extracting Vista_SHA2_WUC
		ping 127.0.0.1 -n %ping_timer% > nul
		"%programfiles%\7-Zip\7z.exe" x "%~dp0001-Tools\406-Vista_SHA2_WUC.7z" -o"%~dp0406-Vista_SHA2_WUC" -aoa > nul
	)
) else (
	echo 406-Vista_SHA2_WUC.7z doesn't exist, nothing to extract
)

REM "%programfiles%\7-Zip\7z.exe" x "%~dp0001-Tools\407-BypassESU-v7-WS2008-(pass=2023).7z" -o"%~dp0407-BypassESU-v7-WS2008" -p2023 -aoa
REM "%programfiles%\7-Zip\7z.exe" x "%~dp0001-Tools\408-WU_DataStore_Fix.zip" -o"%~dp0408-WU_DataStore_Fix" -aoa

REM if not exist "%~dp0410-WMF30-KB2506146-Vista-Installer" (mkdir "%~dp0410-WMF30-KB2506146-Vista-Installer")
if exist "%~dp0001-Tools\410-WMF30-KB2506146-Vista-Installer.7z" (
	if not exist "%~dp0410-WMF30-KB2506146-Vista-Installer\1-Patch-Servicing_Stack.cmd" (
		echo Extracting WMF30-KB2506146-Vista-Installer
		ping 127.0.0.1 -n %ping_timer% > nul
		"%programfiles%\7-zip\7z.exe" x "%~dp0001-Tools\410-WMF30-KB2506146-Vista-Installer.7z" -o"%~dp0410-WMF30-KB2506146-Vista-Installer" -p2023 -aoa >nul
	)
)

REM echo ===============================================================================
REM echo ===================== Abbodi's Repacks ========================================
REM echo ===============================================================================

if exist "%~dp0001-Tools\DirectX-Repack-x86&x64.zip" (
	if not exist "%~dp0211-Repacks\DirectX_Redist_Repack_x86_x64.exe" (
		echo Extracting DirectX_Redist_Repack_x86_x64
		"%programfiles%\7-Zip\7z.exe" x "%~dp0001-Tools\DirectX-Repack-x86&x64.zip" -o"%~dp0211-Repacks\" -aoa > nul
		ping 127.0.0.1 -n %ping_timer% > nul
	)
)

if exist "%~dp0001-Tools\dotNetFx35-Repack_x86_x64_*.zip" (
	if not exist "%~dp0211-Repacks\dotNetFx35_x86_x64.exe" (
		echo Extracting dotNetFx35_x86_x64
		ping 127.0.0.1 -n %ping_timer% > nul
		"%programfiles%\7-Zip\7z.exe" x "%~dp0001-Tools\dotNetFx35-Repack_x86_x64_*.zip" -o"%~dp0211-Repacks\" -aoa > nul
	)
)

if exist "%~dp0001-Tools\NDP462-Repack-x86-x64-ENU_*.zip" (
	if not exist "%~dp0211-Repacks\NDP462-x86-x64-ENU.exe" (
		echo Extracting NDP462-x86-x64-ENU
		"%programfiles%\7-Zip\7z.exe" x "%~dp0001-Tools\NDP462-Repack-x86-x64-ENU_*.zip" -o"%~dp0211-Repacks\" -aoa > nul
		ping 127.0.0.1 -n %ping_timer% > nul
	)
)

echo.
echo Creating WinDefender Definition download link...
echo.
ping 127.0.0.1 -n %ping_timer% > nul

set "link=https://go.microsoft.com/fwlink/?LinkID=121721^&clcid=0x409^&arch=%arch%^&eng=0.0.0.0^&avdelta=0.0.0.0^&asdelta=0.0.0.0^&prod=925A3ACA-C353-458A-AC8D-A7E5EB378092"

echo [{000214A0-0000-0000-C000-000000000046}]>>"%~dp0WinDef-Definitions-%arch%.url"
echo Prop3^=19,11>>"%~dp0WinDef-Definitions-%arch%.url"
echo [InternetShortcut]>>"%~dp0WinDef-Definitions-%arch%.url"
echo URL=%link%>>"%~dp0WinDef-Definitions-%arch%.url"
echo IDList=>>"%~dp0WinDef-Definitions-%arch%.url"

echo Creating product red and ultimate extras URL shortcut and exiting
echo.
ping 127.0.0.1 -n %ping_timer% > nul

echo [{000214A0-0000-0000-C000-000000000046}]>>webarchive-product-red.url
echo Prop3=19,11>>webarchive-product-red.url
echo [InternetShortcut]>>webarchive-product-red.url
echo URL=https://archive.org/details/windows-vista-product-red>>webarchive-product-red.url
echo IDList=>>webarchive-product-red.url

echo [{000214A0-0000-0000-C000-000000000046}]>>webarchive-ultimate-extras.url
echo Prop3=19,11>>webarchive-ultimate-extras.url
echo [InternetShortcut]>>webarchive-ultimate-extras.url
echo URL=https://archive.org/details/windows-vista-ultimate-extras>>webarchive-ultimate-extras.url
echo IDList=>>webarchive-ultimate-extras.url

echo.
echo ===============================================================================
echo ======================== Everything is Complete ===============================
echo ===============================================================================
ping 127.0.0.1 -n %ping_timer% > nul

goto :EOF

REM example call
call :FETCH %%i %%j

:FETCH
"%~dp0000-wget\%arch%\wget.exe" -q --show-progress --no-hsts --no-check-certificate -O "%1" "%2"
exit /b