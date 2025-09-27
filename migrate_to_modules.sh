#!/bin/bash

# Migration script to move resources to modular structure
# This script moves existing resources in state to new module addresses

set -e

echo "🔄 Starting migration to modular structure..."

# Backup current state
echo "📦 Creating state backup..."
terraform state pull > terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)

# Move resources to modules
echo "📋 Moving resources to modules..."

# Move networking resources
echo "  → Moving networking resources..."
terraform state mv aws_security_group.ssh module.networking.aws_security_group.ssh

# Move compute resources
echo "  → Moving compute resources..."
terraform state mv aws_instance.students_main module.compute.aws_instance.students_main
terraform state mv aws_eip.main_ip module.compute.aws_eip.main_ip
terraform state mv aws_key_pair.default module.compute.aws_key_pair.default

# Move storage resources
echo "  → Moving storage resources..."
terraform state mv aws_s3_bucket.kosokolovsky_bucket_svgs module.storage.aws_s3_bucket.kosokolovsky_bucket_svgs
terraform state mv aws_s3_bucket_versioning.kosokolovsky_bucket_svgs module.storage.aws_s3_bucket_versioning.kosokolovsky_bucket_svgs
terraform state mv aws_s3_bucket.test_bucket module.storage.aws_s3_bucket.test_bucket
terraform state mv aws_s3_bucket_versioning.test_bucket module.storage.aws_s3_bucket_versioning.test_bucket
terraform state mv aws_s3_bucket_public_access_block.test_bucket module.storage.aws_s3_bucket_public_access_block.test_bucket
terraform state mv aws_s3_bucket_server_side_encryption_configuration.test_bucket module.storage.aws_s3_bucket_server_side_encryption_configuration.test_bucket
terraform state mv aws_s3_bucket_lifecycle_configuration.test_bucket module.storage.aws_s3_bucket_lifecycle_configuration.test_bucket
terraform state mv aws_s3_bucket_ownership_controls.test_bucket module.storage.aws_s3_bucket_ownership_controls.test_bucket

# Move database resources
echo "  → Moving database resources..."
terraform state mv aws_db_instance.mysql_db module.database.aws_db_instance.mysql_db

echo "✅ Migration completed!"
echo ""
echo "📝 Next steps:"
echo "1. Run: terraform validate"
echo "2. Run: terraform plan (should show 0 to add, 0 to change, 0 to destroy)"
echo "3. If plan is not zero, check the ignore_changes settings in modules"
echo ""
echo "🔒 Important: The EIP 3.67.163.253 is protected and will not change"
echo "🔒 All existing resources are protected with prevent_destroy lifecycle rules"
