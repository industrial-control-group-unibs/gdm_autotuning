echo off
echo '
echo '
echo ' Batch generazione applicazione
echo '
echo '

set APP_FL2_A1=%PRJTITLE%_%PRJRELEASE%_%PRJVERSION%_A1.fl2
set APP_FL2_A2=%PRJTITLE%_%PRJRELEASE%_%PRJVERSION%_A2.fl2

"%APPLPATH%\cod2sre" -c %PRJTITLE%.cod -o ADV200Syn_7_7_19_Fw_Lang_%PRJTITLE%_%PRJRELEASE%_%PRJVERSION%_A1.fl2 -db %PRJTITLE%.dbt -ac 0xA8350000 -ad 0xA8390000 -fw ADV200Syn_7_7_19_Fw_Lang.fl2 -s 0xA8360000 -adv
"%APPLPATH%\cod2sre" -c %PRJTITLE%.cod -o ADV200Syn_7_7_19_Fw_Lang_%PRJTITLE%_%PRJRELEASE%_%PRJVERSION%_A2.fl2 -db %PRJTITLE%.dbt -ac 0xA8370000 -ad 0xA83A0000 -fw ADV200Syn_7_7_19_Fw_Lang.fl2 -s 0xA8380000 -adv

"%APPLPATH%\cod2sre" -c %PRJTITLE%.cod -o %APP_FL2_A1% -db %PRJTITLE%.dbt -ac 0xA8350000 -ad 0xA8390000 -s 0xA8360000 -adv
"%APPLPATH%\cod2sre" -c %PRJTITLE%.cod -o %APP_FL2_A2% -db %PRJTITLE%.dbt -ac 0xA8370000 -ad 0xA83A0000 -s 0xA8380000 -adv

if "%PRJRELEASE%" == "" goto END
for /f "tokens=1,2,3,4 delims=_" %%a in ("%PRJRELEASE%") do set APP_VER=%%a&set APP_REL=%%b&set APP_TYP=%%c&set APP_SVR=%%d
if "%APP_TYP%" == "" goto END
if "%APP_TYP%" == 0  goto END

set APP_INDEX="%GEFRANROOT%"\Catalog\Drives\Inverter\ADV200\AppIndex.txt
cscript //NoLogo GFTIntegration.js 1 %APP_TYP% %APP_INDEX% > VersionFile.txt
set /p APP_STR=<VersionFile.txt
if %APP_STR% == Undef goto END

set APP_VERSION="%APP_STR% %APP_VER%.x.%APP_TYP%.%APP_SVR%"
set TOTAL_VERSION="7.x.19 "%APP_VERSION%""

set PATH_CATALOG=Catalog\Drives\Inverter\ADV200\ADV200_7_x_19
set OUT_NAME=ADV200Syn_7_x_19_%APP_STR%_%APP_VER%_x_%APP_TYP%_%APP_SVR%
set OUT_NAME_1=ADV200Syn_7_7_19_%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%
set OUT_NAME_2=ADV200Syn_7_x_19_%APP_STR%_%APP_VER%_x_%APP_TYP%_%APP_SVR%
set OUT_NAME_3=ADV200Syn_7_7_19_%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%

set PAR2GFT_EXE="%GEFRANROOT%"\ConversionTools\par2gft.exe
set PHP_EXE="%GEFRANROOT%"\ConversionTools\php.exe
set SCRIPT_PHP="%GEFRANROOT%"\Catalog\Custom\App\ADV200\EdsADVApp.php
set INP_EDS=ADV200Syn_7_x_19_co.eds
set OUT_EDS=%PATH_CATALOG%\Service\CANopen\ADV200Syn_7_x_19_%APP_STR%_%APP_VER%_x_%APP_TYP%_%APP_SVR%_co.eds
set OUT_APP=%PATH_CATALOG%\Service\Applications
set INP_OSC=ADV200Syn_7_7_19_scope.osc
set OUT_OSC=%PATH_CATALOG%\Service\Softscope\%OUT_NAME_1%.osc
set OUT_SYTXML=%PATH_CATALOG%\Service\Softscope\%OUT_NAME_3%.syt.xml
set CAN_EDS_JS="%GEFRANROOT%"\Catalog\Custom\Gft\GFTedsGF_Net.js
set CAN_TEMPL="%GEFRANROOT%"\Catalog\Custom\Gft\GFTedsCustom_ADV200.templ

