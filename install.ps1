$output = [string] (aws iam create-role --role-name lambda-sqs-ssm --assume-role-policy-document file://role.json)

$role_info = ConvertFrom-Json $output
$arn_info = $role_info.Role.Arn

"Created new Role's ARN:" + $arn_info

aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --role-name lambda-sqs-ssm
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonSSMFullAccess --role-name lambda-sqs-ssm
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AWSLambdaExecute --role-name lambda-sqs-ssm

aws lambda create-function --function-name getEDPToken --runtime python3.7 --role $arn_info --handler lambda_function.lambda_handler --timeout 5 --zip-file fileb://getEDPToken.zip --region us-east-1
aws lambda create-function --function-name subscribeResearch --runtime python3.7 --role $arn_info --handler lambda_function.lambda_handler --timeout 5 --zip-file fileb://subscribeResearch.zip --region us-east-1
aws lambda create-function --function-name getCloudCredential --runtime python3.7 --role $arn_info --handler lambda_function.lambda_handler --timeout 3 --zip-file fileb://getCloudCredential.zip --region us-east-1
aws lambda create-function --function-name getAlertMessage --runtime python3.7 --role $arn_info --handler lambda_function.lambda_handler --timeout 10 --zip-file fileb://getAlertMessage.zip --region us-east-1
aws lambda create-function --function-name downloadDocuments --runtime python3.7 --role $arn_info --handler lambda_function.lambda_handler --timeout 10 --zip-file fileb://downloadDocuments.zip --region us-east-1