## Vagrant Fedora VM with ThoughtWorks GoCD Server/Agent

#### Objectives

-   Create a Vagrant VM based on Fedora (`Fedora 24 Workstation Edition`)
-   Install the latest ThoughtWorks GoCD Server and Agent (`16.10.0-4131`)
-   Install the latest versions of the Java OpenJDK (`1.8.0_102`)
-   Install the latest versions of the Gradle (`3.1`)
-   Install the latest Gradle plug-in for ThoughtWorks' GoCD (`1.0.6`)

#### Dependencies

The following files need to be in the project's directory prior running `vagrant up`

-   `jdk-8u101-linux-x64.rpm`
-   `gocd-gradle-plugin-1.0.6.jar`

If versions are different than above files, change the `bootstrap.sh` file to reflect version differences, before running `vagrant up`

If everything started correctly, open GoCD in a browser at `http:localhost:8153/go` or secured at `https:localhost:8154/go`

-   To build the project, run `vagrant up` from within the project directory
-   To recreate the project, run `vagrant destroy -f && vagrant up` from within the project directory
-   Keep the box up-to-date with `vagrant box update`

#### Troubleshooting

-   `vagrant ssh -c 'cat /var/log/go-server/go-server.log'` # check for errors
-   `vagrant ssh -c 'cat /var/log/go-agent/go-agent.log'` # check for errors
-   `vagrant ssh -c 'sudo /etc/init.d/go-server status && sudo /etc/init.d/go-agent status'` # check GoCD is running
-   `vagrant ssh -c 'sudo cat /etc/*release'` # check os version
-   `vagrant ssh -c 'sudo java -version'` # check java version

#### Links

-   [GoCD](https://www.go.cd/)
-   [GoCD Plugins](https://www.go.cd/plugins/)
-   [GoCD Gradle Plugin](https://github.com/jmnarloch/gocd-gradle-plugin)
-   [Vagrant](https://github.com/mitchellh/vagrant)
