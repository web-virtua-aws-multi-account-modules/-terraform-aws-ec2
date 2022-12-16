locals {
  tags_eip = {
    Name    = "${var.name}-static-ip"
    "tf-ip" = "${var.name}-static-ip"
    "tf-ou" = var.ou_name
  }
  tags_ebs_block_device = {
    Name            = "${var.name}-ebs-volume"
    "tf-ec2-volume" = "${var.name}-ebs-volume"
    "tf-ou"         = var.ou_name
  }
  tags_root_block_device = {
    Name            = "${var.name}-root-volume"
    "tf-ec2-volume" = "${var.name}-root-volume"
    "tf-ou"         = var.ou_name
  }
  tags_ec2 = {
    Name     = "${var.name}"
    "tf-ec2" = "${var.name}"
    "tf-ou"  = var.ou_name
  }
}

#######################################
# Elastic IP configuration
#######################################
resource "aws_eip" "create_elastic_ip" {
  count = (var.make_elastic_ip && var.static_ip_id == null) ? 1 : 0

  vpc  = true
  tags = merge(var.tags_eip, var.use_tags_default ? local.tags_eip : {})
}

resource "aws_eip_association" "create_association_ip" {
  count = (var.make_elastic_ip || var.static_ip_id != null) ? 1 : 0

  instance_id   = var.create_spot_instance ? aws_spot_instance_request.create_ec2_spot[0].id : aws_instance.create_ec2[0].id
  allocation_id = var.static_ip_id != null ? var.static_ip_id : try(aws_eip.create_elastic_ip[0].id, null)
}

#######################################
# Instance on demand configuration
#######################################
resource "aws_instance" "create_ec2" {
  count = !var.create_spot_instance ? 1 : 0

  ami                         = var.ami
  subnet_id                   = var.subnet_id
  private_ip                  = var.private_ip
  vpc_security_group_ids      = var.vpc_security_group_ids
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  monitoring                  = var.monitoring
  disable_api_termination     = var.disable_api_termination
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.data_startup_script
  iam_instance_profile        = var.iam_instance_profile_name != null ? var.iam_instance_profile_name : try(aws_iam_instance_profile.create_ec2_profile[0].name, null)
  cpu_core_count              = var.cpu_core_count
  cpu_threads_per_core        = var.cpu_threads_per_core
  hibernation                 = var.hibernation
  availability_zone           = var.availability_zone
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses
  ebs_optimized               = var.ebs_optimized
  tags                        = merge(var.tags, var.use_tags_default ? local.tags_ec2 : {})

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device != null ? var.ebs_block_device : []
    content {
      volume_size           = ebs_block_device.value.volume_size
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      encrypted             = ebs_block_device.value.encrypted
      iops                  = ebs_block_device.value.iops
      throughput            = ebs_block_device.value.throughput
      snapshot_id           = ebs_block_device.value.snapshot_id
      delete_on_termination = ebs_block_device.value.delete_on_termination
      kms_key_id            = ebs_block_device.value.kms_key_id
      tags                  = merge(ebs_block_device.value.tags, var.use_tags_default ? local.tags_ebs_block_device : {})
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? var.root_block_device : []
    content {
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
      encrypted             = root_block_device.value.encrypted
      iops                  = root_block_device.value.iops
      throughput            = root_block_device.value.throughput
      kms_key_id            = root_block_device.value.kms_key_id
      delete_on_termination = root_block_device.value.delete_on_termination
      tags                  = merge(root_block_device.value.tags, var.use_tags_default ? local.tags_root_block_device : {})
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device != null ? var.ephemeral_block_device : []
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
      no_device    = ephemeral_block_device.value.no_device
    }
  }
}

#######################################
# Instance spot configuration
#######################################
resource "aws_spot_instance_request" "create_ec2_spot" {
  count = var.create_spot_instance ? 1 : 0

  ami                         = var.ami
  subnet_id                   = var.subnet_id
  private_ip                  = var.private_ip
  vpc_security_group_ids      = var.vpc_security_group_ids
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  monitoring                  = var.monitoring
  disable_api_termination     = var.disable_api_termination
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.data_startup_script
  iam_instance_profile        = var.iam_instance_profile_name != null ? var.iam_instance_profile_name : try(aws_iam_instance_profile.create_ec2_profile[0].name, null)
  cpu_core_count              = var.cpu_core_count
  cpu_threads_per_core        = var.cpu_threads_per_core
  hibernation                 = var.hibernation
  availability_zone           = var.availability_zone
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses
  ebs_optimized               = var.ebs_optimized
  tags                        = merge(var.tags, var.use_tags_default ? local.tags_ec2 : {})

  ### Spot configuration ###
  spot_price                     = var.spot_price
  wait_for_fulfillment           = var.spot_wait_for_fulfillment
  spot_type                      = var.spot_type
  launch_group                   = var.spot_launch_group
  block_duration_minutes         = var.spot_block_duration_minutes
  instance_interruption_behavior = var.spot_instance_interruption_behavior
  valid_until                    = var.spot_valid_until
  valid_from                     = var.spot_valid_from
  # End Spot configuration

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device != null ? var.ebs_block_device : []
    content {
      volume_size           = ebs_block_device.value.volume_size
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      encrypted             = ebs_block_device.value.encrypted
      iops                  = ebs_block_device.value.iops
      throughput            = ebs_block_device.value.throughput
      snapshot_id           = ebs_block_device.value.snapshot_id
      delete_on_termination = ebs_block_device.value.delete_on_termination
      kms_key_id            = ebs_block_device.value.kms_key_id
      tags                  = merge(ebs_block_device.value.tags, var.use_tags_default ? local.tags_ebs_block_device : {})
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? var.root_block_device : []
    content {
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
      encrypted             = root_block_device.value.encrypted
      iops                  = root_block_device.value.iops
      throughput            = root_block_device.value.throughput
      kms_key_id            = root_block_device.value.kms_key_id
      delete_on_termination = root_block_device.value.delete_on_termination
      tags                  = merge(root_block_device.value.tags, var.use_tags_default ? local.tags_root_block_device : {})
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device != null ? var.ephemeral_block_device : []
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
      no_device    = ephemeral_block_device.value.no_device
    }
  }
}
