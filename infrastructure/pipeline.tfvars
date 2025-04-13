vpc_cidr_block                     = "10.0.0.0/16"
pipeline-lab-public-subnet-1-cidr  = "10.0.1.0/24"
pipeline-lab-public-subnet-2-cidr  = "10.0.2.0/24"
pipeline-lab-private-subnet-1-cidr = "10.0.3.0/24"
public_key                         = ".ssh/bastion_host.pub"
jenkins_master_ami                 = "ami-0ab56d5c1d7cb1246"
nat_ami                            = "ami-095be693f7434f4b7"
// T2.Medium type: validation
jenkins_master_instance_type       = "t2.medium"
jenkins_master_volume_type         = "gp3"
jenkins_master_volume_size         = 30