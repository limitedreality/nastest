@echo off
REM SET ip=10.11.81.8
REM SET nasfolder=testco_implementations
SET /p ip="Enter IP for Test NAS Location: "
SET /p nasfolder="NAS Share/Folder: "
SET /p nasuser="NAS User: "
SET /p naspassword="NAS Password: "
SET nashost=nastest
SET outputfile=C:\nasMigrationTest.txt
SET nasoutputfile=\\%nashost%\%nasfolder%\%COMPUTERNAME%.txt
SET hostfile=%WINDIR%\System32\Drivers\Etc\Hosts
SET hostfilebackup=%hostfile%.bak

ECHO Backing up host file... > %outputfile%
COPY %hostfile% %hostfilebackup% && ECHO Host File Backed up Successfully >> %outputfile%
If NOT EXIST %hostfilebackup% Exit /b
ECHO. >> %outputfile%
ECHO Adding entry to host file for NAS test... >> %outputfile%
ECHO %ip% %nashost% >> %WINDIR%\System32\Drivers\Etc\Hosts && ECHO Host File Entry Added 

Successfully >> %outputfile%
ECHO. >> %outputfile%
ECHO Verifying Host file works... >> %outputfile%
FOR /f "tokens=1,3 delims=: " %%A IN ('ping -n 1 %nashost%') DO IF %%A==Reply (IF %%B==%ip% 

(ECHO IP MATCHED >> %outputfile% ) ELSE (ECHO Host Resolution Failed!! >> %outputfile% ))
ECHO. >> %outputfile%
ECHO Connecting to NAS... >> %outputfile%
NET USE \\%nashost%\%nasfolder% /user:%nasuser% %naspassword% >> %outputfile%
ECHO Verifying write permissions to NAS.. >> %outputfile%
ECHO File created.  > %nasoutputfile% 
IF EXIST %nasoutputfile% (ECHO Verified NAS share writable.  Temp file created. >> 

%outputfile%) ELSE (ECHO FAILED!!!!!!!!!!!!!!!!!!!!! >> %outputfile% )
ECHO. >> %outputfile% 
ECHO Deleting temp file to ensure full permissions... >> %outputfile%
DEL %nasoutputfile%
IF EXIST %nasoutputfile% (ECHO Failed to delete file!!!! >> %outputfile% ) ELSE (ECHO Delete 

successful. >> %outputfile% ) 
ECHO. >> %outputfile%
ECHO Deleting Net USE Share... >> %outputfile%
NET USE \\%nashost%\%nasfolder% /d >> %outputfile% 
ECHO Restoring backed up host file... >> %outputfile%
MOVE /Y %hostfilebackup% %hostfile% && echo Host File Was Restored Successfully >> 

%outputfile%
START notepad %outputfile%
PAUSE
DEL %outputfile%