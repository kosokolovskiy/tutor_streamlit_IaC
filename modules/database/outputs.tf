# Database module outputs

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.mysql_db.id
}

output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.mysql_db.identifier
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mysql_db.endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = aws_db_instance.mysql_db.address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.mysql_db.port
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.mysql_db.arn
}
