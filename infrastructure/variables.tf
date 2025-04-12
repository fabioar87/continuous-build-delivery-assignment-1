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

variable "pipeline-lab-public-subnet-1-cidr" {
  description = "Lab public subnet 1 IP CIDR"
  default     = "10.0.1.0/24"
}

variable "pipeline-lab-private-subnet-1-cidr" {
  description = "Lab private subnet 1 IP CIDR"
  default     = "10.0.2.0/24"
}

variable "ami_base" {
  description = "Provides a standard AMI base image"
  default     = "ami-07a6f770277670015"
}

variable "bastion_instance_type" {
  description = "Provides the bastion instance type footprint"
  default     = "t2.micro"
}

variable "public_key" {
  type = string
  default = "SSH public key path"
}