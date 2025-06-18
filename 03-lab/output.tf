output "server1_public_ip" {
  description = "Server1 Public IP addresse of the EC2 instance."
  value = aws_instance.server1.public_ip
}