set FILE_GFT=%PARFILENAME%
set FILE_GFT=%FILE_GFT:.par=.gft%

if not exist Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\Applications                 mkdir Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\Applications
if not exist Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\Applications\Syn_7_7_19 mkdir Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\Applications\Syn_7_7_19
if not exist Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\CANopen                      mkdir Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\CANopen
if not exist Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\SoftScope                    mkdir Catalog\Drives\Inverter\ADV200\ADV200_7_x_19\Service\SoftScope
if not exist Catalog\Custom\Gft                                                                   mkdir Catalog\Custom\Gft

echo '
echo '
echo ' file gft, eds and osc building for GF_eXpress Catalog and GF_Net
echo '
echo ' 

echo #define DriveVerAppVer "ADV200_7_7_19 %APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%" > VersionFile.txt
echo #define DriveVer "ADV200_7_x_19" >> VersionFile.txt

%PAR2GFT_EXE% %PARFILENAME% %FILE_GFT% /nodeletecache > nul
if errorlevel 1 goto ERROR_PAR2GFT

cscript //NoLogo GFTIntegration.js ADV200Syn_7_7_19_Version.xml ADV200Syn_7_7_19_Info.xml %FILE_GFT% %APP_VERSION% %OUT_NAME% %APP_TYP% %OUT_NAME_3%
copy %FILE_GFT% %PATH_CATALOG%\%OUT_NAME%.gft > nul
echo Generated output file: %PATH_CATALOG%\%OUT_NAME%.gft
if not %APP_TYP% == 3 ( 
	copy %APP_FL2_A1% %OUT_APP%\Syn_7_7_19\%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%__A1.fl2 > nul 
	echo Generated output file: %OUT_APP%\Syn_7_7_19\%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%__A1.fl2 
	copy %APP_FL2_A2% %OUT_APP%\Syn_7_7_19\%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%__A2.fl2 > nul 
	echo Generated output file: %OUT_APP%\Syn_7_7_19\%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR%__A2.fl2 
)

del %FILE_GFT%

"%APPLPATH%\llc" %PRJTITLE%.ppj /GT:"temp1.osc" > nul
"%APPLPATH%\llc" %PRJTITLE%.ppj /GG:"temp1.osc" /Q > nul
copy /b %INP_OSC% + "temp1.osc" %OUT_OSC% > nul
cscript OSCconv.js temp1.osc %OUT_SYTXML% %OUT_NAME% /name:%APP_STR%_%APP_VER%_%APP_REL%_%APP_TYP%_%APP_SVR% /codeID:%PRJTITLE%.sym
del "temp1.osc"
echo Generated output file: %OUT_OSC%
echo Generated output file: %OUT_SYTXML%

if not exist %INP_EDS% goto ERROR_FILE_EDS
%PHP_EXE% -q %SCRIPT_PHP% %PARFILENAME% %INP_EDS% %OUT_NAME_2%_co.eds %APP_STR% > %OUT_EDS%
if errorlevel 1 goto ERROR_PHP
echo Generated output file: %OUT_EDS%
if not exist %CAN_EDS_JS% goto ERROR_FILE_CAN_JS
cscript //NoLogo %CAN_EDS_JS% "ADV200S" %OUT_EDS% %OUT_NAME% %TOTAL_VERSION% %CAN_TEMPL% %PATH_CATALOG%\%OUT_NAME%.gft "Brushless Inverter Drives"
goto END

:ERROR_FILE_EDS
echo '
echo File %INP_EDS% not found
goto END

:ERROR_FILE_CAN_JS
echo '
echo File %CAN_EDS_JS% not found
goto END

:ERROR_PAR2GFT
echo '
echo Error while executing %PAR2GFT_EXE%
goto END

:ERROR_PHP
echo '
echo Error while executing %SCRIPT_PHP% 
goto END

:END
