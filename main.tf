
data "aws_kms_alias" "kms_encryption" {
  name = "alias/aws/s3"
}

resource "aws_glue_catalog_database" "aws_glue_database" {
  name = "aqua-kinesis-glue-database"
}

resource "aws_glue_catalog_table" "aws_glue_table" {
  name          = "aqua-kinesis-glue-table"
  database_name = "${aws_glue_catalog_database.aws_glue_database.name}"

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
  name        = "aqua-kinesis_firehose_delivery_stream"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.stream-init.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  //refer the more s3 configuration at https://docs.aws.amazon.com/firehose/latest/APIReference/API_ExtendedS3DestinationConfiguration.html
  extended_s3_configuration {
    role_arn        = aws_iam_role.firehose_role.arn
    bucket_arn      = var.s3_bucket_arn
    buffer_size     = 100
    buffer_interval = "300"

    kms_key_arn = "data.aws_kms_alias.kms_encryption.arn"

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          hive_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          orc_ser_de {}
        }
      }

      schema_configuration {
        database_name = "aws_glue_catalog_table.aws_glue_table.database_name"
        role_arn      = "aws_iam_role.firehose_role.arn"
        table_name    = "aws_glue_catalog_table.aws_glue_table.name"
        region        = "var.region"
      }
    }
  }
}
