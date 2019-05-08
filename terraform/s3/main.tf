provider "aws" {
  region                      = "eu-west-1"
  version                     = "~> 2.9"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "XXX"
  secret_key                  = "XXX"

  endpoints {
    s3  = "http://localhost:4572"
    sqs = "http://localhost:4576"
  }
}

variable "name" {
  type    = "string"
  default = "dds"
}

resource "aws_s3_bucket" "dds" {
  bucket = "${var.name}"

}
