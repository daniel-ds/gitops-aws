provider "aws" {
  region                      = "eu-west-1"
  version                     = "~> 2.9"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "XXX"
  secret_key                  = "XXX"

  endpoints {
    s3  = "http://localstack-localstack:4572"
    sqs = "http://localstack-localstack:4576"
  }
}

variable name {
  type    = "string"
  default = "dds"
}

resource "aws_sqs_queue" "dds" {
  name = "${var.name}"
}
