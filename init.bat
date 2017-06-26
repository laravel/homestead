@echo off

del files\*
del files\custom\*

if ["%~1"]==["json"] (
    copy /-y resources\Homestead.json Homestead.json
)
if ["%~1"]==[""] (
    copy /-y resources\Homestead.yaml Homestead.yaml
)

copy /-y resources\after.sh files\after.sh
copy /-y resources\aliases files\aliases
copy /-y resources\custom\* files\custom\

echo Homestead initialized!
