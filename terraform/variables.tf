# variables.tf
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  # Free tier supported region
}

variable "instance_type" {
  description = "EC2 instance type (free tier)"
  default     = "t2.micro"   # Free tier eligible
}

# Remove the static AMI ID variable since we're using dynamic lookup
# variable "ami" {
#   description = "Amazon Linux 2 AMI"
#   default     = "ami-00354acb6e3508fd0"  # Deprecated/conflicting
# }

variable "key_name" {
  description = "Existing EC2 key pair name"
  default     = "key-pair-1"  # Must exist in your AWS account
}

variable "my_ip" {
  description = "Your public IP in CIDR format"
  default     = "151.25.191.218/32"  # Keep updated with your current IP
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"  # Standard private range
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  default     = "10.0.1.0/24"   # /24 subnet within VPC
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  default     = "10.0.2.0/24"   # /24 subnet within VPC
}

# Ubuntu 22.04 LTS (Jammy Jellyfish) AMI lookup
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}