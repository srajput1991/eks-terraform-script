#!/bin/bash

set -x # Echo everything
set -e # Exit on error

#AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
#export AWS_SHARED_CREDENTIALS_FILE


terraform init \
-backend=true \
-backend-config="bucket=helm-eks-tf-remote" \
-backend-config="dynamodb_table=terraform-state-lock-dynamo" \
-backend-config="key=tfstate" \
-backend-config="region=us-west-2" \
-get=true \
-force-copy

terraform get --update

terraform destroy $@