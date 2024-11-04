@echo off
echo Deleting previous secret...
kubectl delete secret regcred

echo Reading Docker registry credentials from file...
for /f "tokens=1,2 delims==" %%A in (.env) do (
    set %%A=%%B
)

echo Setting up credentials for Docker registry...
kubectl create secret docker-registry regcred ^
  --docker-server=%DOCKER_SERVER% ^
  --docker-username=%DOCKER_USERNAME% ^
  --docker-password=%DOCKER_PASSWORD% ^
  --docker-email=%DOCKER_EMAIL%

echo Set up complete.
pause