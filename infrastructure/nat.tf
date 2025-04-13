// NAT SG
resource "aws_security_group" "nat_sg" {
  name   = "nat_sg_${var.vpc_name}"
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
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
    cidr_blocks = [var.pipeline-lab-private-subnet-1-cidr]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.pipeline-lab-private-subnet-1-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat_sg_${var.vpc_name}"
  }
}

// NAT instance configuration
resource "aws_instance" "nat" {
  ami                         = var.nat_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pipeline-lab-public-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  key_name                    = aws_key_pair.bastion_management.id
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_replace_on_change = true
  user_data                   = <<-EOL
                                  #!/bin/bash

                                  sudo sysctl -w net.ipv4.ip_forward=1
                                  sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
                                  sudo /sbin/iptables -F FORWARD
  EOL

  root_block_device {
    volume_size = "8"
    volume_type = "gp2"
    encrypted   = true
  }

  tags = {
    Name = "nat_${var.vpc_name}"
  }
}