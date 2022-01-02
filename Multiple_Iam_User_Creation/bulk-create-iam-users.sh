#!/bin/bash

group=$1 arn=$2

aws iam create-group --group-name ${group} --output table

echo "Group ${group} has been created"

aws iam attach-group-policy --group-name ${group} --policy-arn ${arn}

echo "Policy ${arn} has been assign to group ${group}"

for i in `cat users`
do
  `aws iam create-user --user-name "$i"; \
  aws iam attach-user-policy --user-name="$i" --policy-arn="$2" ; \
  aws iam create-login-profile --user-name="$i" --password='Welcome123' --password-reset-required ; \
  aws iam add-user-to-group --user-name "$i" --group-name ${group}`
done

aws iam list-users --output table