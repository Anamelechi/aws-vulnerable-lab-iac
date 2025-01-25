# terraform/terraform.tfvars
# (Add this file to .gitignore to protect sensitive values)

# Required Variables
aws_region = "us-east-1"        # Preferred AWS region
key_name   = "key-pair-1"    # Existing EC2 key pair name
my_ip      = "151.25.191.218/32"  # Your public IP (use: curl ifconfig.me)

# Optional Overrides (Free Tier Defaults)
# instance_type = "t2.micro"
# ami = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
# vpc_cidr = "10.0.0.0/16"
# public_subnet_cidr = "10.0.1.0/24"
# private_subnet_cidr = "10.0.2.0/24"