output "ec2_type" {
  description = "EC2 instance type"
  value       = var.create_spot_instance ? "SPOT" : "On Demand"
}

output "ec2_tags_defatul" {
  description = "EC2 instance default tags"
  value = {
    tags_ec2               = local.tags_ec2
    tags_eip               = local.tags_eip
    tags_ebs_block_device  = local.tags_ebs_block_device
    tags_root_block_device = local.tags_root_block_device
  }
}

output "ec2" {
  description = "All EC2 informations"
  value       = try(aws_instance.create_ec2[0], aws_spot_instance_request.create_ec2_spot[0])
}

output "ec2_arn" {
  description = "EC2 ARN"
  value       = try(aws_instance.create_ec2[0].arn, aws_spot_instance_request.create_ec2_spot[0].arn)
}

output "ebs_block_device" {
  description = "EC2 EBS block device"
  value       = try(aws_instance.create_ec2[0].ebs_block_device, aws_spot_instance_request.create_ec2_spot[0].ebs_block_device)
}

output "root_block_device" {
  description = "EC2 ROOT block device"
  value       = try(aws_instance.create_ec2[0].root_block_device, aws_spot_instance_request.create_ec2_spot[0].root_block_device)
}

output "ephemeral_block_device" {
  description = "EC2 ephemeral block device"
  value       = try(aws_instance.create_ec2[0].ephemeral_block_device, aws_spot_instance_request.create_ec2_spot[0].ephemeral_block_device)
}

output "instance_state" {
  description = "The state of the instance"
  value       = try(aws_instance.create_ec2[0].instance_state, aws_spot_instance_request.create_ec2_spot[0].instance_state)
}

output "private_dns" {
  description = "The private DNS name assigned to the instance"
  value       = try(aws_instance.create_ec2[0].private_dns, aws_spot_instance_request.create_ec2_spot[0].private_dns)
}

output "public_dns" {
  description = "The public DNS name assigned to the instance"
  value       = try(aws_instance.create_ec2[0].public_dns, aws_spot_instance_request.create_ec2_spot[0].public_dns)
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = try(aws_instance.create_ec2[0].public_ip, aws_spot_instance_request.create_ec2_spot[0].public_ip)
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = try(aws_instance.create_ec2[0].private_ip, aws_spot_instance_request.create_ec2_spot[0].private_ip)
}

output "ec2_instance_id" {
  description = "The Instance ID"
  value       = try(aws_instance.create_ec2[0].id, aws_spot_instance_request.create_ec2_spot[0].id)
}

#######################################
# Role and policy configuration
#######################################
output "ec2_policy" {
  description = "The EC2 policy"
  value       = try(aws_iam_policy.create_ec2_policy[0], null)
}

output "ec2_role" {
  description = "The EC2 role"
  value       = try(aws_iam_role.create_ec2_role[0], null)
}

output "ec2_attachment_policy" {
  description = "The EC2 attachment policy"
  value       = try(aws_iam_policy_attachment.create_ec2_attachment_policy_role[0], null)
}

output "ec2_profile" {
  description = "The EC2 profile"
  value       = try(aws_iam_instance_profile.create_ec2_profile[0], null)
}
