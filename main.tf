
data "aws_kms_alias" "kms_encryption" {
//name of encryption
name = "alias/aws/s3"
}

resource "aws_glue_catalog_database" "aws_glue_database" {
name = "aqua-kinesis-glue-database"
}

resource "aws_glue_catalog_table" "aws_glue_table" {
  name          = "aqua-kinesis-glue-table"
  database_name = "aqua-kinesis-glue-database"

  // Please refere the for more detail configuration of parameters at https://www.terraform.io/docs/providers/aws/r/glue_catalog_table.html
 /*
  parameters {
    classification = "parquet"
  }
*/
  storage_descriptor {
    location      = "s3://kinesis"
    input_format  = "TextInputFormat"
    output_format = "IgnoreKeyTextOutputFormat"


    columns   {
        name = "user_name"
        type = "string"
      }

     columns {
        name = "email"
        type = "string"
      }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
// name of the firehose delivery stream 
  name        = "aqua-kinesis_firehose_delivery_stream"

// destination the firehose will be stored
  destination = "extended_s3" 					

  kinesis_source_configuration {
// resource name for the kinesis stream used as the firehose source
    kinesis_stream_arn = aws_kinesis_stream.stream-init.arn

// iam role that provides access to the source kinesis stream
    role_arn           = aws_iam_role.firehose_role.arn			
  }

  extended_s3_configuration {
    role_arn        = aws_iam_role.firehose_role.arn

 // arn for the bucket
    bucket_arn      = var.s3_bucket_arn

// size the incoming data is buffered into (in mb) before getting to the destination
    buffer_size     = 100

// time period to which incoming data should be buffered
    buffer_interval = "300"						

// KMS key ARN the stream will use for its data encryption
    kms_key_arn = data.aws_kms_alias.kms_encryption.arn		

    data_format_conversion_configuration {
// argument for the de/serializer, schema configuration to convert data from JSON format to parquet or orc format before                                                                                writing to the s3 bucket
      
    input_format_configuration {
        deserializer {

// the Apache Hive JSON SerDe that basically contains the time, date format
          hive_json_ser_de {}						 
        }
      }

      output_format_configuration {
        serializer {

// specifies to store in the ORC format before storage in the s3
          orc_ser_de {}							
        }
      }

      schema_configuration {
// specifies aws glue database that contains the schema for the output data
   	database_name = "aqua-kinesis-glue-database"

// role arn the stream uses to access the glue
	role_arn      = aws_iam_role.firehose_role.arn

// contains glue table that contains column details that constitutes schema info
        table_name    = "aqua-kinesis-glue-table"

// region for the resource
        region        = "eu-west-1"						
      }
    }
  }
}

