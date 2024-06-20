### AppFlow - Flow - Salesforce to S3 
resource "aws_appflow_flow" "test_flow" {
  provider = aws.pivot
  name     = "${var.customer}_test_flow"

  destination_flow_config {
    connector_type = "S3"
    destination_connector_properties {
      s3 {
        bucket_name = aws_s3_bucket.bucket_pivot.id
        bucket_prefix = "salesforce-data"
        s3_output_format_config {
          file_type                   = "JSON"
          preserve_source_data_typing = false

          aggregation_config {
            aggregation_type = "None"
            target_file_size = 0
          }
          prefix_config {
            prefix_type = "PATH"
          }
        }
      }
    }
  }

  source_flow_config {
    connector_type         = "Salesforce"
    connector_profile_name = var.sfdc_connection_name
    source_connector_properties {

      salesforce {
        enable_dynamic_field_update = false
        include_deleted_records     = false
        object                      = "Account"
      }

    }
  }



  task {
    destination_field = "Id"
    source_fields = [
      "Id",
    ]
    task_properties = {
      "DESTINATION_DATA_TYPE" = "string"
      "SOURCE_DATA_TYPE"      = "string"
    }
    task_type = "Map"

    connector_operator {
      salesforce = "NO_OP"
    }
  }

  task {
    source_fields = []
    task_properties = {}
    task_type       = "Map_all"

    connector_operator {
      salesforce = "NO_OP"
    }
  }

  trigger_config {
    trigger_type = "Event"
  }
}

