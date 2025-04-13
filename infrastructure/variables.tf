variable "project_name" {
  description = "Defines a project name"
  default     = "cicd_pipeline_lab"
}

variable "region" {
  description = "Pipeline region"
  default     = "us-east-1"
}

variable "profile" {
  default = "default"
}

variable "vpc_name" {
  default = "pipeline-lab-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC defined cidr block"
  default     = "10.0.0.0/16"
}

variable "az_1" {
  description = "Availability zone"
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Availability zone"
  default     = "us-east-1b"
}

variable "pipeline-lab-public-subnet-1-cidr" {
  description = "Lab public subnet 1 IP CIDR"
  default     = "10.0.1.0/24"
}

variable "pipeline-lab-public-subnet-2-cidr" {
  description = "Lab public subnet 2 IP CIDR"
  default     = "10.0.2.0/24"
}

variable "pipeline-lab-private-subnet-1-cidr" {
  description = "Lab private subnet 1 IP CIDR"
  default     = "10.0.3.0/24"
}

variable "ami_base" {
  description = "Provides a standard AMI base image"
  default     = "ami-07a6f770277670015"
}

variable "nat_ami" {
  description = "Provides the NAT component AMI image"
  default     = "ami-095be693f7434f4b7"
}

variable "bastion_instance_type" {
  description = "Provides the bastion instance type footprint"
  default     = "t2.micro"
}

variable "public_key" {
  type = string
  default = "SSH public key path"
}

// Jenkins Master variables
variable "jenkins_master_ami" {
  type    = string
  default = ""
}

variable "jenkins_master_instance_type" {
  type        = string
  description = "EC2 Jenkins master instance type"
  default     = "t2.medium"
}

variable "jenkins_master_volume_type" {
  type        = string
  description = "Jenkins master instance volume type"
  default     = "gp3"
}

variable "jenkins_master_volume_size" {
  type    = number
  default = 30
}