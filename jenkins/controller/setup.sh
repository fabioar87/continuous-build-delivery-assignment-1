#!/bin/bash

yum upgrade

echo "Installing Java 17 environment"
yum install -y java-17-amazon-corretto


echo "Installing Amazon Linux extras"
amazon-linux-extras install epel -y

echo "Install Jenkins stable release"
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install jenkins -y
systemctl daemon-reload
chkconfig jenkins on

echo "Install git"
yum install -y git

echo "Installing apache-maven"
export MAVEN_VERSION=3.9.6
cd /opt
wget https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
tar -xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz
ln -s apache-maven-${MAVEN_VERSION} maven

tee /etc/profile.d/maven.sh <<EOF
export M2_HOME=/opt/maven
export PATH=\$M2_HOME/bin:\$PATH
EOF

chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

echo "Installing sonar-scanner"
sudo wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
sudo unzip sonar-scanner-cli-*.zip -d /opt
sudo ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner

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