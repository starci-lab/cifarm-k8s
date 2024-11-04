@echo off
echo Delete existing CiFarm Server PostgreSQL...
helm uninstall cifarm-server-postgresql

echo Building dependencies for PostgreSQL HA chart...
helm repo add bitnami https://charts.bitnami.com/bitnami

echo Installing CiFarm Server PostgreSQL...
helm install cifarm-server-postgresql bitnami/postgresql-ha --set postgresqlPassword=postgresql --set replication.password=postgres

echo Installation complete.
pause