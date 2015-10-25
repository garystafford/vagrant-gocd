#! /usr/bin/env bash

# Install Oracle JDK
file=jdk-8u60-linux-x64.rpm
sudo rpm -ivh ${file}
sed -i.bkp '/PATH=/i export JAVA_HOME=/usr/java/jdk1.8.0_60' ~/.bash_profile
javac -version

# Install Gradle
version=2.7
file=gradle-${version}-bin.zip
sudo yum install -y unzip
unzip ${file}
sudo mkdir /usr/local/gradle/
sudo mv gradle-${version} /usr/local/gradle/gradle-${version}
sed -i.bkp '/PATH=/i export GRADLE_HOME=/usr/local/gradle/gradle-2.7' ~/.bash_profile
gradle --version

# Install go-server and go-agent
version=15.2.0-2248
sudo rpm -ivh go-server-${version}.noarch.rpm
sleep 10
sudo rpm -ivh go-agent-${version}.noarch.rpm

file=gocd-gradle-plugin-1.0.0.jar
plugin_path=/var/lib/go-server/plugins/external
sudo cp ${file} ${plugin_path}/${file}
#ip_addr=$(ip addr list eth1 |grep "inet " |cut -d' ' -f6|cut -d/ -f1)
ip_addr=$(hostname -I | awk '{ print $2}')
sed -i.bkp "/PATH=/i export GO_SERVER=${ip_addr}" /home/vagrant/.bash_profile

sed -i.bkp '/PATH=/i PATH=$PATH:$JAVA_HOME/bin:$GRADLE_HOME/bin' ~/.bash_profile

#sudo gedit /etc/default/go-server # change 8153 and 8154
#sudo gedit /etc/default/go-agent # change 8153 and 8154

# firewalld vs. iptables
#https://blog.christophersmart.com/2014/01/15/add-permanent-rules-to-firewalld/
sudo systemctl restart firewalld.service # make sure it is running
sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8163/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8164/tcp
sudo systemctl restart firewalld.service
sudo firewall-cmd --zone=public --list-all

sudo /etc/init.d/go-server restart && \
sleep 10 && \
sudo /etc/init.d/go-agent restart && \
/etc/init.d/go-server status && \
/etc/init.d/go-agent status # check status