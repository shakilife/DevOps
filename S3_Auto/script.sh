#!/bin/bash

bucket_name=$1

new=`aws s3api create-bucket --bucket ${bucket_name} --output table`

echo "Enable versioning on ${bucket_name}"

version=`aws s3api put-bucket-versioning --bucket ${bucket_name} --versioning-configuration Status=Enabled`

echo "Public Access for ${bucket_name}"

access=`aws s3api put-public-access-block --bucket ${bucket_name} --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"`

ARN=`sed -i "s/shakil/$bucket_name/g" policy.json`

policy=`aws s3api put-bucket-policy --bucket ${bucket_name} --policy file://policy.json