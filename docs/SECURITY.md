# Security Implementation & Practices

## 1. Data Protection
### Encryption
- **At Rest**  
  🔐 EBS volumes encrypted using AWS KMS (AES-256)  
  ```hcl
  resource "aws_ebs_volume" "private" {
    encrypted  = true
    kms_key_id = aws_kms_key.ebs_kms.arn
  }

In Transit
🛡️ SSH (RSA 2048-bit keys) for instance access
⚠️ Future Improvement: Implement TLS for Juice Shop

Secrets Management
🔑 No credentials stored in version control

🔄 Key rotation process:
```bash
aws ec2 create-key-pair --key-name new-key --query 'KeyMaterial' > new-key.pem
terraform apply -var="key_name=new-key"
```
## 2. Access Control
### Network Restrictions

 ```hcl
# Public Security Group
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.my_ip] # Strict IP whitelist
}

# Private Security Group
ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.public.id] # Bastion-only access
}
```
###  IAM Policies

🚫 Least privilege EC2 instance role
📜 Sample policy for audit purposes:
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "ec2:DescribeVolumes",
      "kms:Decrypt"
    ],
    "Resource": "*"
  }]
}
```
## 3. Network Security
### Monitoring
🕵️ CloudTrail enabled for API logging
📊 VPC Flow Logs configuration:
```hcl
resource "aws_flow_log" "vpc" {
  log_destination = aws_s3_bucket.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id         = aws_vpc.main.id
}

```
## 4. Vulnerability Management
### OWASP Juice Shop Controls
🐳 Docker container isolation
🌐 Restricted to port 80 only
🔄 Automated image updates:
```yaml
- name: Update Juice Shop
  docker_container:
    name: juice_shop
    image: bkimminich/juice-shop
    state: reloaded
```
### Patch Management
```yaml
- name: Apply security updates
  ansible.builtin.apt:
    upgrade: safe
    update_cache: yes
    cache_valid_time: 86400
  register: apt_upgrade
```
## 5. Audit & Compliance
AWS Config Rules
Rule	                |       Purpose
ebs-encrypted-by-default|	Verify EBS encryption
restricted-ssh	        | Check SSH access restrictions
cloudtrail-enabled	    |  Ensure logging enabled

### Compliance Standards
✅ GDPR: Data encryption requirements
✅ PCI-DSS v4.0: Network segmentation
⚠️ HIPAA: Requires BAA with AWS

## 6. Incident Response
### Detection & Containment
Identify Compromise via CloudWatch metrics
Isolate Instance
```bash
aws ec2 modify-instance-attribute \
  --instance-id i-1234567890abcdef0 \
  --no-disable-api-termination
```
Preserve Evidence
```bash
aws ec2 create-snapshot --volume-id vol-1234567890abcdef0
```
### Post-Incident
📝 Root cause analysis documentation
🔄 Security group rule review
🔑 Key pair rotation