#!/bin/bash

group=$1 arn=$2

aws iam list-users --output table

aws iam detach-group-policy --group-name ${group} --policy-arn ${arn}
echo "Policy ${arn} has been detach from group ${group}"

for i in `cat users`
do
  `aws iam remove-user-from-group --user-name "$i" --group-name ${group}; \
  aws iam delete-login-profile --user-name="$i"; \
  aws iam delete-user --user-name "$i"`
done

aws iam delete-group --group-name ${group} --output table

echo "Group ${group} has been deleted"

aws iam list-users --output table