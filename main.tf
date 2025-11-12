terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}

# --- Provider Configuration ---
provider "aws" {
  region = var.aws_region
}

# --- S3 Bucket ---
resource "aws_s3_bucket" "photo_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "Photo Upload Bucket"
    Environment = "Demo"
  }
}

# --- IAM Role for EC2 ---
resource "aws_iam_role" "web_role" {
  name = "webapp_s3_upload_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = { Service = "ec2.amazonaws.com" }
        Effect   = "Allow"
      }
    ]
  })
}

# --- IAM Policy to Allow Uploads to S3 ---
resource "aws_iam_role_policy" "upload_policy" {
  name = "s3_upload_policy"
  role = aws_iam_role.web_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.photo_bucket.arn}/*"
      }
    ]
  })
}

# --- Instance Profile (to attach IAM Role to EC2) ---
resource "aws_iam_instance_profile" "web_profile" {
  name = "webapp_profile"
  role = aws_iam_role.web_role.name
}

# --- Get default VPC (so you can launch EC2 without creating networking manually) ---
data "aws_vpc" "default" {
  default = true
}

# --- Security Group for EC2 (allow HTTP and SSH) ---
resource "aws_security_group" "web_sg" {
  name        = "webapp_sg"
  description = "Allow HTTP and SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- EC2 Instance running Flask app ---
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.web_profile.name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("setup.sh")

  tags = {
    Name = "PhotoUploadApp"
  }
}

# --- Outputs (defined in outputs.tf but can be previewed here too) ---
output "app_url" {
  value       = "http://${aws_instance.web.public_ip}"
  description = "URL to access your web photo upload app"
}

output "bucket_name" {
  value       = aws_s3_bucket.photo_bucket.bucket
  description = "Name of the S3 bucket used for uploads"
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP address of the EC2 instance"
}
