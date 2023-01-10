# AWS EC2 for multiples accounts and regions with Terraform module
* This module simplifies creating and configuring of the EC2 across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of EC2 configurations for this module:

- EC2
- Elastic IP
- Policy and role
- Creation of instances of types On Demand and SPOT

## Usage exemples


### Create on demand EC2 instance with basic configuration, EBS volume and SSH access 

```hcl
module "vm_test" {
  source                = "web-virtua-aws-multi-account-modules/ec2/aws"
  name                  = "tf-vm-test"
  ami                   = data.aws_ami.ubuntu_ami.id
  instance_type         = "t3a_small"
  key_pair_name         = "key-pair-east-1"
  subnet_id             = "subnet-0eff3...bde8"
  ebs_block_device      = var.ebs_block_device

  vpc_security_group_ids = [
    "sg-018620a...764c"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Create SPOT EC2 instance with basic configuration, ROOT volume, permission policy and SSH access 

```hcl
module "vm_test" {
  source                = "web-virtua-aws-multi-account-modules/ec2/aws"
  name                  = "tf-vm-test"
  ami                   = data.aws_ami.ubuntu_ami.id
  instance_type         = "t3a_small"
  key_pair_name         = "key-pair-east-1"
  subnet_id             = "subnet-0eff3...bde8"
  root_block_device     = var.root_block_device
  ec2_permission_policy = var.ec2_permission_policy
  create_spot_instance  = true

  vpc_security_group_ids = [
    "sg-018620a...764c"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Create on demand EC2 instance with advanced configuration, Root volume, EBS volume, SSH access, permission policy, creation elastic IP and run SHELL script in instance initialization 

```hcl
module "vm_test" {
  source                = "web-virtua-aws-multi-account-modules/ec2/aws"
  name                  = "tf-vm-test"
  make_elastic_ip       = true
  ami                   = data.aws_ami.ubuntu_ami.id
  instance_type         = "t3a_small"
  key_pair_name         = "key-pair-east-1"
  subnet_id             = "subnet-0eff3...bde8"
  private_ip            = "10.0.1.4"
  data_startup_script   = file("./shel-exemple-file.sh")
  root_block_device     = var.root_block_device
  ebs_optimized         = true
  ebs_block_device      = var.ebs_block_device
  ec2_permission_policy = var.ec2_permission_policy

  vpc_security_group_ids = [
    "sg-018620a...764c"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| vpc_id | `string` | `-` | yes | Name to instance | `-` |
| ami | `string` | `-` | yes | AMI type Instance | `-` |
| subnet_id | `string` | `-` | yes | Subnet ID | `-` |
| private_ip | `string` | `null` | no | If null a ramdom private IP will be defined | `-` |
| vpc_security_group_ids | `list(string)` | `[]` | no | ID's of the security groups | `-` |
| instance_type | `string` | `t2.micro` | no | Instance type | `-` |
| key_pair_name | `string` | `-` | no | Key Pair to Access SSH | `-` |
| monitoring | `bool` | `true` | no | If true will be enable the monitoring | `*`false <br> `*`true |
| disable_api_termination | `bool` | `false` | no | Enable or Disable API termination | `*`false <br> `*`true |
| associate_public_ip_address | `bool` | `true` | no | If true will be associate a public IP to instance | `*`false <br> `*`true |
| data_startup_script | `string` | `-` | no | Shell script to run when starting instance | `-` |
| iam_instance_profile_name | `string` | `null` | no | The name of the existing IAM profile to attach to the instance granting permissions to the instance, if null this module will allow creating the IAM profile or not defining any profile | `-` |
| cpu_core_count | `number` | `null` | no | Sets the number of CPU cores for an instance, check supported instances type for this configuration: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values | `-` |
| cpu_threads_per_core | `number` | `null` | no | Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set) | `-` |
| hibernation | `bool` | `null` | no | If true, the launched EC2 instance will support hibernation | `*`false <br> `*`true |
| availability_zone | `string` | `null` | no | AZ to start the instance in | `-` |
| secondary_private_ips | `list(string)` | `null` | no | A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a network_interface block | `-` |
| ipv6_address_count | `number` | `null` | no | A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet | `-` |
| ipv6_addresses | `list(string)` | `null` | no | Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface | `-` |
| ebs_optimized | `bool` | `null` | no | If true, the launched EC2 instance will be EBS-optimized | `*`false <br> `*`true |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to instance, volume and elastic IP | `*`false <br> `*`true |
| ou_name | `string` | `no` | no | Organization unit name | `-` |
| tags | `map(any)` | `object` | no | Tags to EC2 instance | `-` |
| tags_eip | `map(any)` | `object` | no | Tags to EC2 elastic IP | `-` |
| tags_volume | `map(any)` | `object` | no | Tags to EC2 volumes | `-` |
| ec2_policy_path | `string` | `/` | no | Path to EC2 policy | `-` |
| ec2_permission_policy | `any` | `null` | no | Policy with the permissions to EC2, should be fomated as json | `-` |
| ec2_assume_role | `any` | `object` | no | Policy with the permissions to EC2, should be fomated as json | `-` |
| make_elastic_ip | `bool` | `false` | no | If true the static_ip_id variable, will be created one elastic ip | `*`false <br> `*`true |
| static_ip_id | `string` | `null` | no | Static IP ID, if this variable configured, this IP will be used e don't create a new elastic ip even if make_elastic_ip defined as true | `-` |
| create_spot_instance | `bool` | `false` | no | If true create a spot instance, if false create a on demand instance | `*`false <br> `*`true |
| spot_price | `string` | `null` | no | The maximum price to request on the spot market. Defaults to on-demand price, exemple value 0.018 | `-` |
| spot_wait_for_fulfillment | `bool` | `null` | no | If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached | `*`false <br> `*`true |
| spot_type | `string` | `null` | no | "If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent`, can be one-time or persistent | `*`persistent <br> `*`one-time |
| spot_launch_group | `string` | `null` | no | A launch group is a group of spot instances that launch together and terminate together. If left empty instances are launched and terminated individually | `-` |
| spot_block_duration_minutes | `number` | `null` | no | The required duration for the Spot instances, in minutes. This value must be a multiple of 60 (60, 120, 180, 240, 300, or 360) | `-` |
| spot_instance_interruption_behavior | `string` | `null` | no | Indicates Spot instance behavior when it is interrupted. Valid values are `terminate`, `stop`, or `hibernate` | `-` |
| spot_valid_until | `string` | `null` | no | The end date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ) | `-` |
| spot_valid_from | `string` | `null` | no | The start date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ) | `-` |
| ebs_block_device | `list(object)` | `-` | no | Define the EBS volume configurations to instance | `-` |
| root_block_device | `list(object)` | `-` | no | Define the ROOT volume configurations to instance | `-` |
| ephemeral_block_device | `list(object)` | `-` | no | Define the ephemeral volume configurations to instance, the virtual_name should be have the patter ephemeral<NUMBER>, if any volume cofigured a default volume will be making | `-` |

