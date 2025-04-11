#!/bin/bash

yum upgrade

echo "Installing Java 17 environment"
yum install -y java-17-amazon-corretto

echo "Installing Amazon Linux extras"
amazon-linux-extras install epel -y

echo "Install Jenkins stable release"
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl daemon-reload
chkconfig jenkins on

echo "Install git"
yum install -y git

echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d
mkdir -p /var/lib/jenkins/plugins
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
mv /tmp/config/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/config/install-plugins.sh
chown -R jenkins:jenkins /var/lib/jenkins/plugins
bash /tmp/config/install-plugins.sh
service jenkins start