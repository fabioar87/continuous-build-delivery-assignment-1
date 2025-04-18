resource "aws_security_group" "library-service-sg" {
  name   = "library-service_sg_${var.vpc_name}"
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.master_sg.id]
  }

  ingress {
    from_port       = "8081"
    to_port         = "8081"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    cidr_blocks     = [var.vpc_cidr_block]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "library-service_sg_${var.vpc_name}"
  }
}

resource "aws_instance" "library-service" {
  ami                    = var.service_ami
  instance_type          = var.service_instance_type
  key_name               = aws_key_pair.bastion_management.id
  vpc_security_group_ids = [aws_security_group.library-service-sg.id]
  subnet_id              = aws_subnet.pipeline-lab-private-subnet-1.id

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "library-service-ec2"
  }
}