* Model of variable ec2_permission_policy
```hcl
variable "ec2_permission_policy" {
  description = "Policy with the permissions to EC2"
  type        = any
  default = {
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Getobject",
          "s3:List*"
        ]
        "Resource" : [
          "*"
        ]
      }
    ]
  }
}
```

* Model of variable ebs_block_device
```hcl
variable "ebs_block_device" {
  description = "Define the EBS volume configurations to instance"
  type = list(object({
    volume_size           = number
    device_name           = optional(string, "/dev/sda1")
    volume_type           = optional(string, "gp3")
    encrypted             = optional(bool, false)
    iops                  = optional(number, 3000)
    throughput            = optional(number, 125)
    snapshot_id           = optional(string, null)
    delete_on_termination = optional(bool, false)
    kms_key_id            = optional(string, null)
    tags                  = optional(map(any), {})
  }))
  default = [
    {
      volume_size           = 21
    },
    {
      device_name           = "/dev/sda2"
      volume_size           = 11
      volume_type           = "gp3"
      encrypted             = false
      iops                  = 3000
      throughput            = 125
      delete_on_termination = true
      snapshot_id           = "snap-0eccc...fa2"
    },
  ]
}
```

* Model of variable root_block_device
```hcl
variable "root_block_device" {
  description = "Define the ROOT volume configurations to instance"
  type = list(object({
    volume_size           = number
    volume_type           = optional(string, "gp3")
    encrypted             = optional(bool, false)
    iops                  = optional(number, 3000)
    throughput            = optional(number, 125)
    delete_on_termination = optional(bool, true)
    kms_key_id            = optional(string, null)
    tags                  = optional(map(any), {})
  }))
  default = [
    {
      volume_size = 12
    },
  ]
}
```

* Model of variable ephemeral_block_device
```hcl
variable "ephemeral_block_device" {
  description = "Define the ephemeral volume configurations to instance"
  type = list(object({
    virtual_name = optional(string, "ephemeral1")
    device_name  = optional(string, "/dev/sdf")
    no_device    = optional(string, null)
  }))
  default = [
    {
      device_name  = "/dev/sdf"
      virtual_name = "ephemeral1"
    },
  ]
}
```

## Resources

| Name | Type |
|------|------|
| [aws_eip.create_elastic_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.create_association_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.create_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_spot_instance_request.create_ec2_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |
| [aws_iam_policy.create_ec2_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.create_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_attachment.create_ec2_attachment_policy_role](https://registry.terraform.io/providers/hashicorp/aws/3.29.1/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_instance_profile.create_ec2_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `ec2` | All EC2 informations |
| `ec2_type` | EC2 instance type |
| `ec2_tags_defatul` | EC2 instance default tags |
| `ec2_arn` | EC2 ARN |
| `ebs_block_device` | EC2 EBS block device |
| `root_block_device` | EC2 ROOT block device |
| `ephemeral_block_device` | EC2 ephemeral block device |
| `instance_state` | The state of the instance |
| `private_dns` | The private DNS name assigned to the instance |
| `public_dns` | The public DNS name assigned to the instance |
| `public_ip` | The public IP address assigned to the instance, if applicable |
| `private_ip` | The private IP address assigned to the instance |
| `ec2_instance_id` | The Instance ID |
