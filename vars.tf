variable "region" {
  default = "eu-west-1"
 // region the resources to be launched
 }

variable "app_name" {		 
  default = "aqua-kinesis"
}

variable "shard_count" {
 // amount of shards the stream will use (shard )
  default = "1"
}

variable "retention_period" {
 // amount of time in seconds the queue service retains a message
  default = "50"
}

variable "shard_level_metrics" {
// unit for monitoring the cloudwatch metrics

  type    = "list"
  default = ["IncomingByte", "OutgoingByte"]
// incomingbyte is the number of byte put to the shard successfully over a period of time, outgoingbyte is the number of byte received from ththe shard over a period of time
}

variable "s3_bucket_arn" {
  default = "arn:aws:s3:::stream-firehose-sqs"
// amazon resource name for the bucket
}

variable "s3_bucket_path" {
// console directory to the bucket
  default = "s3://kinesis"			
}

variable "storage_input_format" {
  default     = "TextInputFormat"		 
}

variable "storage_output_format" {
  default     = "IgnoreKeyTextOutputFormat"
}
 

