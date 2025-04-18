resource "aws_security_group" "master_sg" {
  name   = "jenkins-master_sg_${var.vpc_name}"
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port        = "8080"
    to_port          = "8080"
    protocol         = "tcp"
    security_groups  = [aws_security_group.jenkins_master_lb_sg.id]
    cidr_blocks      = [var.vpc_cidr_block]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-master_sg_${var.vpc_name}"
  }
}

resource "aws_security_group_rule" "ssh_bastion_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.master_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_instance" "jenkins_master" {
  ami                    = var.jenkins_master_ami
  instance_type          = var.jenkins_master_instance_type
  key_name               = aws_key_pair.bastion_management.id
  vpc_security_group_ids = [aws_security_group.master_sg.id]
  subnet_id              = aws_subnet.pipeline-lab-private-subnet-1.id

  root_block_device {
    volume_type           = var.jenkins_master_volume_type
    volume_size           = var.jenkins_master_volume_size
    delete_on_termination = false
  }

  tags = {
    Name = "jenkins_master_${var.project_name}"
  }
}

// Jenkins Master LB
resource "aws_security_group" "jenkins_master_lb_sg" {
  name   = "lb_sg_${var.vpc_name}"
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = "443"
  #   to_port     = "443"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb_sg_${var.vpc_name}"
  }
}

resource "aws_lb" "jenkins_master_lb" {
  name               = "jenkins-master-lb"
  subnets            = [aws_subnet.pipeline-lab-public-subnet-1.id,
    aws_subnet.pipeline-lab-public-subnet-2.id
  ]
  security_groups    = [aws_security_group.jenkins_master_lb_sg.id]
  internal           = false
  load_balancer_type = "application"

  tags = {
    Name = "jenkins_master_lb"
  }
}

resource "aws_lb_target_group" "jenkins_master_lb_target_group" {
  name     = "jenkins-master-lb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.pipeline-lab-vpc.id

  health_check {
    interval            = 30
    path                = "/login"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "jenkins_lb_listener" {
  load_balancer_arn = aws_lb.jenkins_master_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_master_lb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "jenkins_master_lb_target_group_attach" {
  target_group_arn = aws_lb_target_group.jenkins_master_lb_target_group.arn
  target_id        = aws_instance.jenkins_master.id
  port             = 8080
}