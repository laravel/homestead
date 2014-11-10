
set -e

echo "installing avahi-aliases..."

apt-get -y install libnss-mdns python-avahi
touch /etc/avahi/aliases

cat > /etc/init/avahi-aliases.conf <<EOF

start on started avahi-daemon
stop on stopping avahi-daemon

respawn

setuid avahi
setgid avahi

exec /vagrant/scripts/avahi-aliases/avahi-aliases -serve

EOF

echo "done."
