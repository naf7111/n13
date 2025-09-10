@echo off
title N13 Support Tool
mode con: cols=90 lines=30
color 0A

:: تحديد ملف اللوج
set "log=%userprofile%\Desktop\N13_Support_Log.txt"

:menu
cls
echo =====================================================
echo            ███╗   ██╗██╗███╗   ███╗
echo            ████╗  ██║██║████╗ ████║
echo            ██╔██╗ ██║██║╔████╔██║
echo            ██║╚██╗██║██║██║╚██╔╝██║
echo            ██║ ╚████║██║██║ ╚═╝ ██║
echo            ╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝
echo.
echo            N13 End User Support Tool
echo =====================================================
echo Log file: %log%
echo.
echo   [1]  Show System Info
echo   [2]  Performance
echo   [3]  Network Info
echo   [4]  Ping Test
echo   [5]  Restart Print Spooler
echo   [6]  Restart Explorer
echo   [7]  Network Tools
echo   [8]  Remote Tools
echo   [9]  Quick Fix Hub
echo   [S]  Self-Healing Mode (Auto Fix)
echo   [M]  Live Monitoring Mode
echo   [0]  Exit
echo.
set /p choice=Choose an option: 

if /i "%choice%"=="S" goto selfheal
if /i "%choice%"=="M" goto monitor
if "%choice%"=="0" goto end
if "%choice%"=="1" goto sysinfo
if "%choice%"=="2" goto performance
if "%choice%"=="3" goto netinfo
if "%choice%"=="4" goto pingtest
if "%choice%"=="5" goto spooler
if "%choice%"=="6" goto explorer
if "%choice%"=="7" goto nettools
if "%choice%"=="8" goto remote
if "%choice%"=="9" goto quickfix
goto menu

:log
echo [%date% %time%] %~1 >> "%log%"
goto :eof

:sysinfo
cls
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
wmic cpu get Name
wmic memorychip get Capacity
wmic diskdrive get model,size
call :log "Viewed System Info"
pause
goto menu

:performance
cls
echo ==============================
echo Windows Cleanup & Optimization
echo ==============================
echo.

:: Delete user temp files
echo Deleting user temp files...
del /s /f /q "%temp%\*.*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%" >nul 2>&1

:: Delete system temp files
echo Deleting system temp files...
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
mkdir "C:\Windows\Temp" >nul 2>&1

:: Clear Prefetch
echo Clearing Prefetch cache...
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

:: Empty Recycle Bin
echo Emptying Recycle Bin...
rd /s /q C:\$Recycle.Bin >nul 2>&1

:: Clear Internet cache (IE/Edge Legacy)
echo Clearing Internet Explorer cache...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

:: Clear DNS cache
echo Flushing DNS cache...
ipconfig /flushdns >nul

:: Run Disk Cleanup silently
echo Running Disk Cleanup...
cleanmgr /sagerun:1 >nul 2>&1

:: Run System File Checker
echo Running System File Checker (this may take several minutes)...
sfc /scannow

:: Force Group Policy Update
echo Updating Group Policy...
gpupdate /force

echo.
color 0A
echo =====================================
echo Performance Optimization Completed Successfully!
echo =====================================
echo.
call :log "Ran Performance Optimization"
pause
goto menu

:netinfo
cls
ipconfig /all
call :log "Viewed Network Info"
pause
goto menu

:pingtest
cls
set /p target=Enter host or IP to ping: 
ping %target%
call :log "Ping test on %target%"
pause
goto menu

:spooler
cls
net stop spooler
net start spooler
echo Print Spooler restarted successfully.
call :log "Restarted Print Spooler"
pause
goto menu

:explorer
cls
taskkill /f /im explorer.exe
start explorer.exe
echo Explorer restarted successfully.
call :log "Restarted Explorer"
pause
goto menu

:: ================= Network Tools =================
:nettools
cls
echo ============== Network Tools ==============
echo [1] ipconfig
echo [2] ipconfig /all
echo [3] ipconfig /flushdns
echo [4] ping
echo [5] tracert
echo [6] nslookup
echo [7] netstat -ano
echo [8] arp -a
echo [9] route print
echo [10] nbtstat -n
echo [0] Back
echo ===========================================
set /p nchoice=Choose: 

if "%nchoice%"=="0" goto menu
if "%nchoice%"=="1" goto nt_ipconfig
if "%nchoice%"=="2" goto nt_ipconfigall
if "%nchoice%"=="3" goto nt_flushdns
if "%nchoice%"=="4" goto nt_ping
if "%nchoice%"=="5" goto nt_tracert
if "%nchoice%"=="6" goto nt_nslookup
if "%nchoice%"=="7" goto nt_netstat
if "%nchoice%"=="8" goto nt_arp
if "%nchoice%"=="9" goto nt_route
if "%nchoice%"=="10" goto nt_nbtstat
goto nettools

