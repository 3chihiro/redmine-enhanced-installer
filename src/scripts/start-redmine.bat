@echo off
REM Enhanced Redmine Startup Script
REM Starts Redmine with all enhanced features

setlocal enabledelayedexpansion

echo ========================================
echo Enhanced Redmine Startup
echo ========================================
echo.

REM Set installation variables
set INSTALL_DIR=C:\Program Files\Enhanced Redmine
set REDMINE_DIR=%INSTALL_DIR%\redmine
set RUBY_DIR=%INSTALL_DIR%\ruby
set MYSQL_DIR=%INSTALL_DIR%\mysql
set APACHE_DIR=%INSTALL_DIR%\apache2
set LOG_DIR=%INSTALL_DIR%\logs
set PID_FILE=%INSTALL_DIR%\tmp\redmine.pid

REM Set environment variables
set RAILS_ENV=production
set REDMINE_LANG=en
set PATH=%RUBY_DIR%\bin;%MYSQL_DIR%\bin;%APACHE_DIR%\bin;%PATH%
set BUNDLE_GEMFILE=%REDMINE_DIR%\Gemfile

REM Create log and tmp directories
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%INSTALL_DIR%\tmp" mkdir "%INSTALL_DIR%\tmp"

REM Initialize startup log
set STARTUP_LOG=%LOG_DIR%\startup.log
echo Redmine startup initiated at %DATE% %TIME% > "%STARTUP_LOG%"
echo ================================== >> "%STARTUP_LOG%"

REM Check if Redmine is already running
if exist "%PID_FILE%" (
    set /p RUNNING_PID=<"%PID_FILE%"
    tasklist /fi "pid eq !RUNNING_PID!" | findstr "!RUNNING_PID!" > nul
    if !errorlevel! equ 0 (
        echo Redmine is already running with PID: !RUNNING_PID!
        echo Redmine is already running with PID: !RUNNING_PID! >> "%STARTUP_LOG%"
        echo.
        echo To stop Redmine, run: "%INSTALL_DIR%\scripts\stop-redmine.bat"
        echo To restart Redmine, run: "%INSTALL_DIR%\scripts\restart-redmine.bat"
        pause
        exit /b 0
    ) else (
        del "%PID_FILE%"
    )
)

REM Check system requirements
echo Checking system requirements...
echo Checking system requirements... >> "%STARTUP_LOG%"

REM Check Ruby installation
ruby --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Ruby not found or not properly installed!
    echo ERROR: Ruby not found! >> "%STARTUP_LOG%"
    echo Please ensure Ruby is installed and accessible in PATH
    pause
    exit /b 1
)
ruby --version >> "%STARTUP_LOG%"

REM Check MySQL service
echo Checking MySQL service...
sc query MySQL > nul 2>&1
if %errorlevel% neq 0 (
    echo Starting MySQL service...
    echo Starting MySQL service... >> "%STARTUP_LOG%"
    net start MySQL >> "%STARTUP_LOG%" 2>&1
    if !errorlevel! neq 0 (
        echo WARNING: Could not start MySQL service
        echo WARNING: MySQL service start failed >> "%STARTUP_LOG%"
    )
) else (
    echo MySQL service is running.
    echo MySQL service verified >> "%STARTUP_LOG%"
)

REM Check Apache service (if using Apache)
sc query Apache2.4 > nul 2>&1
if %errorlevel% equ 0 (
    echo Checking Apache service...
    sc query Apache2.4 | findstr "RUNNING" > nul
    if !errorlevel! neq 0 (
        echo Starting Apache service...
        echo Starting Apache service... >> "%STARTUP_LOG%"
        net start Apache2.4 >> "%STARTUP_LOG%" 2>&1
    )
)

REM Navigate to Redmine directory
cd /d "%REDMINE_DIR%"
if %errorlevel% neq 0 (
    echo ERROR: Could not access Redmine directory: %REDMINE_DIR%
    echo ERROR: Redmine directory not accessible >> "%STARTUP_LOG%"
    pause
    exit /b 1
)

REM Check database connectivity
echo Testing database connection...
echo Testing database connection... >> "%STARTUP_LOG%"
bundle exec rake db:version RAILS_ENV=production > nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Database connection issues detected
    echo WARNING: Database connection failed >> "%STARTUP_LOG%"
    echo Attempting to run database migrations...
    bundle exec rake db:create RAILS_ENV=production >> "%STARTUP_LOG%" 2>&1
    bundle exec rake db:migrate RAILS_ENV=production >> "%STARTUP_LOG%" 2>&1
    bundle exec rake redmine:plugins:migrate RAILS_ENV=production >> "%STARTUP_LOG%" 2>&1
)

REM Precompile assets if needed
if not exist "%REDMINE_DIR%\public\assets" (
    echo Precompiling assets...
    echo Precompiling assets... >> "%STARTUP_LOG%"
    bundle exec rake assets:precompile RAILS_ENV=production >> "%STARTUP_LOG%" 2>&1
)

REM Clear cache
echo Clearing application cache...
echo Clearing application cache... >> "%STARTUP_LOG%"
bundle exec rake tmp:cache:clear RAILS_ENV=production >> "%STARTUP_LOG%" 2>&1

REM Start Redmine server
echo Starting Enhanced Redmine server...
echo Starting Enhanced Redmine server... >> "%STARTUP_LOG%"

REM Choose server type based on configuration
set SERVER_TYPE=webrick
if exist "%APACHE_DIR%" (
    set SERVER_TYPE=passenger
)

REM Check for Puma configuration
if exist "%REDMINE_DIR%\config\puma.rb" (
    set SERVER_TYPE=puma
)

echo Server type: %SERVER_TYPE%
echo Server type: %SERVER_TYPE% >> "%STARTUP_LOG%"

