#!/bin/sh

ENV="dev"

if [ "$1" = "prod" ]; then
  ENV="prod"
fi

echo "----------------------------------------"
echo "Formatting terraform files"
terraform fmt
echo "----------------------------------------"
terraform init
echo "----------------------------------------"
echo "Validating terraform files"
terraform validate
echo "----------------------------------------"
echo "Planning..."
terraform plan
echo "----------------------------------------"
echo "Applying..."
terraform apply -auto-approve
echo "----------------------------------------"
echo "Done!"
echo "----------------------------------------"
echo "Cleaning up plan file"
rm -rf plan.tfout
echo "----------------------------------------"
