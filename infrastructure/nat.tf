// NAT SG
resource "aws_security_group" "nat_sg" {
  name   = "nat_sg_${var.vpc_name}"
  vpc_id = aws_vpc.pipeline-lab-vpc.id

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

  tags = {
    Name = "nat_sg_${var.vpc_name}"
  }
}

// NAT instance configuration
resource "aws_instance" "nat" {
  ami                         = var.nat_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pipeline-lab-public-subnet-1.id
  key_name                    = aws_key_pair.bastion_management.id
  security_groups             = [aws_security_group.nat_sg.id]
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "nat_${var.vpc_name}"
  }
}