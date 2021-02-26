#!/bin/sh
export AWS_ACCESS_KEY_ID="AKIAS6ER3OA233I33AOG"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-east-1"
ENV="dev"

if [ "$1" = "prod" ]; then
  ENV="prod"
fi

terraform destroy -var-file="${ENV}/terraform.tfvars" -auto-approve
rm -rf .terraform

echo "----------------------------------------"
echo "Done!"
echo "----------------------------------------"