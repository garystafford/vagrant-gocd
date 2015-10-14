## vagrant-gocd
Create a Vagrant VM based on Fedora 21 64-bit. 
Install ThoughtWorks' go server and agent. 
Install Java and Gradle
Install Gradle plug-in for ThoughtWorks' go.

The following files need to be loaded in the project's directory, before running `vagrant up`
* `jdk-8u60-linux-x64.rpm`
* `gradle-2.7-bin.zip`
* `go-server-15.2.0-2248.noarch.rpm`
* `go-agent-15.2.0-2248.noarch.rpm`
* `gocd-gradle-plugin-1.0.0.jar`

If versions are different than above files, change the `bootstrap.sh` file to reflect version differences, before running `vagrant up`

Assumes the VM's primary IP address, used for `GO_SERVER` environment variable, can be derived from:
```bash
ip_addr=$(hostname -I | awk '{ print $2}')
sed -i.bkp "/PATH=/i export GO_SERVER=${ip_addr}" /home/vagrant/.bash_profile
```

#### Troubleshooting
* `cat /var/log/go-server/go-server.log` # check for connection errors
* `cat /var/log/go-agent/go-agent.log` # check for connection errors
* `/etc/init.d/go-server status && /etc/init.d/go-agent` status # check both are running