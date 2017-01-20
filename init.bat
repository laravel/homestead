@echo off
setlocal EnableDelayedExpansion

set homesteadRoot=%HOMEDRIVE%%HOMEPATH%\.homestead
set homesteadBin=%~dp0bin

mkdir "%homesteadRoot%"

copy /-y src\stubs\Homestead.yaml "%homesteadRoot%\Homestead.yaml"
copy /-y src\stubs\after.sh "%homesteadRoot%\after.sh"
copy /-y src\stubs\aliases "%homesteadRoot%\aliases"

goto :CONFIRMATION
:GLOBAL_ACCESS
call :ADD_HOMESTEAD_TO_PATH > nul

:SKIP_GLOBAL_ACCESS

set homesteadRoot=
echo Homestead initialized!
goto END_SCRIPT

:CONFIRMATION
:: Asks for confirmation to add homestead to the PATH environment variable.
:: --------------------
echo Do you want to access Homestead globally? (This will add a path to your PATH environment variable)
set /p "answer=Please select 'Y' (default) to continue or 'N' to skip this step: 
if "%answer%" == "" goto GLOBAL_ACCESS
if /i "%answer%" equ "Y" goto GLOBAL_ACCESS
if /i "%answer%" equ "N" goto SKIP_GLOBAL_ACCESS
goto CONFIRMATION
:: ===== End: CONFIRMATION =====

:ADD_HOMESTEAD_TO_PATH
:: Add the homestead bin folder to the PATH environment variable.
:: --------------------
for /f "usebackq skip=2 tokens=2,*" %%A in (`reg query "HKCU\Environment" /v "PATH" 2^>nul`) do (
	set args=%%B
	set args=!args:%%=%%%%!
	call :FILTER_HOMESTEAD_FROM_PATH "!args!"
    set "user_path=!filtered!;%homesteadBin%"
    setx path "!user_path!"
)
exit /b
:: ===== End: ADD_HOMESTEAD_TO_PATH =====

:FILTER_HOMESTEAD_FROM_PATH <path_string>
:: Parses the given paths list and removes the one that matches with the homestead bin folder
:: from it to prevent duplications.
::
:: @var <path_string> A string containing the list of paths separated with semi-colon.
:: --------------------
set filtered=
set "list=%~1"	:: Clean the argument (removes double quotes)
set "list="%list:;=" "%""	:: Replaces the path separator with a space and encloses each individual string in double quotes
set "list=%list:""=%"	:: Removes empty entries

for %%A in (%list%) do (
	set entry=%%~A
	if /i "!entry!" neq "%homesteadBin%" (
		if "!filtered!" == "" (set filtered=!entry!) else (set filtered=!filtered!;!entry!)
	)
)
exit /b
:: ===== End: FILTER_HOMESTEAD_FROM_PATH =====

:END_SCRIPT
:: Ends the script execution.
:: --------------------
endlocal
exit /b
:: ===== End: END_SCRIPT =====