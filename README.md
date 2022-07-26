# F5-XC-AWS-MULTINODE
This repository consists of Terraform templates to bring up a F5XC AWC VPC multi node environment.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-aws-vpc-multinode`
- Enter repository directory with: `cd f5-xc-aws-vpc-multinode`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

### Example Output

```bash
module.aws_vpc_multi_node.volterra_aws_vpc_site.aws_vpc_site: Creating...
module.aws_vpc_multi_node.volterra_aws_vpc_site.aws_vpc_site: Creation complete after 2s [id=6c0bdc4e-7c1a-4d62-9612-5aaa6a82dacd]
module.aws_vpc_multi_node.volterra_tf_params_action.aws_vpc_action: Creating...
module.aws_vpc_multi_node.volterra_tf_params_action.aws_vpc_action: Still creating... [15m0s elapsed]
module.aws_vpc_multi_node.volterra_tf_params_action.aws_vpc_action: Still creating... [15m10s elapsed]
module.aws_vpc_multi_node.volterra_tf_params_action.aws_vpc_action: Still creating... [15m20s elapsed]
module.aws_vpc_multi_node.volterra_tf_params_action.aws_vpc_action: Still creating... [15m30s elapsed]
module.aws_vpc_multi_node.volterra_tf_params_action.aws_vpc_action: Creation complete after 15m37s [id=3ddb370e-a821-4d61-b6f9-0b73144bbc7a]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```


## Single NIC module usage example

````hcl
module "aws_vpc_multi_node" {
  source                          = "./modules/f5xc/site/aws/vpc"
  f5xc_api_p12_file               = "cert/api-creds.p12"
  f5xc_api_url                    = "https://playground.staging.volterra.us/api"
  f5xc_namespace                  = "system"
  f5xc_tenant                     = "playground-wtppvaog"
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "ck-aws-01"
  f5xc_aws_vpc_site_name          = "ck-aws-vpc-multi-node-03"
  f5xc_aws_vpc_name_tag           = ""
  f5xc_aws_vpc_az_name            = "us-east-2a"
  f5xc_aws_vpc_primary_ipv4       = "192.168.168.0/21"
  f5xc_aws_vpc_total_worker_nodes = 2
  f5xc_aws_ce_gw_type             = "single_nic"
  f5xc_aws_vpc_az_nodes           = {
    node0 = { f5xc_aws_vpc_local_subnet = "192.168.168.0/26", f5xc_aws_vpc_az_name = "us-east-2a"},
    node1 = { f5xc_aws_vpc_local_subnet = "192.168.169.0/26", f5xc_aws_vpc_az_name = "us-east-2a"},
    node2 = { f5xc_aws_vpc_local_subnet = "192.168.170.0/26", f5xc_aws_vpc_az_name = "us-east-2a"}
  }
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_no_worker_nodes         = false
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_use_http_https_port_sli = true
  public_ssh_key                       = "ssh-rsa xyz"
}
````

## Multi NIC module usage example

````hcl
module "aws_vpc_multi_node" {
  source                          = "./modules/f5xc/site/aws/vpc"
  f5xc_api_p12_file               = "cert/api-creds.p12"
  f5xc_api_url                    = "https://playground.staging.volterra.us/api"
  f5xc_namespace                  = "system"
  f5xc_tenant                     = "playground"
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_vpc_site_name          = "aws-vpc-multi-node-03"
  f5xc_aws_vpc_name_tag           = ""
  f5xc_aws_vpc_az_name            = "us-east-2a"
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
}
````
