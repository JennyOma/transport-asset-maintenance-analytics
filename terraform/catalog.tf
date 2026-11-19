locals {
  datasets = {
    assets = [
      { name = "asset_id", type = "string" },
      { name = "asset_type", type = "string" },
      { name = "location", type = "string" },
      { name = "installation_date", type = "date" },
      { name = "criticality", type = "string" },
      { name = "operational_status", type = "string" }
    ]

    maintenance = [
      { name = "maintenance_id", type = "string" },
      { name = "asset_id", type = "string" },
      { name = "maintenance_date", type = "date" },
      { name = "maintenance_type", type = "string" },
      { name = "fault_category", type = "string" },
      { name = "downtime_hours", type = "double" },
      { name = "maintenance_cost_gbp", type = "decimal(12,2)" },
      { name = "status", type = "string" }
    ]

    inspections = [
      { name = "inspection_id", type = "string" },
      { name = "asset_id", type = "string" },
      { name = "inspection_date", type = "date" },
      { name = "inspection_outcome", type = "string" },
      { name = "next_due_date", type = "date" }
    ]
  }
}

resource "aws_glue_catalog_table" "transport" {
  for_each = local.datasets

  name          = each.key
  database_name = aws_glue_catalog_database.transport.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.analytics.bucket}/raw/${each.key}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim"          = ","
        "serialization.format" = ","
      }
    }

    dynamic "columns" {
      for_each = each.value

      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }
}