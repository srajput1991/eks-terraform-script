#
# Provider Configuration

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.7.0"
}

provider "local" {
  version = "~> 1.2.1"
}

provider "null" {
  version = "~> 2.1.1"
}

provider "template" {
  version = "~> 2.1.1"
}
