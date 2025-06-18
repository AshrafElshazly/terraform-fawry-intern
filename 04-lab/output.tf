output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.main.id
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances."
  value       = [for i in aws_instance.web : i.public_ip]
}
