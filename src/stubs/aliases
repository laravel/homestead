alias ..="cd .."
alias ...="cd ../.."

alias h='cd ~'
alias c='clear'
alias artisan='php artisan'

alias phpspec='vendor/bin/phpspec'
alias phpunit='vendor/bin/phpunit'
alias serve=serve-laravel

function serve-laravel() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-laravel.sh
        sudo bash /vagrant/scripts/serve-laravel.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve domain path"
    fi
}

function serve-hhvm() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-hhvm.sh
        sudo bash /vagrant/scripts/serve-hhvm.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-hhvm domain path"
    fi
}
