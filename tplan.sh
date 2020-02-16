#!/bin/bash
set -x # Echo everything
set -e # Exit on error
# Calling AWS STS service
#PROD_ACCT_ID="162610738325"
#ROLE_ARN="arn:aws:iam::${PROD_ACCT_ID}:role/terraform-provisioner"
#ROLE_SESSION_NAME="DeployToProd"
#TMP_FILE=".temp_credentials"
#aws sts assume-role --output json --role-arn ${ROLE_ARN} --role-session-name ${ROLE_SESSION_NAME} > ${TMP_FILE}
#export AWS_ACCESS_KEY_ID=$(cat ${TMP_FILE} | jq -r ".Credentials.AccessKeyId")
#export AWS_SECRET_ACCESS_KEY=$(cat ${TMP_FILE} | jq -r ".Credentials.SecretAccessKey")
#export AWS_SESSION_TOKEN=$(cat ${TMP_FILE} | jq -r ".Credentials.SessionToken")
#export EXPIRATION=$(cat ${TMP_FILE} | jq -r ".Credentials.Expiration")

#echo "Retrieved temp access key ${AWS_ACCESS_KEY_ID} for role ${ROLE_ARN}. Key will expire at ${EXPIRATION}"

#terraform init -get=true -force-copy

terraform init \
-backend=true \
-backend-config="bucket=helm-eks-tf-remote" \
-backend-config="dynamodb_table=terraform-state-lock-dynamo" \
-backend-config="key=tfstate" \
-backend-config="region=us-west-2" \
-get=true \
-force-copy

terraform get --update

terraform plan -out ./plan.out -lock=false $@
terraform apply -lock=false ./plan.out 