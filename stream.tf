resource "aws_kinesis_stream" "stream-init" {
  name 			= "1st_stream"
  shard_count		= 1
  retention_period	= 50	
shard_level_metrics	= ["IncomingBytes", "OutgoingBytes"]

}