REM Start appropriate server
if "%SERVER_TYPE%"=="puma" (
    echo Starting with Puma server...
    start /b "Enhanced Redmine" bundle exec puma -C config/puma.rb -e production
    
    REM Get PID (approximate method for Windows)
    timeout /t 3 > nul
    for /f "tokens=2" %%i in ('tasklist /fi "imagename eq ruby.exe" /fo csv ^| findstr puma') do (
        echo %%i > "%PID_FILE%"
        set REDMINE_PID=%%i
        goto :pid_found
    )
    :pid_found
    
) else if "%SERVER_TYPE%"=="passenger" (
    echo Starting with Passenger (Apache integration)...
    echo Starting with Passenger... >> "%STARTUP_LOG%"
    net start Apache2.4 >> "%STARTUP_LOG%" 2>&1
    echo apache > "%PID_FILE%"
    
) else (
    echo Starting with WEBrick server...
    echo Starting with WEBrick... >> "%STARTUP_LOG%"
    start /b "Enhanced Redmine" bundle exec rails server -e production -p 3000 -b 0.0.0.0
    
    REM Get PID
    timeout /t 3 > nul
    for /f "tokens=2" %%i in ('tasklist /fi "imagename eq ruby.exe" /fo csv ^| findstr rails') do (
        echo %%i > "%PID_FILE%"
        set REDMINE_PID=%%i
        goto :webrick_pid_found
    )
    :webrick_pid_found
)

REM Wait for server to start
echo Waiting for server to start...
timeout /t 10 > nul

REM Test server accessibility
echo Testing server accessibility...
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:3000' -Method Head -TimeoutSec 30 | Out-Null; Write-Host 'Server is accessible' } catch { Write-Host 'Server accessibility test failed' }" >> "%STARTUP_LOG%" 2>&1

REM Display startup information
echo.
echo ========================================
echo Enhanced Redmine Started Successfully!
echo ========================================
echo.
echo Server Information:
echo - Installation Directory: %INSTALL_DIR%
echo - Redmine Directory: %REDMINE_DIR%
echo - Server Type: %SERVER_TYPE%
if defined REDMINE_PID echo - Process ID: %REDMINE_PID%
echo - Environment: %RAILS_ENV%
echo.
echo Access URLs:
echo - Main Interface: http://localhost:3000
echo - Admin Panel: http://localhost:3000/admin
echo - API Endpoint: http://localhost:3000/projects.json
echo.
echo Default Login (First Time):
echo - Username: admin
echo - Password: admin
echo.
echo *** IMPORTANT: Change default password immediately! ***
echo.
echo Enhanced Features Available:
echo - Advanced Gantt Charts with dependencies
echo - Excel Export/Import with custom templates
echo - Earned Value Management (EVM) tracking
echo - Advanced reporting and dashboards
echo - Custom project analytics
echo.
echo Log Files:
echo - Startup Log: %STARTUP_LOG%
echo - Application Log: %REDMINE_DIR%\log\production.log
echo - Error Log: %LOG_DIR%\error.log
echo.
echo Management Scripts:
echo - Stop Server: "%INSTALL_DIR%\scripts\stop-redmine.bat"
echo - Restart Server: "%INSTALL_DIR%\scripts\restart-redmine.bat"
echo - Configure Excel: "%INSTALL_DIR%\scripts\configure-excel.bat"
echo - Backup Data: "%INSTALL_DIR%\scripts\backup-redmine.bat"
echo.
echo For support and documentation:
echo - GitHub: https://github.com/enhanced-redmine/installer
echo - Documentation: http://localhost:3000/help
echo ========================================

echo Server startup completed at %DATE% %TIME% >> "%STARTUP_LOG%"

REM Open browser automatically (optional)
set /p OPEN_BROWSER="Open browser automatically? (y/n): "
if /i "%OPEN_BROWSER%"=="y" (
    echo Opening browser...
    timeout /t 2 > nul
    start http://localhost:3000
)

REM Create monitoring script
(
    echo @echo off
    echo REM Enhanced Redmine Monitor
    echo.
    echo :monitor
    echo cls
    echo ========================================
    echo Enhanced Redmine Server Monitor
    echo ========================================
    echo Server Status: 
    if exist "%PID_FILE%" (
        set /p PID=^<"%PID_FILE%"
        tasklist /fi "pid eq %%PID%%" ^| findstr "%%PID%%" ^> nul
        if %%errorlevel%% equ 0 (
            echo [RUNNING] PID: %%PID%%
        ) else (
            echo [STOPPED] - PID file exists but process not found
        )
    ) else (
        echo [STOPPED] - No PID file found
    )
    echo.
    echo Press Ctrl+C to exit monitor, any other key to refresh...
    pause > nul
    goto monitor
) > "%INSTALL_DIR%\scripts\monitor-redmine.bat"

echo.
echo Enhanced Redmine is now running!
echo Use Ctrl+C to stop this script (server will continue running)
echo Or run the stop script to properly shutdown the server.

REM Keep script running to show live logs (optional)
set /p SHOW_LOGS="Show live application logs? (y/n): "
if /i "%SHOW_LOGS%"=="y" (
    echo.
    echo Showing live logs (Ctrl+C to exit)...
    echo ==========================================
    if exist "%REDMINE_DIR%\log\production.log" (
        powershell -Command "Get-Content '%REDMINE_DIR%\log\production.log' -Wait -Tail 20"
    ) else (
        echo Log file not yet created. Please wait...
        timeout /t 5 > nul
        if exist "%REDMINE_DIR%\log\production.log" (
            powershell -Command "Get-Content '%REDMINE_DIR%\log\production.log' -Wait -Tail 20"
        )
    )
)

endlocal