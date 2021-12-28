#! /bin/bash

# AWS cli command to create IAM user
aws iam create-user --user-name ${user}

aws iam create-login-profile --user-name ${user} --password Welcome123 --password-reset-required

aws iam attach-user-policy --user-name=${user} --policy-arn=${ARN}

