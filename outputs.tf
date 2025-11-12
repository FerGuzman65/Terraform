output "bucket_name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.photo_bucket.bucket
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "app_url" {
  description = "URL of the web upload app"
  value       = "http://${aws_instance.web.public_ip}"
}
