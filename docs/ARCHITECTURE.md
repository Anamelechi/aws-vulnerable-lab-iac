# System Architecture Overview

## Infrastructure Design
![Network Architecture Diagram](./images/architecture-diagram.png)

### Core Components
1. **Virtual Private Cloud (VPC)**
   - CIDR: 10.0.0.0/16
   - DNS Support & Hostnames Enabled
   - Multi-AZ Capability (Single AZ for Free Tier)

2. **Network Segmentation**
   - Public Subnet (10.0.1.0/24)
     - Internet-facing resources
     - Route to Internet Gateway
   - Private Subnet (10.0.2.0/24)
     - Isolated backend resources
     - Route to NAT Gateway

3. **Compute Resources**
   - Public Instance
     - t2.micro EC2 (Ubuntu 22.04 LTS)
     - Hosts OWASP Juice Shop in Docker
   - Private Instance
     - t2.micro EC2 (Ubuntu 22.04 LTS)
     - Mounts Encrypted EBS Volume

4. **Storage**
   - EBS Volume (10GB GP2)
   - KMS Encryption at Rest
   - Persistent Mount at `/mnt/secret_notes`

## Data Flow
1. User → Internet Gateway → Public Instance (Port 80)
2. Public Instance → NAT Gateway → Private Instance
3. Private Instance → EBS Volume (Encrypted I/O)

## Key Terraform Resources
```hcl
module "network" {
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

resource "aws_nat_gateway" "main" {
  connectivity_type = "public"
}
```