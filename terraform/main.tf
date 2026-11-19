terraform {
  required_version = ">= 1.17.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Project     = "TransportAssetAnalytics"
      Environment = "Learning"
      ManagedBy   = "Terraform"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "analytics" {
  bucket        = "transport-asset-analytics-${random_id.suffix.hex}"
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_glue_catalog_database" "transport" {
  name        = "transport_asset_analytics"
  description = "Synthetic transport maintenance and inspection data"
}

resource "aws_athena_workgroup" "transport" {
  force_destroy = true
  name          = "transport-analytics-lab"
  description   = "Dedicated transport analytics workgroup"

  configuration {
    enforce_workgroup_configuration    = true
    bytes_scanned_cutoff_per_query     = 10485760
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location = "s3://${aws_s3_bucket.analytics.bucket}/athena-results/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}

output "analytics_bucket" {
  description = "Private S3 analytics bucket"
  value       = aws_s3_bucket.analytics.bucket
}

output "glue_database" {
  value = aws_glue_catalog_database.transport.name
}

output "athena_workgroup" {
  value = aws_athena_workgroup.transport.name
}