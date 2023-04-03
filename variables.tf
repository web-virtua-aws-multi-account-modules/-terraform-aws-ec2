variable "name" {
  description = "Name to instance"
  type        = string
}

variable "ami" {
  description = "AMI type Instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "private_ip" {
  description = "If null a ramdom private IP will be defined"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "ID's of the security groups"
  type        = list(any)
  default     = []
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Key Pair to Access SSH"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "If true will be enable the monitoring"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "Enable or Disable API termination"
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "If true will be associate a public IP to instance"
  type        = bool
  default     = true
}

variable "data_startup_script" {
  description = "Shell script to run when starting instance"
  type        = string
  default     = ""
}

variable "iam_instance_profile_name" {
  description = "The name of the existing IAM profile to attach to the instance granting permissions to the instance, if null this module will allow creating the IAM profile or not defining any profile"
  type        = string
  default     = null
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance, check supported instances type for this configuration: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values"
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)"
  type        = number
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block`"
  type        = list(string)
  default     = null
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "use_tags_default" {
  description = "If true will be use the tags default to instance, volume and elastic IP"
  type        = bool
  default     = true
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}

variable "tags" {
  description = "Tags to EC2 instance"
  type        = map(any)
  default     = {}
}

variable "tags_eip" {
  description = "Tags to EC2 elastic IP"
  type        = map(any)
  default     = {}
}

variable "tags_volume" {
  description = "Tags to EC2 volumes"
  type        = map(any)
  default     = {}
}

variable "ec2_policy_path" {
  description = "Path to EC2 policy"
  type        = string
  default     = "/"
}

variable "ec2_permission_policy" {
  description = "Policy with the permissions to EC2, should be fomated as json"
  type        = any
  default     = null
}

variable "ec2_assume_role" {
  description = "Assume role to EC2"
  type        = any
  default = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid" : ""
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
      }
    ]
  }
}

#######################################
# Elastic IP configuration
#######################################
variable "make_elastic_ip" {
  description = "If true the static_ip_id variable, will be created one elastic ip"
  type        = bool
  default     = false
}

variable "static_ip_id" {
  description = "Static IP ID, if this variable configured, this IP will be used e don't create a new elastic ip even if make_elastic_ip defined as true"
  type        = string
  default     = null
}

#######################################
# Spot variables
#######################################
variable "create_spot_instance" {
  description = "If true create a spot instance, if false create a on demand instance"
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "The maximum price to request on the spot market. Defaults to on-demand price, exemple value 0.018"
  type        = string
  default     = null
}

variable "spot_wait_for_fulfillment" {
  description = "If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached"
  type        = bool
  default     = null
}

variable "spot_type" {
  description = "If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent`, can be one-time or persistent"
  type        = string
  default     = null
}

variable "spot_launch_group" {
  description = "A launch group is a group of spot instances that launch together and terminate together. If left empty instances are launched and terminated individually"
  type        = string
  default     = null
}

variable "spot_block_duration_minutes" {
  description = "The required duration for the Spot instances, in minutes. This value must be a multiple of 60 (60, 120, 180, 240, 300, or 360)"
  type        = number
  default     = null
}

variable "spot_instance_interruption_behavior" {
  description = "Indicates Spot instance behavior when it is interrupted. Valid values are `terminate`, `stop`, or `hibernate`"
  type        = string
  default     = null
}

variable "spot_valid_until" {
  description = "The end date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
}

variable "spot_valid_from" {
  description = "The start date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
}

#######################################
# Volume configuration
#######################################
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
  default = null
}

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
  default = null
}

variable "ephemeral_block_device" {
  description = "Define the ephemeral volume configurations to instance, the virtual_name should be have the patter ephemeral<NUMBER>, if any volume cofigured a default volume will be making"
  type = list(object({
    virtual_name = optional(string, "ephemeral1")
    device_name  = optional(string, "/dev/sdf")
    no_device    = optional(string, null)
  }))
  default = null
}

#######################################
# Volume configuration
#######################################
variable "aws_account" {
  description = "On DLM snapshot, if defined the permissions will be to this accont, else for any"
  type        = string
  default     = "*"
}

variable "snapshot_assume_role_arn" {
  description = "On DLM snapshot, if defined will not be created a new assume role, else will be used this role ARN, for use a ARN existing not must be defined role_name variable"
  type        = string
  default     = null
}

variable "snapshot_role_name" {
  description = "On DLM snapshot, if defined will be create a new role with this name"
  type        = string
  default     = null
}

variable "snapshots_lifecycle" {
  description = "List with snapshots lifecycle, resource_types variable can be VOLUME or INSTANCE, policy_type variable can be EBS_SNAPSHOT_MANAGEMENT, IMAGE_MANAGEMENT or EVENT_BASED_POLICY and state varible can be ENABLED or DESABLED"
  type = list(object({
    name           = string
    target_tags    = any
    description    = optional(string)
    state          = optional(string, "ENABLED")
    resource_types = optional(list(string), ["VOLUME"])
    interval       = optional(number, 24)
    interval_unit  = optional(string, "HOURS")
    times          = optional(string, "00:01")
    retention_time = optional(number, 7)
    copy_tags      = optional(bool, false)
    policy_type    = optional(string, "EBS_SNAPSHOT_MANAGEMENT")
    tags           = optional(any, {})
  }))
  default = []
}

variable "dlm_lifecycle_assume_role_policy" {
  description = "Policy to DLM snapshot assume role"
  type        = any
  default = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "dlm.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  }
}

variable "dlm_snapshot_lifecycle_policy" {
  description = "Policy to DLM snapshot life cycle"
  type        = any
  default     = null
}