:nt_ipconfig
cls
ipconfig
call :log "Ran ipconfig"
pause
goto nettools

:nt_ipconfigall
cls
ipconfig /all
call :log "Ran ipconfig /all"
pause
goto nettools

:nt_flushdns
cls
ipconfig /flushdns
call :log "Ran ipconfig /flushdns"
pause
goto nettools

:nt_ping
cls
set /p host=Enter host/IP to ping: 
ping %host%
call :log "Ran ping on %host%"
pause
goto nettools

:nt_tracert
cls
set /p host=Enter host/IP to trace: 
tracert %host%
call :log "Ran tracert on %host%"
pause
goto nettools

:nt_nslookup
cls
set /p host=Enter domain to nslookup: 
nslookup %host%
call :log "Ran nslookup on %host%"
pause
goto nettools

:nt_netstat
cls
netstat -ano
call :log "Ran netstat -ano"
pause
goto nettools

:nt_arp
cls
arp -a
call :log "Ran arp -a"
pause
goto nettools

:nt_route
cls
route print
call :log "Ran route print"
pause
goto nettools

:nt_nbtstat
cls
nbtstat -n
call :log "Ran nbtstat -n"
pause
goto nettools
:: =================================================

:: باقي الأقسام: Remote, QuickFix, SelfHeal, Monitor (من النسخة السابقة)

:remote
cls
echo ============== Remote Tools ==============
echo [1] Ping multiple hosts
echo [2] Check RDP (Port 3389)
echo [0] Back
echo ==========================================
set /p rchoice=Choose: 

if "%rchoice%"=="0" goto menu
if "%rchoice%"=="1" goto pingmulti
if "%rchoice%"=="2" goto rdptest
goto remote

:pingmulti
cls
set /p hosts=Enter hosts (space separated): 
for %%h in (%hosts%) do (
    ping -n 2 %%h
    call :log "Pinged host %%h"
)
pause
goto remote

:rdptest
cls
set /p rhost=Enter remote host: 
powershell -command "Test-NetConnection -ComputerName %rhost% -Port 3389"
call :log "Checked RDP on %rhost%"
pause
goto remote

:quickfix
cls
echo ============== Quick Fix Hub ==============
echo [1] Flush DNS & Reset Network
echo [2] Clear Printer Queue
echo [0] Back
echo ==========================================
set /p qchoice=Choose: 

if "%qchoice%"=="0" goto menu
if "%qchoice%"=="1" goto fixdns
if "%qchoice%"=="2" goto fixprint
goto quickfix

:fixdns
cls
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
echo Network reset complete.
call :log "Ran Flush DNS & Reset Network"
pause
goto quickfix

:fixprint
cls
net stop spooler
del /Q /F %systemroot%\System32\spool\PRINTERS\*.*
net start spooler
echo Printer queue cleared.
call :log "Cleared Printer Queue"
pause
goto quickfix

:selfheal
cls
set "report=%userprofile%\Desktop\N13_SelfHealing_%date:/=-%.txt"
echo Self-Healing Report - %date% %time% > "%report%"

ipconfig /all >> "%report%"
ping -n 2 8.8.8.8 >> "%report%"
sc query spooler >> "%report%"
sc query audiosrv >> "%report%"
sc query wuauserv >> "%report%"

echo Self-Healing complete. Report saved to: %report%
start notepad "%report%"
call :log "Ran Self-Healing Mode"
pause
goto menu

:monitor
cls
echo ================================================
echo        N13 Live Monitoring Mode - Active
echo ================================================
echo Press CTRL + C to stop monitoring.
echo.
set /p target=Enter host/IP to monitor: 

:monitorloop
ping -n 1 %target% >nul
if errorlevel 1 (
    color 0C
    echo [%time%] ALERT: %target% is DOWN!
    call :log "ALERT: %target% is DOWN"
) else (
    color 0A
    echo [%time%] %target% is OK.
)

sc query spooler | find "RUNNING" >nul
if errorlevel 1 (
    color 0C
    echo [%time%] ALERT: Print Spooler STOPPED!
    call :log "ALERT: Print Spooler STOPPED"
) else (
    color 0A
    echo [%time%] Print Spooler running.
)

sc query audiosrv | find "RUNNING" >nul
if errorlevel 1 (
    color 0C
    echo [%time%] ALERT: Audio Service STOPPED!
    call :log "ALERT: Audio Service STOPPED"
) else (
    color 0A
    echo [%time%] Audio Service running.
)

sc query wuauserv | find "RUNNING" >nul
if errorlevel 1 (
    color 0C
    echo [%time%] ALERT: Windows Update STOPPED!
    call :log "ALERT: Windows Update STOPPED"
) else (
    color 0A
    echo [%time%] Windows Update running.
)

timeout /t 5 >nul
goto monitorloop

:end
cls
echo =====================================================
echo This tool Designed by Nawaf Alshamrani
echo =====================================================
call :log "Exited tool"
pause
exit
