#! /bin/bash

# AWS cli command to create IAM user
$1 $2
aws iam create-user --user-name $1

aws iam create-login-profile --user-name $1 --password Welcome123 --password-reset-required

aws iam attach-user-policy --user-name=$1 --policy-arn=$2

