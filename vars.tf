variable "region" {
  default = "eu-west-1"
 }

variable "app_name" {
  default = "aqua-kinesis"
}

variable "shard_count" {
  default = "1"
}

variable "retention_period" {
  default = "50"
}

variable "shard_level_metrics" {
  type    = "list"
  default = ["IncomingByte", "OutgoingByte"]
}

variable "s3_bucket_arn" {
  default = "arn:aws:s3:::stream-firehose-sqs"
}

variable "s3_bucket_path" {
  default = "s3://kinesis"
}

variable "storage_input_format" {
  default     = "TextInputFormat"
}

variable "storage_output_format" {
  default     = "IgnoreKeyTextOutputFormat"
}
