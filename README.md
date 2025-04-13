# Continuous Build and Delivery: Pipeline Implementation

>@author: _Fabio Ribeiro_, **a00326833@student.tus.ie**

Continuous Build and Delivery, class (AL_KCNCM_9_1) pipeline project repository.

## Jenkins Custom Image - Baking process
> folder: ./jenkins

## NAT Component Custom Image - Baking process
> folder: ./nat

## Jenkins Deployment - Infrastructure and Computing
> folder: ./infrastructure

## Challenges: the NAT instance
To configure an extra layer of security, the Master Jenkins node will be deployed in a 
private subnet. Its external world internet access will be done using a NAT instance.
This NAT instance will be deployed on the public subnet. The private route table will 
be configured to redirect the Master Jenkins traffic to the deployed internet gateway (IGW).

AWS offers an out-of-box NAT gateway instance, but it will require an elastic IP, and the NAT
gateway maintenance can be costly (the costs are attached to the time and data usage).

#### Nat instance image requirements
Nat instance requirements.
* It is not using EIP (Elastic IP)
* It is configured to proxy (aggregate) all network traffic
* The NAT is located in the public subnet
  * This public subnet has a route table ruling that all traffic is proxied
    to the IGW (or the internet gateway)

TODO: implement a NAT SG. At this time it is using the default security group:
1. Ingress and Egress access general rule (from 0.0.0.0/0, protocol TCP, port 0)
2. Add an extra ingress rule configuring the SSH access to the NAT instance

### Bastion Host (Jump box)
* The Jenkins Master is not exposed to the external internet
* The jump box will provide access to the master instance located in the private subnet

It is possible to open an SSH tunnel:
```shell
ssh -L TARGET_PORT:TARGET_INSTANCE_PRIVATE_IP:22 ec2-user@BASTION_IP
```

Connection test:
1. 