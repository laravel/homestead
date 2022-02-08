
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' Homestead.yaml
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' Homestead.yaml
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' CONTRIBUTING.md
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' CONTRIBUTING.md
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' Homestead.yaml.example
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' Homestead.yaml.example


sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' ../rvtw/frontend/.env.dev
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' ../rvtw/frontend/cypress.json
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' ../rvtw/frontend/README.md

sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' ../rvtw/backend/.env.cypress
sed -i '' 's/dev-cypress.rvtripwizard.com/tripwizard.dev-cypress-rvlife.com/g' ../rvtw/backend/bootstrap/app.php
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' ../rvtw/backend/.env.example
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' ../rvtw/backend/.env.homestead
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' ../rvtw/backend/.env
sed -i '' 's/local.rvtripwizard.com/tripwizard.local-rvlife.com/g' ../rvtw/backend/CONTRIBUTING.md

vagrant reload --provision