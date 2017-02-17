alias ..="cd .."
alias ...="cd ../.."

alias h='cd ~'
alias c='clear'
alias art=artisan

alias phpspec='vendor/bin/phpspec'
alias phpunit='vendor/bin/phpunit'
alias serve=serve-laravel

function artisan() {
    php artisan "$@"
}

function serve-apache() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-apache.sh
        sudo bash /vagrant/scripts/serve-apache.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-apache domain path"
    fi
}

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

function serve-proxy() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-proxy.sh
        sudo bash /vagrant/scripts/serve-proxy.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-proxy domain port"
    fi
}

function serve-silverstripe() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-silverstripe.sh
        sudo bash /vagrant/scripts/serve-silverstripe.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-silverstripe domain path"
    fi
}

function serve-statamic() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-statamic.sh
        sudo bash /vagrant/scripts/serve-statamic.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-statamic domain path"
    fi
}

function serve-symfony2() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /vagrant/scripts/serve-symfony2.sh
        sudo bash /vagrant/scripts/serve-symfony2.sh "$1" "$2" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-symfony2 domain path"
    fi
}

function share() {
    if [[ "$1" ]]
    then
        ngrok http -host-header="$1" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  share domain"
    fi
}
