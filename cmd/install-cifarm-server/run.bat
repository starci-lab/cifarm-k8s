@echo off
echo Delete existing CiFarm Server...
helm uninstall cifarm-server

echo Building dependencies for CiFarm Server...
helm dependency build cifarm/cifarm-server

echo Installing CiFarm Server...
helm install cifarm-server cifarm/cifarm-server -f cifarm/cifarm-server/values.dev.yaml

echo Installation complete.
pause