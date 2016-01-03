@echo off

set homesteadRoot=%HOMEDRIVE%%HOMEPATH%\.homestead

mkdir "%homesteadRoot%"

copy src\stubs\Homestead.yaml "%homesteadRoot%\Homestead.yaml"
copy src\stubs\after.sh "%homesteadRoot%\after.sh"
copy src\stubs\aliases "%homesteadRoot%\aliases"

set homesteadRoot=
echo "Homestead initialized!"
