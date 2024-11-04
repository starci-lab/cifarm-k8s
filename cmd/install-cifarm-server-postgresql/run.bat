@echo off
echo Delete existing CiFarm Server PostgreSQL...
helm uninstall cifarm-server-postgresql

echo Building dependencies for PostgreSQL HA chart...
helm dependency build bitnami/charts/bitnami/postgresql-ha

echo Installing CiFarm Server PostgreSQL...
helm install cifarm-server-postgresql bitnami/charts/bitnami/postgresql-ha -f cifarm/cifarm-server-postgresql/values.dev.yaml

echo Installation complete.
pause