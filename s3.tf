resource "aws_s3_bucket" "Kinesis" {
  bucket = "stream-firehose-sqs"
// bucket name to which the stream will be stored

  acl    = "private" 
// Access Control List set to private, can only be controlled by the user

  tags = {
// Name tag as would be displayed on the console
    Name = "Kinesis" 
  }
}
 


