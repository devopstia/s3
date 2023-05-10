
## Get the stable version of jenkins here
https://www.jenkins.io/changelog-stable/

## Check the jenkins version
http://[IP]:8080/about/

## Jenkins upgrade from 2.387.1
1. Install java 11 first 
```sh
https://stackoverflow.com/questions/52504825/how-to-install-jdk-11-under-ubuntu
apt-get install openjdk-11-jdk -y 
java --version
update-java-alternatives --list
update-alternatives --config java
```
2. stop jeniks
```sh
systemctl stop jenkins
systemctl status jenkins
```
3. rename a war file
```sh
/usr/share/jenkins/
mv jenkins.war jenkins.war.old
```

5. Download a new war file
```sh
https://updates.jenkins-ci.org/download/war/[jenkins_version]/jenkins.war 

wget https://updates.jenkins-ci.org/download/war/2.289.2/jenkins.war 
wget https://updates.jenkins-ci.org/download/war/2.387.1/jenkins.war
```

6. change permission
```sh
chown root:root jenkins.war
chmod 644 jenkins.war
```

7. start jenkins
```sh
systemctl start jenkins
systemctl status jenkins
```

8. update pluging
install all plugin in available and restart jenkins. if after this, you still have some plugin that were not update because it is deplicated, uninstall those
