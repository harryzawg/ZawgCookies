
@echo off
:title
@echo off
title ZawgUtils
cls
echo [92m╔══════════
echo [92m║        ZawgUtils           ║
echo [92m║                            ║
echo [92m╚══════════
echo [94m -----------------------------
echo [94m 1. Shutdown after...
echo [94m 2. System info
echo [94m 3. IP info
echo [94m 4. Convert to netscape
echo [94m Quit - Exit
echo [94m -----------------------------
set /p choice=Enter your choice (1-4): 

if "%choice%"=="1" goto shutdown
if "%choice%"=="2" goto sysinfo
if "%choice%"=="3" goto ip
if "%choice%"=="4" goto convert
if "%choice%"=="Quit" goto quit
if "%choice%"=="Exit" goto quit
if "%choice%"=="quit" goto quit
if "%choice%"=="exit" goto quit


echo Invalid choice. Please try again.
pause
goto title

:shutdown
@echo off
title ZawgUtils - Shutdown after...

set /p hours=Enter number of hours to wait until shutdown:
set /a secs=%hours%*60*60

shutdown.exe -a & shutdown.exe -s -t %secs% /d p:4:1 /c "System will shutdown after %hours% hours"

pause
goto title

:sysinfo
title ZawgUtils: System info
systeminfo
pause
goto title

:ip
title ZawgUtils: IP Info
ipconfig /all
pause
goto title

:convert
cls
set /p "cpath=Enter the cookies.txt path (make sure it's called cookies.txt and that start.bat is on the root of an USB drive, and if this fails and nothing appears, try again and it should work.): "
if not exist "%cpath%" (
    echo Cookies file does not exist. Please provide a valid file path.
    pause
    goto convert
)

cd "%~d0\Utils\"
copy "%cpath%" "%~d0\Utils\"
cd "%~d0\Utils\"
start "" "%~d0\Utils\Convert.py"
cd "%~d0\Utils\"
timeout /t 2
del /F /Q "%~d0\Utils\cookies.txt"
move "%~d0\Utils\net_cookies.txt" "%~d0\Utils\Converted"
choice /C YN /M "Do you want to open the output directory?"
if %errorlevel% equ 1 (
    start "" "%~d0\Utils\Converted"
) else (
    echo Skipping
)
    echo Done, thank you for using the zawg converting utility program I am going mentally insane lmao
    pause
    exit

:quit
exit


