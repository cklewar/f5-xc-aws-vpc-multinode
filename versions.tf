terraform {
  required_version = ">= 1.3.0"
  cloud {
    organization = "cklewar"
    hostname     = "app.terraform.io"

    workspaces {
      name = "f5-xc-aws-vpc-multinode-module"
    }
  }
  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "= 0.11.23"
    }
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.33.0"
    }
    local = ">= 2.2.3"
    null = ">= 3.1.1"
  }
}