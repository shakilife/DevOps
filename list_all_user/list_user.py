import boto3
#aws_mag_con=boto3.session.Session(profile_name="default")
#iam_con_cli=aws_mag_con.client(service_name="iam")
iam_con=boto3.client(service_name="iam")

#List all IAM user using client object

response=iam_con.list_users()
for each_item in response['Users']:
    print(each_item['UserName'],each_item['UserId'],each_item['Arn'])
