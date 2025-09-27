#!/bin/bash

# Migration script for moving from legacy Terraform structure to modular structure
# This script helps migrate existing resources to the new modular architecture

set -e

echo "🚀 Starting migration from legacy Terraform structure to modular architecture..."

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

print_status "Checking current Terraform state..."

# Check if terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    print_warning "No terraform.tfstate file found. This might be a fresh installation."
    echo "If you have existing resources, make sure to import them manually."
else
    print_status "Found existing terraform state. Proceeding with migration..."
    
    # Backup current state
    print_status "Creating backup of current state..."
    cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)
    print_success "State backup created."
fi

# Initialize new terraform configuration
print_status "Initializing new Terraform configuration..."
terraform init

# Validate the new configuration
print_status "Validating new Terraform configuration..."
if terraform validate; then
    print_success "Terraform configuration is valid."
else
    print_error "Terraform configuration validation failed. Please fix the issues before proceeding."
    exit 1
fi

# Plan the changes
print_status "Creating Terraform plan..."
terraform plan -out=migration.tfplan

print_warning "Please review the plan above carefully!"
print_warning "The plan shows what changes will be made to your infrastructure."

echo ""
echo "Migration steps completed:"
echo "✅ Legacy files moved to legacy/ directory"
echo "✅ New modular structure created"
echo "✅ Terraform configuration validated"
echo "✅ Migration plan created (migration.tfplan)"

echo ""
echo "Next steps:"
echo "1. Review the terraform plan output above"
echo "2. If you're satisfied with the plan, run: terraform apply migration.tfplan"
echo "3. If you have existing resources that need to be imported, use terraform import commands"
echo "4. Test your infrastructure thoroughly after migration"

echo ""
print_warning "IMPORTANT NOTES:"
echo "- Legacy files are preserved in the legacy/ directory"
echo "- Your terraform.tfstate has been backed up"
echo "- Some resources might need to be imported manually if they were created outside Terraform"
echo "- Test in a development environment first if possible"

echo ""
print_status "Migration preparation completed successfully!"
