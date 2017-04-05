alias ..="cd .."
alias ...="cd ../.."

alias h='cd ~'
alias c='clear'
alias art=artisan

alias phpspec='vendor/bin/phpspec'
alias phpunit='vendor/bin/phpunit'
alias serve=serve-laravel

alias xoff='sudo phpdismod -s cli xdebug'
alias xon='sudo phpenmod -s cli xdebug'

function artisan() {
    php artisan "$@"
}

function dusk() {
    pids=$(pidof /usr/bin/Xvfb)

    if [ ! -n "$pids" ]; then
        Xvfb :0 -screen 0 1280x960x24 &
    fi

    php artisan dusk "$@"
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

function serve-spa() {
  if [[ "$1" && "$2" ]]
  then
    sudo dos2unix /vagrant/scripts/serve-spa.sh
    sudo bash /vagrant/scripts/serve-spa.sh "$1" "$2" 80
  else
    echo "Error: missing required parameters."
    echo "Usage: "
    echo "  serve-spa domain path"
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
        ngrok http ${@:2} -host-header="$1" 80
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  share domain"
        echo "Invocation with extra params passed directly to ngrok" 
        echo "  share domain -region=eu -subdomain=test1234"
    fi
}

function flip() {
    sudo bash /vagrant/scripts/flip-webserver.sh
}
