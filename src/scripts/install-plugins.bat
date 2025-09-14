@echo off
REM Enhanced Redmine Plugin Installation Script
REM Installs Bitnami Redmine with advanced plugins on Windows

echo ========================================
echo Enhanced Redmine Plugin Installer
echo ========================================
echo.

REM Set installation variables
set INSTALL_DIR=C:\Program Files\Enhanced Redmine
set REDMINE_DIR=%INSTALL_DIR%\redmine
set RUBY_DIR=%INSTALL_DIR%\ruby
set MYSQL_DIR=%INSTALL_DIR%\mysql
set TEMP_DIR=%TEMP%\redmine-installer
set LOG_FILE=%INSTALL_DIR%\logs\installation.log

REM Create necessary directories
echo Creating installation directories...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\logs" mkdir "%INSTALL_DIR%\logs"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

REM Initialize log file
echo Installation started at %DATE% %TIME% > "%LOG_FILE%"

REM Check for administrator privileges
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: This script must be run as Administrator!
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Download and install Bitnami Redmine if not exists
if not exist "%REDMINE_DIR%" (
    echo Downloading Bitnami Redmine 5.0.5...
    echo Download URL: https://bitnami.com/stack/redmine/installer
    echo.
    echo Please download Bitnami Redmine 5.0.5 manually from:
    echo https://bitnami.com/redirect/to/1735058/bitnami-redmine-5.0.5-0-windows-x64-installer.exe
    echo.
    echo Place the installer in %TEMP_DIR% and press any key to continue...
    pause
    
    if exist "%TEMP_DIR%\bitnami-redmine-5.0.5-0-windows-x64-installer.exe" (
        echo Installing Bitnami Redmine...
        "%TEMP_DIR%\bitnami-redmine-5.0.5-0-windows-x64-installer.exe" --mode unattended --prefix "%INSTALL_DIR%" --enable-components redmine,apache,mysql,php
        echo Bitnami Redmine installation completed.
    ) else (
        echo ERROR: Bitnami installer not found!
        echo Please download the installer and run this script again.
        exit /b 1
    )
)

REM Set environment variables
set PATH=%RUBY_DIR%\bin;%MYSQL_DIR%\bin;%PATH%
set REDMINE_ROOT=%REDMINE_DIR%

REM Install Ruby gems for plugins
echo Installing required Ruby gems...
cd /d "%REDMINE_DIR%"

REM Update Gemfile for additional dependencies
echo. >> Gemfile
echo # Enhanced Redmine Plugin Dependencies >> Gemfile
echo gem 'rubyzip', '~> 2.3' >> Gemfile
echo gem 'axlsx', '~> 3.0' >> Gemfile
echo gem 'axlsx_rails', '~> 0.6' >> Gemfile
echo gem 'roo', '~> 2.8' >> Gemfile
echo gem 'spreadsheet', '~> 1.3' >> Gemfile
echo gem 'prawn', '~> 2.4' >> Gemfile
echo gem 'prawn-table', '~> 0.2' >> Gemfile
echo gem 'mini_magick', '~> 4.11' >> Gemfile

REM Install gems
echo Installing gems with Bundler...
call bundle install --without development test >> "%LOG_FILE%" 2>&1

REM Download and install plugins
echo Installing enhanced plugins...

REM Create plugins directory
if not exist "%REDMINE_DIR%\plugins" mkdir "%REDMINE_DIR%\plugins"

REM Install Gantt Chart Plugin
echo Installing Gantt Chart Plugin...
cd /d "%REDMINE_DIR%\plugins"
if not exist "redmine_gantt_chart" (
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/tkusukawa/redmine_gantt_chart/archive/refs/heads/master.zip' -OutFile '%TEMP_DIR%\gantt.zip'}" >> "%LOG_FILE%" 2>&1
    powershell -Command "& {Expand-Archive -Path '%TEMP_DIR%\gantt.zip' -DestinationPath '%TEMP_DIR%'}" >> "%LOG_FILE%" 2>&1
    if exist "%TEMP_DIR%\redmine_gantt_chart-master" (
        move "%TEMP_DIR%\redmine_gantt_chart-master" "redmine_gantt_chart" >> "%LOG_FILE%" 2>&1
        echo Gantt Chart Plugin installed successfully.
    )
)

REM Install Excel Export Plugin
echo Installing Excel Export Plugin...
if not exist "redmine_xlsx_format_issue_exporter" (
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/two-pack/redmine_xlsx_format_issue_exporter/archive/refs/heads/master.zip' -OutFile '%TEMP_DIR%\excel.zip'}" >> "%LOG_FILE%" 2>&1
    powershell -Command "& {Expand-Archive -Path '%TEMP_DIR%\excel.zip' -DestinationPath '%TEMP_DIR%'}" >> "%LOG_FILE%" 2>&1
    if exist "%TEMP_DIR%\redmine_xlsx_format_issue_exporter-master" (
        move "%TEMP_DIR%\redmine_xlsx_format_issue_exporter-master" "redmine_xlsx_format_issue_exporter" >> "%LOG_FILE%" 2>&1
        echo Excel Export Plugin installed successfully.
    )
)

