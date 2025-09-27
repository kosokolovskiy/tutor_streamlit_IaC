data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "students_main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_volume_config.instance_type
  key_name      = aws_key_pair.default.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_volume_config.volume_size
    volume_type           = var.ec2_volume_config.volume_type
  }
  tags = {
    Name = "Students New"
    Env  = "dev"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ ami ]
  }
}



resource "aws_eip" "main_ip" {
  instance = aws_instance.students_main.id
  domain   = "vpc"

  tags = {
    Name = "students-elastic-ip"
    Env  = "dev"
  }
}


resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP from CloudFront only"
    from_port      = 80
    to_port        = 80
    protocol       = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront_origin.id]
  }

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
}




resource "aws_key_pair" "default" {
  key_name   = "students_key"
  public_key = file("~/.ssh/my_key.pub")
}


data "aws_vpc" "default" {
  default = true
}


data "aws_ec2_managed_prefix_list" "cloudfront_origin" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

