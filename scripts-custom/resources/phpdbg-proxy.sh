#!/bin/bash

#### Dirty/Fake PHP Interpreter to trick PHPStorm into using PHPDBG for running tests with/without code coverage
## For Mac/Linux only, Window's ubuntu subsystem theoretically would work too
##
##
## Related JetBrain's issues/feature requests
##       https://youtrack.jetbrains.com/issue/WI-21414
##       https://youtrack.jetbrains.com/issue/WI-29112
##
##
##        SETUP
## Step 1:     Save this script somewhere,
##             ~/php-phpdbg-proxy.sh
##
## Step 2:     Add executable permission to script
##             chmod +x ~/php-phpdbg-proxy.sh
##
## Step 3:     PHPStorm > Preferences > Languages & Frameworks > PHP > CLI Interpreter
##             Set this bash script as your 'PHP executable'
##
## Step 4:     ????????

# Use PHPDBG for running tests WITH code coverage
PHPDBG_WITH_COVERAGE=true

# Use PHPDBG for running tests WITHOUT code coverage
PHPDBG_WITHOUT_COVERAGE=false

# Lazily load the XDebug PHP Extension when required? False if extension=xdebug is present in your php.ini
XDEBUG_LAZY_LOAD=true

######################################################################################################################

[[ "$@" == *"--teamcity"* ]] && TEAMCITY=true || TEAMCITY=false
[[ "$@" == *"--coverage"* ]] && COVERAGE=true || COVERAGE=false
[[ "$@" == *"xdebug"* ]] && XDBEUG=true || XDBEUG=false

teamcity_output() {
        if [ "$TEAMCITY" = true ]; then
                echo "##teamcity[message text='$1|n' status='NORMAL']"
        fi
}

if [[ $@ == *"/phpunit "* ]] && [[ "$COVERAGE" = true && "$PHPDBG_WITH_COVERAGE" = true || "$COVERAGE" = false && "$PHPDBG_WITHOUT_COVERAGE" = true ]]; then
        teamcity_output "Running with PHPDBG"
        $(which phpdbg) -qrr "${@}"
elif [[ "$XDEBUG_LAZY_LOAD" = true ]] && [[ "$COVERAGE" = true || "$XDBEUG" = true ]]; then
        teamcity_output "Running with normal PHP binary + XDebug"
        $(which php) -dzend_extension=xdebug "${@}"
else
        teamcity_output "Running with normal PHP binary"
        $(which php) "${@}"
fi

exit $?
