output "vpc_id" {
  value = aws_vpc.pipeline-lab-vpc.id
}

output "nat_ip" {
  value = aws_instance.nat.public_ip
}

output "bastion" {
  value = aws_instance.bastion.public_ip
}

output "jenkins_master_alb" {
  value = aws_lb.jenkins_master_lb.dns_name
}

output "sonar_alb" {
  value = aws_lb.sonar_lb.dns_name
}