terraform {
  backend "s3" {
    region  = "us-gov-west-1"
    bucket  = "BUCKETNAME"
    key     = "ORGANIZATION/REPOSITORY/terraform.tfstate"
    encrypt = "true"
  }
}
