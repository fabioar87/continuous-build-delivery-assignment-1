vpc_cidr_block                     = "10.0.0.0/16"
pipeline-lab-public-subnet-1-cidr  = "10.0.1.0/24"
pipeline-lab-public-subnet-2-cidr  = "10.0.2.0/24"
pipeline-lab-private-subnet-1-cidr = "10.0.3.0/24"
public_key                         = ".ssh/bastion_host.pub"
jenkins_master_ami                 = "ami-099d018dc8b9f9167"
nat_ami                            = "ami-095be693f7434f4b7"
sonar_ami                          = "ami-05f4f22d6c3926c74"
// T2.Medium type: validation
jenkins_master_instance_type       = "t2.medium"
jenkins_master_volume_type         = "gp3"
jenkins_master_volume_size         = 30

// Sonar service
sonar_instance_type = "t2.medium"
sonar_volume_type   = "gp2"
sonar_volume_size   = 30

// Application server
service_ami           = "ami-07a6f770277670015"
service_instance_type = "t2.micro"