@echo off
rem Launches the health_hub Flask app via waitress, headless.
rem Uses pythonw.exe so there is no console window to accidentally close.
rem Log redirection (stdout/stderr -> serve.out.log/serve.err.log) is
rem handled inside serve.py, since pythonw has no streams to redirect.

cd /d "%~dp0"
echo. >> serve.out.log
echo --- starting health_hub at %DATE% %TIME% --- >> serve.out.log
echo. >> serve.err.log
echo --- starting health_hub at %DATE% %TIME% --- >> serve.err.log
start "" "C:\Users\18324\Anaconda3\pythonw.exe" serve.py
