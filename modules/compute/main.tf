# Compute module - EC2 instances, key pairs, and elastic IPs

# Data source for Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# SSH Key Pair (exact match with state)
resource "aws_key_pair" "default" {
  key_name   = "students_key"
  public_key = file(var.public_key_path)

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags_all]
  }
}

# EC2 Instance (exact match with state)
resource "aws_instance" "students_main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.default.key_name

  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
    encrypted             = false  # Match state exactly
  }

  tags = {
    Name = "Students New"
    Env  = "dev"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ami, tags_all]
  }
}

# Elastic IP (exact match with state)
resource "aws_eip" "main_ip" {
  instance = aws_instance.students_main.id
  domain   = "vpc"

  tags = {
    Name = "students-elastic-ip"
    Env  = "dev"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags_all]
  }

  depends_on = [aws_instance.students_main]
}
