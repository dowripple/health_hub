@echo off
rem ============================================================
rem  health_hub - install prerequisites
rem  Installs PostgreSQL, Python, Git, and the GitHub CLI
rem  using winget. Run from an elevated (Admin) command prompt.
rem ============================================================

setlocal

echo.
echo === health_hub prerequisite installer ===
echo.

where winget >nul 2>&1
if errorlevel 1 (
    echo [ERROR] winget is not available on this machine.
    echo Install "App Installer" from the Microsoft Store, then re-run.
    exit /b 1
)

echo Installing PostgreSQL ...
winget install --id PostgreSQL.PostgreSQL.16 -e --accept-package-agreements --accept-source-agreements

echo.
echo Installing Python 3 ...
winget install --id Python.Python.3.12 -e --accept-package-agreements --accept-source-agreements

echo.
echo Installing Git ...
winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements

echo.
echo Installing GitHub CLI ...
winget install --id GitHub.cli -e --accept-package-agreements --accept-source-agreements

echo.
echo === System packages installed. Now installing Python packages ... ===
echo.

rem Refresh PATH so freshly-installed python/pip are visible in this shell
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYSPATH=%%B"
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USRPATH=%%B"
set "PATH=%SYSPATH%;%USRPATH%"

python -m pip install --upgrade pip
python -m pip install flask waitress psycopg2-binary python-dotenv

echo.
echo === Done. ===
echo Next steps:
echo   1. Open a NEW terminal so PATH changes take effect.
echo   2. Create a PostgreSQL database called health_db.
echo   3. Run the DDL in static\sql\ to create tables.
echo   4. Launch the app with start_health_hub.bat.
echo.

endlocal
