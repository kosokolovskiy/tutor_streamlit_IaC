# Networking module - Security groups for existing default VPC

# Data source for default VPC (existing infrastructure)
data "aws_vpc" "default" {
  default = true
}

# Data source for CloudFront prefix list
data "aws_ec2_managed_prefix_list" "cloudfront_origin" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Security Group for SSH and HTTP access (exact match with state)
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from CloudFront only
  ingress {
    description     = "HTTP from CloudFront only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront_origin.id]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "students-ssh-sg"
    Env  = "dev"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags_all]
  }
}

resource "aws_vpc_security_group_ingress_rule" "mongo_ips" {
  for_each          = toset(var.mongo_allowed_cidrs)
  description       = "MongoDB 27017 from allowed IPs"
  security_group_id = aws_security_group.ssh.id
  from_port         = 27017
  to_port           = 27017
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value
}
