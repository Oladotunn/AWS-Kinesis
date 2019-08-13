resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
// name the sqs queue is given

  delay_seconds             = 90
 // time the delivery of messages in the queue is delayed by

  max_message_size          = 2048
 // maximum size of individual message queue can contain

  message_retention_seconds = 86400
 // amount of time in seconds the queue service retains a message

  receive_wait_time_seconds = 10    			 
 // amount of time it takes for a message ReceiveCall to elapse before getting in another.  

  tags = {
    Name = "Kinesis"  
 // name tag of the sqs
  }
}


