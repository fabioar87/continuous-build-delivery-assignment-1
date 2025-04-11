## Jenkins Component
The plan is bake a custom Jenkins image using `hashicorp packer` tool. 
Build a standalone instance (not heavy load), no workers just a single master node.

_Results_:
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-00e406ec2b522c966

The AMI custom Jenkins baked image can be found in the AMI catalog.

## Jenkins Installation 
More information can be found [here](https://www.jenkins.io/doc/book/installing/linux/).
Steps:
```shell
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade
yum install -y fontconfig java-17-openjdk
yum install -y jenkins
```

### Project Structure
> ./standalone: contains the template and specific configuration file to provision 
and configure the jenkins image

What`s the version of jenkins that will be installed?
Dependencies and requirements, which java version is required?
What's the repository? 

### Specifications
* Image base: Amazon linux 2
* Source AMI: ami-07a6f770277670015 (64-bit (x86))
* Instance type: t2.micro
* Java version: java-17-openjdk

### Baking the image
> First step: create a variable json script with argument values.

Command to bake the image passing the variable values as argument
```shell
packer build -var-file=variables.json template.json
```

### Troubleshooting
The build process returned errors:
1. No package java-17-openjdk available (workaround): 
   * enable the Amazon Corretto 17 repository
   * install java
