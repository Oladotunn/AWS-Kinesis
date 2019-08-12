resource "aws_iam_role" "firehose_role" {
  name               = "firehose_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "read_policy" {
  name = "firehose-role"
  role = "${aws_iam_role.firehose_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
       { 
            "Effect": "Allow",
            "Action": [
                "kinesis:*"
            ],
            "Resource": [
                "*"
            ]
        },
	{
          "Effect": "Allow",
          "Action": [
              "glue:GetTableVersions"
          ],
          "Resource": [
              "*"
          ]
       },
	{
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::kinesis",
              "arn:aws:s3:::kinesis/*"
            ]
        },
 	{
            "Effect": "Allow",
            "Action": [
              "sqs:*"
            ],
            "Resource": [
              "arn:aws:sqs:::terraform_queue",
              "arn:aws:sqs:::terraform_queue/*"
            ]
        }

    ]
}
 
          
EOF

}

