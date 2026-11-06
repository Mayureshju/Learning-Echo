@echo off
setlocal EnableExtensions
title LearnLoop setup
cd /d "%~dp0"
set PYTHONUTF8=1

echo [1/4] Checking Python and Node.js...
set "PY="
where py >nul 2>nul
if not errorlevel 1 (
    for %%V in (3.12 3.13 3.11 3.14) do (
        if not defined PY (
            py -%%V -c "import sys" >nul 2>nul && set "PY=py -%%V"
        )
    )
)
if not defined PY (
    python -c "import sys; sys.exit(0 if (3, 11) <= sys.version_info[:2] < (3, 15) else 1)" >nul 2>nul && set "PY=python"
)
if not defined PY (
    echo ERROR: Python 3.11 to 3.14 was not found.
    echo Install Python 3.12 from https://www.python.org/downloads/ and tick "Add python.exe to PATH".
    goto :fail
)
where node >nul 2>nul
if errorlevel 1 (
    echo ERROR: Node.js was not found. Install Node.js 22 LTS from https://nodejs.org/
    goto :fail
)
node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 22 ? 0 : 1)"
if errorlevel 1 (
    echo ERROR: Node.js 22 or newer is required. Install the LTS version from https://nodejs.org/
    goto :fail
)

echo [2/4] Creating the Python environment in .venv...
if exist ".venv\bin" if not exist ".venv\Scripts" (
    echo Removing a .venv that was copied from macOS or Linux; it cannot run on Windows.
    rmdir /s /q ".venv"
)
if not exist ".venv\Scripts\python.exe" (
    %PY% -m venv .venv
    if errorlevel 1 goto :fail
)

echo [3/4] Installing Python packages. This is the slow part...
".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 goto :fail
".venv\Scripts\python.exe" -m pip install -r requirements\full.txt
if errorlevel 1 goto :fail
".venv\Scripts\python.exe" -m pip install -e . --no-deps
if errorlevel 1 goto :fail

echo [4/4] Installing web app packages...
pushd web
call npm ci --legacy-peer-deps
if errorlevel 1 (
    popd
    goto :fail
)
popd

echo.
echo Setup finished. Double-click start.bat to run LearnLoop.
pause
exit /b 0

:fail
echo.
echo Setup did not finish. Read the error above, fix it, and run setup.bat again.
pause
exit /b 1
