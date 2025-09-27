# Compute module outputs

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.students_main.id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.students_main.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.students_main.private_ip
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.main_ip.public_ip
}

output "elastic_ip_allocation_id" {
  description = "Allocation ID of the Elastic IP"
  value       = aws_eip.main_ip.allocation_id
}

output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.default.key_name
}
