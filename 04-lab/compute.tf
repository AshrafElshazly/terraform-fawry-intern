resource "aws_security_group" "instance" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = {
      ssh   = { port = 22, cidrs = var.allowed_cidr_blocks }
      http  = { port = 80, cidrs = ["0.0.0.0/0"] }
      https = { port = 443, cidrs = ["0.0.0.0/0"] }
      k8s   = { port = 6443, cidrs = ["0.0.0.0/0"] }
    }
    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidrs
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-sg"
  })
}

resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = element(aws_subnet.public[*].id, count.index % length(aws_subnet.public))
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = var.key_pair_name

  tags = merge(var.tags, {
    Name = "${var.project_name}-web-${count.index}"
  })

  # user_data = file("userdata.sh")

  ### OR

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo yum install -y httpd
  #             sudo systemctl enable httpd
  #             sudo systemctl start httpd
  #             sudo mkdir -p /var/www/html/
  #             sudo touch /var/www/html/index.html
  #             EOF

  # Provisioner example (remote-exec)
  provisioner "remote-exec" {
    inline = [
      "set -e",

      "while sudo fuser /var/run/yum.pid >/dev/null 2>&1; do echo 'waiting for yum lock'; sleep 5; done",

      "sudo yum -y install httpd",
      "sudo systemctl enable --now httpd",

      "sudo mkdir -p /var/www/html",

      "echo \"<h1>Hello from intern lab</h1>\" | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/labs_key.pem")
      host        = self.public_ip
    }
  }
}
