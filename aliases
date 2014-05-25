alias ..="cd .."
alias ...="cd ../.."

alias h='cd ~'
alias c='clear'

function serve() {
	if [[ "$1" && "$2" ]]
	then
		sudo dos2unix /vagrant/scripts/serve.sh
		sudo bash /vagrant/scripts/serve.sh "$1" "$2"
	else
		echo "Error: missing required parameters."
		echo "Usage: "
		echo "  serve domain path"
	fi
}

