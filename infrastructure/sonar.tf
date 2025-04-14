resource "aws_security_group" "sonar_sg" {
  name   = "sonar_sq"
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port        = "9000"
    to_port          = "9000"
    protocol         = "tcp"
    security_groups  = [aws_security_group.sonar_lb_sg.id]
    cidr_blocks      = [var.vpc_cidr_block]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sonar_sg_${var.vpc_name}"
  }
}

resource "aws_instance" "sonar" {
  ami                    = var.sonar_ami
  instance_type          = var.sonar_instance_type
  key_name               = aws_key_pair.bastion_management.id
  vpc_security_group_ids = [aws_security_group.sonar_sg.id]
  subnet_id              = aws_subnet.pipeline-lab-private-subnet-1.id

  root_block_device {
    volume_type           = var.sonar_volume_type
    volume_size           = var.sonar_volume_size
    delete_on_termination = false
  }

  tags = {
    Name = "sonar_${var.project_name}"
  }
}

// Sonar LB
resource "aws_security_group" "sonar_lb_sg" {
  name   = "sonar_lb_sg_${var.vpc_name}"
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
    Name = "sonar_lb_sg_${var.vpc_name}"
  }
}

resource "aws_lb" "sonar_lb" {
  name               = "sonar-lb"
  subnets            = [aws_subnet.pipeline-lab-public-subnet-1.id,
    aws_subnet.pipeline-lab-public-subnet-2.id
  ]
  security_groups    = [aws_security_group.sonar_lb_sg.id]
  internal           = false
  load_balancer_type = "application"

  tags = {
    Name = "sonar_master_lb"
  }
}

resource "aws_lb_target_group" "sonar_lb_target_group" {
  name     = "sonar-lb-target-group"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = aws_vpc.pipeline-lab-vpc.id

  health_check {
    interval            = 30
    path                = "/api/system/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "sonar_lb_listener" {
  load_balancer_arn = aws_lb.sonar_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonar_lb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "sonar_lb_target_group_attach" {
  target_group_arn = aws_lb_target_group.sonar_lb_target_group.arn
  target_id        = aws_instance.sonar.id
  port             = 9000
}