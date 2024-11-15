# add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# install the gameplay postgres helm chart
echo "Installing gameplay-postgres..."
helm install gameplay-postgres bitnami/postgresql-ha \
 --set global.postgresql.password=$GAMEPLAY_POSTGRES_PASS \
 --set global.postgresql.repmgrPassword=$GAMEPLAY_POSTGRES_PASS \
 --set global.postgresql.database=$GAMEPLAY_POSTGRES_DBNAME \
 --set global.postgresql.repmgrDatabase=$GAMEPLAY_POSTGRES_DBNAME \
 --set postgresql.containerPorts.postgresql=$GAMEPLAY_POSTGRES_PORT
 
#Path: learn/databases/gameplay-postgres/dev/install.sh