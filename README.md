## vagrant-gocd
Create Vagrant VM based on Fedora 21 64-bit. Install ThoughtWorks' go server and agent. Install Gradle and the go Gradle plug-in.

The following files need to be loaded in the this directory, before running `vagrant up`
* `go-agent-15.2.0-2248.noarch.rpm`
* `gocd-gradle-plugin-1.0.0.jar`
* `go-server-15.2.0-2248.noarch.rpm`
* `gradle-2.7-bin.zip`
* `jdk-8u60-linux-x64.rpm`

If any versions are different than above files, change the `bootstrap.sh` file to reflect version differences, before running `vagrant up`