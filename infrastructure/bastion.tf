// Management Key Pair
resource "aws_key_pair" "bastion_management" {
  key_name = "bastion_management"
  public_key = file(var.public_key)
}

// Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg_${var.vpc_name}"
  description = "Bastion host SG"
  vpc_id      = aws_vpc.pipeline-lab-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg_${var.vpc_name}"
  }
}

// Bastion Host "Jump Host" instance
resource "aws_instance" "bastion" {
  ami                         = var.ami_base
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.bastion_management.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.pipeline-lab-public-subnet-1.id
  associate_public_ip_address = true

  tags = {
    Name = "jumphost_box_${var.vpc_name}"
  }
}