resource "aws_iam_policy" "yap-dynamodb-read" {
    name = "yap-dynamodb-read"
    description = "resource policy for ec2 role to access DynamoDB table"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:DescribeImport",
                "dynamodb:ConditionCheckItem",
                "dynamodb:DescribeContributorInsights",
                "dynamodb:Scan",
                "dynamodb:ListTagsOfResource",
                "dynamodb:Query",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:DescribeGlobalTableSettings",
                "dynamodb:PartiQLSelect",
                "dynamodb:DescribeTable",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeGlobalTable",
                "dynamodb:GetItem",
                "dynamodb:DescribeContinuousBackups",
                "dynamodb:DescribeExport",
                "dynamodb:GetResourcePolicy",
                "dynamodb:DescribeKinesisStreamingDestination",
                "dynamodb:DescribeBackup",
                "dynamodb:GetRecords",
                "dynamodb:DescribeTableReplicaAutoScaling"
            ],
            "Resource": "arn:aws:dynamodb:ap-southeast-1:255945442255:table/yap-bookinventory"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "dynamodb:ListContributorInsights",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:ListGlobalTables",
                "dynamodb:ListTables",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:ListBackups",
                "dynamodb:GetAbacStatus",
                "dynamodb:ListImports",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeEndpoints",
                "dynamodb:ListExports",
                "dynamodb:ListStreams"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_policy_attachment" "custom-dynamodb-read" {
  name       = "custom-dynamodb-read"
  roles      = [aws_iam_role.ec2_role_terraform.name]
  policy_arn = "arn:aws:iam::255945442255:policy/yap-dynamodb-read"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "yap_ec2_profile"
  role = aws_iam_role.ec2_role_terraform.name
}