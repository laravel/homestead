# Prevent TTY Errors by disabling IPv6 during apt-get.
# See: https://github.com/hashicorp/vagrant/issues/1673#issuecomment-261041105
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >>  /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >>  /etc/sysctl.conf
sudo sysctl -p
