# Make this file linux compatible
dos2unix ./apply-resources-plan.sh

# Create uuid for the plan
uuid=$(uuidgen)
echo "UUID: $uuid"

plan_file="destroy-$uuid.tfplan"
echo "Plan File: $plan_file"

# Make plan folder if not exists
mkdir -p ./plans

out_file="./plans/$plan_file"
echo "Out File: $out_file"

# Plan the terraform configuration
terraform plan -destroy --var-file="secrets.tfvars" -out $out_file

# Apply the terraform configuration
terraform apply "$out_file"