#!/bin/bash

# Deployment script for different environments
# Usage: ./scripts/deploy.sh [environment] [action]
# Example: ./scripts/deploy.sh dev plan
# Example: ./scripts/deploy.sh prod apply

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [environment] [action]"
    echo ""
    echo "Environments:"
    echo "  dev      - Development environment"
    echo "  staging  - Staging environment"
    echo "  prod     - Production environment"
    echo ""
    echo "Actions:"
    echo "  plan     - Show what changes will be made"
    echo "  apply    - Apply the changes"
    echo "  destroy  - Destroy the infrastructure (use with caution!)"
    echo "  output   - Show outputs"
    echo "  validate - Validate the configuration"
    echo ""
    echo "Examples:"
    echo "  $0 dev plan"
    echo "  $0 prod apply"
    echo "  $0 staging output"
}

# Check arguments
if [ $# -lt 2 ]; then
    print_error "Missing arguments"
    show_usage
    exit 1
fi

ENVIRONMENT=$1
ACTION=$2

# Validate environment
case $ENVIRONMENT in
    dev|staging|prod)
        print_status "Environment: $ENVIRONMENT"
        ;;
    *)
        print_error "Invalid environment: $ENVIRONMENT"
        show_usage
        exit 1
        ;;
esac

# Validate action
case $ACTION in
    plan|apply|destroy|output|validate)
        print_status "Action: $ACTION"
        ;;
    *)
        print_error "Invalid action: $ACTION"
        show_usage
        exit 1
        ;;
esac

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    print_error "Terraform is not installed. Please install Terraform first."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    print_error "main.tf not found. Please run this script from the project root directory."
    exit 1
fi

# Set variables file
VAR_FILE="environments/${ENVIRONMENT}/terraform.tfvars"

if [ ! -f "$VAR_FILE" ]; then
    print_error "Variables file not found: $VAR_FILE"
    exit 1
fi

print_status "Using variables file: $VAR_FILE"

# Initialize terraform if needed
if [ ! -d ".terraform" ]; then
    print_status "Initializing Terraform..."
    terraform init
fi

# Execute the action
case $ACTION in
    validate)
        print_status "Validating Terraform configuration..."
        terraform validate
        print_success "Configuration is valid!"
        ;;
    plan)
        print_status "Creating Terraform plan for $ENVIRONMENT environment..."
        terraform plan -var-file="$VAR_FILE" -out="${ENVIRONMENT}.tfplan"
        print_success "Plan created: ${ENVIRONMENT}.tfplan"
        ;;
    apply)
        if [ -f "${ENVIRONMENT}.tfplan" ]; then
            print_status "Applying Terraform plan for $ENVIRONMENT environment..."
            terraform apply "${ENVIRONMENT}.tfplan"
            rm "${ENVIRONMENT}.tfplan"
            print_success "Infrastructure deployed successfully!"
        else
            print_warning "No plan file found. Creating and applying plan..."
            terraform apply -var-file="$VAR_FILE"
            print_success "Infrastructure deployed successfully!"
        fi
        ;;
    destroy)
        if [ "$ENVIRONMENT" = "prod" ]; then
            print_warning "You are about to destroy PRODUCTION infrastructure!"
            echo -n "Type 'yes' to confirm: "
            read -r confirmation
            if [ "$confirmation" != "yes" ]; then
                print_status "Destruction cancelled."
                exit 0
            fi
        fi
        print_warning "Destroying infrastructure for $ENVIRONMENT environment..."
        terraform destroy -var-file="$VAR_FILE"
        print_success "Infrastructure destroyed."
        ;;
    output)
        print_status "Showing outputs for $ENVIRONMENT environment..."
        terraform output
        ;;
esac

print_success "Operation completed successfully!"
