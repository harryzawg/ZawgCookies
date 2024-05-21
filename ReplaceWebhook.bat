@echo off
setlocal enabledelayedexpansion

set /p "input=Enter the new value to replace "WEBHOOK" with: (i recommend using webhook.site) "

for %%f in (Run.bat) do (
    (
        for /f "tokens=*" %%i in ('type "%%f"') do (
            set "line=%%i"
            set "line=!line:WEBHOOK=%input%!"
            echo !line!
        )
    ) > "%%~nf.temp"
    move /y "%%~nf.temp" "%%f" > nul
)

echo Replacement complete for Run.bat
pause

