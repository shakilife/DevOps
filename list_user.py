import boto3
iam_con=boto3.resource(service_name="iam")
for each_user in iam_con.users.all():
    print(each_user.name)
