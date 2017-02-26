@echo off

if ["%~1"]==["json"] (
    copy /-y src\stubs\Homestead.json Homestead.json
)
if ["%~1"]==[""] (
    copy /-y src\stubs\Homestead.yaml Homestead.yaml
)

copy /-y src\stubs\after.sh after.sh
copy /-y src\stubs\aliases aliases

echo Homestead initialized!
