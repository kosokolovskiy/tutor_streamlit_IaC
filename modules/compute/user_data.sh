#!/bin/bash

# User data script for EC2 instance initialization
# This script runs on first boot to set up the instance

set -e

# Update system packages
apt-get update
apt-get upgrade -y

# Install essential packages
apt-get install -y \
    curl \
    wget \
    git \
    htop \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Python and pip
apt-get install -y python3 python3-pip python3-venv

# Install Node.js (LTS version)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Create application directory
mkdir -p /opt/app
chown ubuntu:ubuntu /opt/app

# Set up log directory
mkdir -p /var/log/app
chown ubuntu:ubuntu /var/log/app

# Create systemd service for the application (placeholder)
cat > /etc/systemd/system/student-app.service << EOF
[Unit]
Description=Student Application
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/app
ExecStart=/bin/bash -c 'cd /opt/app && python3 -m http.server 8000'
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable the service (but don't start it yet)
systemctl enable student-app.service

# Set up basic firewall
ufw --force enable
ufw allow ssh
ufw allow 80
ufw allow 443

# Create a simple index.html for testing
cat > /opt/app/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Student Infrastructure - ${environment}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { color: #333; }
        .info { background: #f4f4f4; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1 class="header">Welcome to ${project_name}</h1>
    <div class="info">
        <h2>Environment: ${environment}</h2>
        <p>This is a placeholder page for the student infrastructure.</p>
        <p>Instance initialized at: $(date)</p>
    </div>
</body>
</html>
EOF

# Log the completion
echo "$(date): User data script completed successfully" >> /var/log/user-data.log

# Start the simple web server
systemctl start student-app.service
