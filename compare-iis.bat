@echo off

REM Set up the colored text conversion
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

REM Set all of the config values
call config.bat

REM Check if the user wants to use the IIS or SQL compare tool
:mainMenu

cls
echo.
echo ---------------------------------------------
echo.
call :colorEcho 0b " [Q] Choose your compare method"
echo.
echo.
echo ---------------------------------------------
echo.
echo  [1] Use absolute paths inside 'file_list.txt'
echo  [2] Use paths inside 'file_list.txt' with parent directories given in config.bat
echo  [3] Supply a single file name and use parent directories given in config.bat
echo  [4] Supply multiple absolute paths
echo  [5] Supply a folder and compare all files against directories given in config.bat
echo  [6] == QUIT ==

choice /C 123456 /N

cls

if errorlevel == 6 exit
if errorlevel == 5 goto :checkEntireFolder
if errorlevel == 4 goto :supplyAbsolutePaths
if errorlevel == 3 goto :supplySingleFile
if errorlevel == 2 goto :fileConfigPaths
if errorlevel == 1 goto :fileAbsolutePaths


REM ----------------------------
REM fileAbsolutePaths
REM ----------------------------

:fileAbsolutePaths

set index=0
for /F "usebackq tokens=*" %%A in ("file_list.txt") do call :sr_checkIfExists %%A

if %index% LSS 2 ( goto :sr_notEnoughExistingFiles ) else ( goto :sr_filesAreSame )

REM ----------------------------
REM fileConfigPaths
REM ----------------------------

:fileConfigPaths

REM Show the user the paths they are comparing
echo.
echo ---------------------------------------------
call :colorEcho 0e " PARENT PATHS THAT ARE BEING COMPARED"
echo.
echo ---------------------------------------------
echo.

for %%A in (%iisPaths%) do echo  %%A

echo.
echo ---------------------------------------------
call :colorEcho 0e " FILES THAT ARE BEING COMPARED IN EACH"
echo.
echo ---------------------------------------------
echo.

for /F "usebackq tokens=*" %%A in ("file_list.txt") do echo  %%A

for /F "usebackq tokens=*" %%A in ("file_list.txt") do ( 
    set index=0
    for %%B in (%iisPaths%) do call :sr_checkIfExists %%B\%%A
)

REM Show all files that weren't found
if not "%notFoundList%"=="" (
    echo.
    echo ---------------------------------------------
    call :colorEcho 0c " FILES THAT WERE NOT FOUND"
    echo.
    echo ---------------------------------------------
    echo.
    for %%B in (%notFoundList%) do (
        echo %%B
    )
)

REM Show the resulting message
if %index% LSS 2 ( goto :sr_notEnoughExistingFiles ) else ( goto :sr_filesAreSame )


REM ----------------------------
REM supplySingleFile
REM ----------------------------

:supplySingleFile

REM Show the user the paths they are comparing
echo PATHS THAT ARE BEING COMPARED:
echo.


REM ----------------------------
REM supplyAbsolutePaths
REM ----------------------------

:supplyAbsolutePaths

REM Show the user the paths they are comparing
echo PATHS THAT ARE BEING COMPARED:
echo.


REM ----------------------------
REM checkEntireFolder
REM ----------------------------

:checkEntireFolder

REM Show the user the paths they are comparing
echo PATHS THAT ARE BEING COMPARED:
echo.

REM test if this checks if this confirms path given is a folder or if files also pass the test
REM if exist "c:\folder\" echo folder exists 

REM TODO TODO ---------- For checking folders recursive
for /r %%i in (*) do echo %%i


pause


REM Main program must end with exit /b
exit /b


REM ----------------------------
REM ----------------------------
REM SUBROUTINES
REM ----------------------------
REM ----------------------------


REM SUBROUTINE TO SHOW FILES ARE ALL THE SAME
:sr_filesAreSame
    echo.
    echo ---------------------------------------------
    call :colorEcho 0a " All existing files are THE SAME"
    echo.
    echo ---------------------------------------------
    goto :sr_mainMenuOrQuit
exit /b

REM SUBROUTINE TO SHOW FILES NOT THE SAME
:sr_filesAreDifferent
    echo.
    echo ---------------------------------------------
    call :colorEcho 0c " All existing files are DIFFERENT"
    echo.
    echo ---------------------------------------------
    goto :sr_mainMenuOrQuit
exit /b

REM SUBROUTINE TO SHOW THERE ARE NOT ENOUGH EXISTING FILES TO COMPARE
:sr_notEnoughExistingFiles
    echo.
    echo ---------------------------------------------
    echo.
    call :colorEcho 0c " There are not enough existing files to compare"
    echo.
    echo.
    echo ---------------------------------------------
    goto :sr_mainMenuOrQuit

REM SUBROUTINE TO GO BACK TO MAIN MENU OR QUIT
:sr_mainMenuOrQuit
    echo.
    call :colorEcho 0b " [Q] What do you want to do now"
    echo.
    echo.
    echo  [1] Go back to the main menu
    echo  [2] == QUIT ==

    choice /C 12 /N

    if errorlevel 2 exit
    if errorlevel 1 goto :mainMenu
exit /b

REM SUBROUTINE TO CHECK FOR EXISTENCE
:sr_checkIfExists
    if not exist %1 ( set notFoundList=%notFoundList%;%1 ) else ( goto :sr_compareFiles %1 )
exit /b

REM SUBROUTINE TO COMPARE FILES
:sr_compareFiles
    call :sr_resetError

    if not %index% == 0 >NUL 2>&1 fc /c /w %previousFile% %1
    if errorlevel 1 ( goto :sr_filesAreDifferent )
    
    set /A index=index+1
    set previousFile=%1
exit /b

REM SUBROUTINE TO COLOR TEXT
:colorEcho
    echo off
    <nul set /p ".=%DEL%" > "%~2"
    findstr /v /a:%1 /R "^$" "%~2" nul
    del "%~2" > nul 2>&1i
exit /b

REM SUBROUTINE TO RESET "ERRORLEVEL"
:sr_resetError
exit /b 0