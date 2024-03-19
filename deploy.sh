helm repo update
cd Infra
terraform init -upgrade
terraform fmt
terraform validate
terraform apply --auto-approve
cd ../Deployment
terraform init -upgrade
terraform fmt
terraform validate
terraform apply --auto-approve
cd ../new_relic
terraform init -upgrade
terraform fmt
terraform validate
terraform apply --auto-approve