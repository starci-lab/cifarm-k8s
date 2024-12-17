rem Generate a GUID using PowerShell and assign it to a variable
for /f "delims=" %%i in ('powershell -command "[guid]::NewGuid().ToString()"') do set GUID=%%i

rem Display the generated GUID (for verification)
echo Generated GUID: %GUID%

rem Specify the relative path to your variable file
set VAR_FILE="secrets.tfvars"

rem Get the absolute path of the variable file
for %%A in (%VAR_FILE%) do set VAR_FILE_ABS_PATH=%%~fA

rem Display the absolute path of the variable file for verification
echo Variable file absolute path: %VAR_FILE_ABS_PATH%

rem Check if the plans directory exists, create it if not
if not exist "plans" (
    echo Creating plans directory...
    mkdir plans
)

rem Get the absolute path of the plans directory
for %%A in ("%cd%\plans") do set PLANS_ABS_PATH=%%~fA

rem Display the absolute path for verification
echo Plans directory absolute path: %PLANS_ABS_PATH%

rem Run terragrunt plan with the generated GUID as part of the filename
terragrunt run-all apply -destroy -auto-approve -var-file="%VAR_FILE_ABS_PATH%"