#!/bin/bash
yum remove -y java
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade
yum install -y fontconfig
# java 17 installation
amazon-linux-extras enable corretto17
yum clean metadata
yum install -y java-17-amazon-corretto
yum install -y jenkins
systemctl daemon-reload
chkconfig jenkins on
service jenkins start