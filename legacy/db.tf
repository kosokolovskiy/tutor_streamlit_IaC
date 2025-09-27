resource "aws_db_instance" "mysql_db" {
  identifier        = "mysql-db"
  engine            = "mysql"
  engine_version    = "8.0.42"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_subnet_group_name = "default-vpc-0f427c209ccf14a2d"
  vpc_security_group_ids = [
    "sg-0a038475400fdec88",
    "sg-0b10a84f257baa9d3"
  ]

  publicly_accessible       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "mysql-db-final-snapshot"

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      password,
      username,
      storage_encrypted,
      backup_retention_period,
      deletion_protection,
      ca_cert_identifier
    ]
  }
  tags = {
    Name = "mysql-db"
    Env  = "prod"
  }
}
