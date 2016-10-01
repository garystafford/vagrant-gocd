#!/bin/sh

########################################################################
# title:          Bootstrap a GoCD Server/Agent Server
# author:         Gary A. Stafford (https://programmaticponderings.com)
# url:            https://github.com/garystafford/vagrant-gocd
# description:    Bootstrap a GoCD Server/Agent Server
# usage:          sh ./bootstrap.sh
########################################################################

# set -ex

cd /vagrant

# Install Oracle JDK
# (http://stackoverflow.com/a/10959815/580268)
jdk_rpm=jdk-8u101-linux-x64.rpm
wget --no-check-certificate --no-cookies \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  --quiet http://download.oracle.com/otn-pub/java/jdk/8u101-b13/${jdk_rpm}
rpm -ivh ${jdk_rpm}
printf "export JAVA_HOME=/usr/java/jdk1.8.0_101\nexport PATH=\$PATH:\$JAVA_HOME/bin" > /etc/profile.d/java.sh

# check installation
javac -version

# Install Gradle
# (https://gist.github.com/parzonka/9371885 - pzbitskiy)
gradle_version=3.1
mkdir /opt/gradle
wget -qN http://services.gradle.org/distributions/gradle-${gradle_version}-all.zip
unzip -oq ./gradle-${gradle_version}-all.zip -d /opt/gradle
ln -sfnv gradle-${gradle_version} /opt/gradle/latest
printf "export GRADLE_HOME=/opt/gradle/latest\nexport PATH=\$PATH:\$GRADLE_HOME/bin" > /etc/profile.d/gradle.sh
. /etc/profile.d/gradle.sh
hash -r ; sync
# check installation
gradle -v

# Install GoCD Server/Agent
# (https://docs.go.cd/current/installation/install/server/linux.html#rpm-based-distributions-ie-redhatcentosfedora)
echo "
[gocd]
name     = GoCD YUM Repository
baseurl  = https://download.go.cd
enabled  = 1
gpgcheck = 1
gpgkey   = https://download.go.cd/GOCD-GPG-KEY.asc
" | sudo tee /etc/yum.repos.d/gocd.repo

sudo mkdir -p /var/go
sudo dnf install -y go-server
sudo dnf install -y go-agent


# Install Gradle plugin for GoCD
gradle_plugin=gocd-gradle-plugin-1.0.6.jar
plugin_path=/var/lib/go-server/plugins/external
wget -qN https://github.com/jmnarloch/gocd-gradle-plugin/releases/download/1.0.6/${gradle_plugin}
sudo cp ${gradle_plugin} ${plugin_path}/${gradle_plugin}

# Set GoCD environment variables
ip_addr=$(hostname -I)
hostname=$(hostname)
sed -i.bkp "/PATH=/i export GO_SERVER=${ip_addr}" /home/vagrant/.bash_profile
sed -i.bkp "/PATH=/i export GO_SERVER_URL=https://${hostname}:8154/go" /home/vagrant/.bash_profile

# firewalld vs. iptables
sudo systemctl restart firewalld.service # make sure it is running
sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8153/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8154/tcp
sudo systemctl restart firewalld.service
sudo firewall-cmd --zone=public --list-all

# firewalld vs. iptables
#https://blog.christophersmart.com/2014/01/15/add-permanent-rules-to-firewalld/
#sudo iptables -I INPUT 1 -p tcp --dport 8153 -j ACCEPT
#sudo iptables -I INPUT 1 -p tcp --dport 8154 -j ACCEPT
#sudo iptables -L -n | grep 815
# cat /var/log/go-agent/go-agent.log # check for connection errors

# Restart GoCD Server/Agent
sudo /etc/init.d/go-server restart \
 &&  sleep 10 \
 && sudo /etc/init.d/go-agent restart \
 &&  sleep 10 \
 && /etc/init.d/go-server status \
 && /etc/init.d/go-agent status # check status