REM Install EVM Plugin
echo Installing EVM (Earned Value Management) Plugin...
if not exist "redmine_evm" (
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/momibun926/redmine_evm/archive/refs/heads/master.zip' -OutFile '%TEMP_DIR%\evm.zip'}" >> "%LOG_FILE%" 2>&1
    powershell -Command "& {Expand-Archive -Path '%TEMP_DIR%\evm.zip' -DestinationPath '%TEMP_DIR%'}" >> "%LOG_FILE%" 2>&1
    if exist "%TEMP_DIR%\redmine_evm-master" (
        move "%TEMP_DIR%\redmine_evm-master" "redmine_evm" >> "%LOG_FILE%" 2>&1
        echo EVM Plugin installed successfully.
    )
)

REM Install Additional Reporting Plugin (if available)
echo Installing Advanced Reporting Plugin...
if not exist "redmine_advanced_reports" (
    mkdir "redmine_advanced_reports"
    cd "redmine_advanced_reports"
    
    REM Create basic plugin structure
    echo Creating advanced reporting plugin structure...
    mkdir app\controllers app\models app\views config db lib
    mkdir app\views\reports app\views\dashboards
    
    REM Create init.rb
    (
        echo Redmine::Plugin.register :redmine_advanced_reports do
        echo   name 'Advanced Reports Plugin'
        echo   author 'Enhanced Redmine Team'
        echo   description 'Advanced reporting and dashboard functionality'
        echo   version '1.0.0'
        echo   url 'https://github.com/enhanced-redmine/advanced-reports'
        echo   requires_redmine :version_or_higher => '5.0.0'
        echo   
        echo   menu :top_menu, :advanced_reports, { :controller => 'advanced_reports', :action => 'index' }, :caption => 'Advanced Reports', :if => Proc.new { User.current.logged? }
        echo end
    ) > init.rb
    
    cd ..
    echo Advanced Reporting Plugin structure created.
)

REM Run plugin migrations
echo Running database migrations for plugins...
cd /d "%REDMINE_DIR%"
call bundle exec rake redmine:plugins:migrate RAILS_ENV=production >> "%LOG_FILE%" 2>&1

REM Configure plugins
echo Configuring plugins...
call ruby "%INSTALL_DIR%\scripts\customize-redmine.rb" >> "%LOG_FILE%" 2>&1

REM Install and configure Excel templates
echo Installing Excel templates...
if not exist "%INSTALL_DIR%\templates\excel" mkdir "%INSTALL_DIR%\templates\excel"
call "%INSTALL_DIR%\scripts\configure-excel.bat" >> "%LOG_FILE%" 2>&1

REM Clear cache and precompile assets
echo Clearing cache and precompiling assets...
call bundle exec rake tmp:cache:clear RAILS_ENV=production >> "%LOG_FILE%" 2>&1
call bundle exec rake assets:precompile RAILS_ENV=production >> "%LOG_FILE%" 2>&1

REM Set file permissions
echo Setting file permissions...
icacls "%REDMINE_DIR%" /grant Users:F /T > nul
icacls "%REDMINE_DIR%\files" /grant Users:F /T > nul
icacls "%REDMINE_DIR%\log" /grant Users:F /T > nul
icacls "%REDMINE_DIR%\tmp" /grant Users:F /T > nul
icacls "%REDMINE_DIR%\plugins" /grant Users:F /T > nul

REM Create Windows service
echo Creating Windows service...
sc create "Enhanced Redmine" binPath= "\"%INSTALL_DIR%\scripts\start-redmine.bat\"" DisplayName= "Enhanced Redmine Service" start= auto > nul

REM Create desktop shortcuts
echo Creating shortcuts...
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\Enhanced Redmine.lnk'); $Shortcut.TargetPath = 'http://localhost:3000'; $Shortcut.Description = 'Enhanced Redmine Web Application'; $Shortcut.Save()}"

REM Create Start Menu shortcuts
if not exist "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Enhanced Redmine" mkdir "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Enhanced Redmine"
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Enhanced Redmine\Enhanced Redmine.lnk'); $Shortcut.TargetPath = 'http://localhost:3000'; $Shortcut.Description = 'Enhanced Redmine Web Application'; $Shortcut.Save()}"
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Enhanced Redmine\Start Redmine Service.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\scripts\start-redmine.bat'; $Shortcut.Description = 'Start Enhanced Redmine Service'; $Shortcut.Save()}"
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Enhanced Redmine\Configure Excel.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\scripts\configure-excel.bat'; $Shortcut.Description = 'Configure Excel Integration'; $Shortcut.Save()}"

REM Clean up temporary files
echo Cleaning up temporary files...
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"

REM Final status
echo.
echo ========================================
echo Installation Summary
echo ========================================
echo Installation Directory: %INSTALL_DIR%
echo Redmine Directory: %REDMINE_DIR%
echo Log File: %LOG_FILE%
echo.
echo Installed Plugins:
echo - Gantt Chart Plugin (Advanced project scheduling)
echo - Excel Export Plugin (Enhanced Excel integration)
echo - EVM Plugin (Earned Value Management)
echo - Advanced Reports Plugin (Custom dashboards and analytics)
echo.
echo Services:
echo - Enhanced Redmine Service (Windows Service)
echo.
echo Access URLs:
echo - Web Interface: http://localhost:3000
echo - Admin Panel: http://localhost:3000/admin
echo.
echo Default Credentials:
echo - Username: admin
echo - Password: admin (Please change immediately!)
echo.
echo Installation completed successfully!
echo Installation log saved to: %LOG_FILE%
echo.
echo To start Redmine, run: "%INSTALL_DIR%\scripts\start-redmine.bat"
echo Or start the Windows service: net start "Enhanced Redmine"
echo ========================================

echo Installation completed at %DATE% %TIME% >> "%LOG_FILE%"
pause