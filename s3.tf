resource "aws_s3_bucket" "Kinesis" {
  bucket = "stream-firehose-sqs"
  acl    = "private"

  tags = {
    Name = "Kinesis"
  }
}


