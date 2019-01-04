	echo "Adding mysqldump.sql.gz to ~/Homestead"
	curl -o ~/Homestead/mysqldump.sql.gz https://s3.amazonaws.com/mb-engineering-onboarding/musicbed/mysqldump.sql.gz

	if grep -q "AccessDenied" ~/Homestead/mysqldump.sql.gz; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Homestead/mysqldump.sql.gz
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
	fi