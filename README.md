# F5-XC-AWS-MULTINODE
This repository consists of Terraform templates to bring up a F5XC AWC VPC multi node environment.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-aws-vpc-multinode`
- Enter repository directory with: `cd f5-xc-aws-vpc-multinode`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

## Multi Node Single NIC and new subnet module usage example

````hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "f5xc_api_p12_file" {
  type    = string
}

variable "f5xc_api_url" {
  type    = string
}

variable "f5xc_api_token" {
  type    = string
}

variable "f5xc_tenant" {
  type    = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_aws_cred" {
  type    = string
  default = "ck-aws-01"
}

variable "owner_tag" {
  type    = string
  default = "c.klewar@f5.com"
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

module "f5xc_aws_vpc_single_node_single_nic_new_vpc_new_subnet" {
  source                    = "./modules/f5xc/site/aws/vpc"
  f5xc_api_url              = var.f5xc_api_url
  f5xc_api_token            = var.f5xc_api_token
  f5xc_namespace            = var.f5xc_namespace
  f5xc_tenant               = var.f5xc_tenant
  f5xc_aws_region           = "us-east-2"
  f5xc_aws_cred             = var.f5xc_aws_cred
  f5xc_aws_vpc_site_name    = format("%s-vpc-sn-snic-new-vpc-and-snet-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_name_tag     = format("%s-vpc-sn-snic-new-vpc-and-snet-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_primary_ipv4 = "192.168.168.0/21"
  f5xc_aws_ce_gw_type       = "single_nic"
  f5xc_aws_vpc_az_nodes     = {
    node0 = { f5xc_aws_vpc_local_subnet = "192.168.168.0/26", f5xc_aws_vpc_az_name = "us-east-2a" },
  }
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_no_worker_nodes         = true
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_use_http_https_port_sli = true
  f5xc_labels                          = { "aws-env" = "shared" }
  public_ssh_key                       = "ssh-rsa xyz"
  custom_tags                          = {
    Owner = var.owner_tag
  }
  providers = {
    aws      = aws.us-east-2
    volterra = volterra.default
  }
}
````

## Multi Node Multi NIC and new subnet module usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

module "aws_vpc_multi_node_multi_nic_new_subnet" {
  source                          = "./modules/f5xc/site/aws/vpc"
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_api_token                  = var.f5xc_api_token
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_vpc_site_name          = format("%s-vpc-multi-node-multi-nic-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_name_tag           = format("%s-vpc-multi-node-multi-nic-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_primary_ipv4       = "192.168.168.0/21"
  f5xc_aws_vpc_total_worker_nodes = 2
  f5xc_aws_ce_gw_type             = "multi_nic"
  f5xc_aws_vpc_az_nodes           = {
    node0 = {
      f5xc_aws_vpc_workload_subnet = "192.168.168.0/26", f5xc_aws_vpc_inside_subnet = "192.168.168.64/26",
      f5xc_aws_vpc_outside_subnet  = "192.168.168.128/26", f5xc_aws_vpc_az_name = "us-east-2a"
    },
    node1 = {
      f5xc_aws_vpc_workload_subnet = "192.168.169.0/26", f5xc_aws_vpc_inside_subnet = "192.168.169.64/26",
      f5xc_aws_vpc_outside_subnet  = "192.168.169.128/26", f5xc_aws_vpc_az_name = "us-east-2a"
    },
    node2 = {
      f5xc_aws_vpc_workload_subnet = "192.168.170.0/26", f5xc_aws_vpc_inside_subnet = "192.168.170.64/26",
      f5xc_aws_vpc_outside_subnet  = "192.168.170.128/26", f5xc_aws_vpc_az_name = "us-east-2a"
    }
  }
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_no_worker_nodes         = false
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_use_http_https_port_sli = true
  public_ssh_key                       = "ssh-rsa xyz"
  custom_tags                          = {
    Owner = "c.klewar@f5.com"
  }
  providers = {
    aws      = aws.us-east-2
    volterra = volterra.default
  }
}
```

## Multi Node Single NIC and existing subnet module usage example

````hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

module "aws_vpc_multi_node_single_nic_existing_subnets" {
  source                          = "./modules/f5xc/site/aws/vpc"
  f5xc_api_url              = var.f5xc_api_url
  f5xc_api_token            = var.f5xc_api_token
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "cred-aws-01"
  f5xc_aws_vpc_site_name          = format("%s-vpc-multi-node-single-nic-existing-subnet-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_name_tag           = format("%s-vpc-multi-node-single-nic-existing-subnet-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_total_worker_nodes = 2
  f5xc_aws_ce_gw_type             = "single_nic"
  f5xc_aws_vpc_existing_id        = "vpc_id_abc"
  f5xc_aws_vpc_az_nodes           = {
    node0 = { f5xc_aws_vpc_local_existing_subnet_id = "node0_subnet_id", f5xc_aws_vpc_az_name = "us-east-2a" },
    node1 = { f5xc_aws_vpc_local_existing_subnet_id = "node1_subnet_id", f5xc_aws_vpc_az_name = "us-east-2a" },
    node2 = { f5xc_aws_vpc_local_existing_subnet_id = "node2_subnet_id", f5xc_aws_vpc_az_name = "us-east-2a" }
  }
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_no_worker_nodes         = false
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_use_http_https_port_sli = true
  public_ssh_key                       = "ssh-rsa xyz"
  custom_tags                          = {
    Owner = "c.klewar@f5.com"
  }
  providers = {
    aws      = aws.us-east-2
    volterra = volterra.default
  }
}
````

## Multi Node Multi NIC and existing subnet module usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

module "aws_vpc_multi_node_multi_nic_existing_subnet" {
  source                          = "./modules/f5xc/site/aws/vpc"
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_api_token                  = var.f5xc_api_token
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_vpc_site_name          = format("%s-vpc-multi-node-multi-nic-existing-subnet-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_name_tag           = format("%s-vpc-multi-node-single-nic-existing-subnet-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_vpc_total_worker_nodes = 2
  f5xc_aws_vpc_existing_id        = "vpc_id_abc"
  f5xc_aws_ce_gw_type             = "multi_nic"
  f5xc_aws_vpc_az_nodes           = {
    node0 = {
      f5xc_aws_vpc_workload_existing_subnet_id = "node0_subnet_workload_id",
      f5xc_aws_vpc_inside_existing_subnet_id   = "node0_subnet_inside_id",
      f5xc_aws_vpc_outside_existing_subnet_id  = "node0_subnet_outside_id", f5xc_aws_vpc_az_name = "us-east-2a"
    },
    node1 = {
      f5xc_aws_vpc_workload_existing_subnet_id = "node1_subnet_workload_id",
      f5xc_aws_vpc_inside_existing_subnet_id   = "node1_subnet_inside_id",
      f5xc_aws_vpc_outside_existing_subnet_id  = "node1_subnet_outside_id", f5xc_aws_vpc_az_name = "us-east-2a"
    },
    node2 = {
      f5xc_aws_vpc_workload_existing_subnet_id = "node2_subnet_workload_id",
      f5xc_aws_vpc_inside_existing_subnet_id   = "node2_subnet_inside_id",
      f5xc_aws_vpc_outside_existing_subnet_id  = "node2_subnet_outside_id", f5xc_aws_vpc_az_name = "us-east-2a"
    }
  }
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_no_worker_nodes         = false
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_use_http_https_port_sli = true
  public_ssh_key                       = "ssh-rsa xyz"
  custom_tags                          = {
    Owner = "c.klewar@f5.com"
  }
  providers = {
    aws      = aws.us-east-2
    volterra = volterra.default
  }
}
```
