# Student Infrastructure - AWS Terraform Project

This project provides a complete AWS infrastructure setup for a student learning platform using Terraform. The infrastructure is designed with modularity, scalability, and best practices in mind.

## 🏗️ Architecture Overview

The infrastructure consists of the following components:

- **Networking**: VPC with public/private subnets, security groups, NAT gateway
- **Compute**: EC2 instances with auto-scaling capabilities
- **Storage**: S3 buckets for static assets, data, and backups
- **Database**: RDS MySQL instance with automated backups
- **CDN**: CloudFront distribution for global content delivery
- **Security**: IAM roles, security groups, and encrypted storage

## 📁 Project Structure

```
├── main.tf                     # Main Terraform configuration
├── variables.tf                # Global variable definitions
├── outputs.tf                  # Global outputs
├── terraform.tfvars            # Default variable values
├── prod-override.auto.tfvars   # Production overrides
├── modules/                    # Terraform modules
│   ├── networking/             # VPC, subnets, security groups
│   ├── compute/                # EC2 instances, key pairs
│   ├── storage/                # S3 buckets and policies
│   ├── database/               # RDS MySQL configuration
│   └── cloudfront/             # CloudFront distribution
├── environments/               # Environment-specific configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** >= 1.7.0 installed
3. **SSH key pair** generated and available at `~/.ssh/my_key.pub`

### For New Installations

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd tutor_streamlit_IaC
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and modify variables in `terraform.tfvars` as needed

4. Deploy using the deployment script:
   ```bash
   ./scripts/deploy.sh dev plan    # Plan for development
   ./scripts/deploy.sh dev apply   # Apply for development
   ```

### For Existing Infrastructure (Migration)

If you have existing infrastructure from the legacy setup:

1. **Backup your current state**:
   ```bash
   cp terraform.tfstate terraform.tfstate.backup
   ```

2. **Run the migration script**:
   ```bash
   ./migrate.sh
   ```

3. **Review the migration plan carefully** and apply if satisfied:
   ```bash
   terraform apply migration.tfplan
   ```

4. **Test your infrastructure** thoroughly after migration

## 🌍 Environment Management

This project supports multiple environments (dev, staging, prod) with different configurations.

### Using Environment-Specific Configurations

#### Using the Deployment Script (Recommended)

```bash
# Development
./scripts/deploy.sh dev plan     # Plan changes
./scripts/deploy.sh dev apply    # Apply changes
./scripts/deploy.sh dev output   # Show outputs

# Staging
./scripts/deploy.sh staging plan
./scripts/deploy.sh staging apply

# Production
./scripts/deploy.sh prod plan
./scripts/deploy.sh prod apply
```

#### Manual Deployment (Alternative)

```bash
# Development Environment
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"

# Staging Environment
terraform plan -var-file="environments/staging/terraform.tfvars"
terraform apply -var-file="environments/staging/terraform.tfvars"

# Production Environment
terraform plan -var-file="environments/prod/terraform.tfvars"
terraform apply -var-file="environments/prod/terraform.tfvars"
```

### Using Terraform Workspaces (Alternative)

```bash
# Create and switch to development workspace
terraform workspace new dev
terraform workspace select dev
terraform apply -var-file="environments/dev/terraform.tfvars"

# Create and switch to production workspace
terraform workspace new prod
terraform workspace select prod
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## 📋 Configuration

### Key Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region for deployment | `eu-central-1` | No |
| `environment` | Environment name (dev/staging/prod) | `dev` | No |
| `project_name` | Project name for resource naming | `student-infrastructure` | No |
| `domain_name` | Custom domain name | `""` | No |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` | No |

### Environment Differences

| Component | Development | Staging | Production |
|-----------|-------------|---------|------------|
| EC2 Instance | t3.nano | t3.micro | t3.small |
| RDS Instance | db.t3.micro | db.t3.micro | db.t3.small |
| Storage | 20GB | 30GB | 100GB |
| Backup Retention | 1 day | 7 days | 30 days |
| CloudFront Price Class | 100 | 200 | All |

## 🔧 Modules

### Networking Module
- Creates VPC with public and private subnets
- Sets up Internet Gateway and NAT Gateway
- Configures security groups for different tiers
- Supports multiple availability zones

### Compute Module
- Deploys EC2 instances with Ubuntu 22.04
- Configures SSH key pairs
- Sets up Elastic IP addresses
- Includes user data script for initial setup

### Storage Module
- Creates S3 buckets for different purposes
- Implements versioning and lifecycle policies
- Configures encryption and access controls
- Supports backup and archival strategies

### Database Module
- Deploys RDS MySQL instances
- Manages database credentials in Secrets Manager
- Configures automated backups
- Sets up parameter groups and monitoring

### CloudFront Module
- Creates CloudFront distributions
- Supports both S3 and custom origins
- Configures SSL certificates for custom domains
- Implements caching strategies

## 🔐 Security Features

- **Encryption**: All storage encrypted at rest
- **Network Security**: Security groups with least privilege
- **Secrets Management**: Database credentials in AWS Secrets Manager
- **Access Control**: IAM roles and policies
- **SSL/TLS**: HTTPS enforcement via CloudFront

## 📊 Monitoring and Logging

- **CloudWatch**: Automatic monitoring for all resources
- **Performance Insights**: Enabled for production RDS
- **VPC Flow Logs**: Network traffic monitoring
- **CloudTrail**: API call logging (recommended to enable separately)

## 🔄 Backup and Recovery

- **RDS Backups**: Automated daily backups with point-in-time recovery
- **S3 Versioning**: Object-level versioning for data protection
- **Lifecycle Policies**: Automated archival to reduce costs
- **Cross-Region Replication**: Can be enabled for critical data

## 💰 Cost Optimization

- **Right-sizing**: Environment-specific instance sizes
- **Storage Classes**: Automated transitions to cheaper storage
- **CloudFront**: Reduced origin requests and bandwidth costs
- **Spot Instances**: Can be enabled for non-critical workloads

## 🚨 Troubleshooting

### Common Issues

1. **SSH Key Not Found**
   - Ensure `~/.ssh/my_key.pub` exists
   - Update `public_key_path` variable if using different location

2. **Domain Name Issues**
   - Verify domain ownership
   - Ensure SSL certificate is in `us-east-1` region for CloudFront

3. **Resource Limits**
   - Check AWS service quotas
   - Verify IAM permissions

### Useful Commands

```bash
# Check current state
terraform show

# List all resources
terraform state list

# Get specific resource information
terraform state show aws_instance.main

# Refresh state
terraform refresh

# Import existing resources
terraform import aws_instance.example i-1234567890abcdef0
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For questions or issues:
- Create an issue in the repository
- Contact the infrastructure team
- Check AWS documentation for service-specific issues
