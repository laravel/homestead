sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' /etc/hosts ;
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' /etc/hosts ;
killall -HUP mDNSResponder