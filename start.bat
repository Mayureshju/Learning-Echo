@echo off
setlocal
title LearnLoop
cd /d "%~dp0"
if not exist ".venv\Scripts\learnloop.exe" (
    echo LearnLoop is not set up yet. Double-click setup.bat first.
    pause
    exit /b 1
)
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8
echo Starting LearnLoop. The first start builds the web app and can take a few minutes.
echo Press Ctrl+C to stop.
".venv\Scripts\learnloop.exe" start %*
pause
