#!/bin/bash
 
# Pull latest container
docker pull jenkins/jenkins
 
# Setup local configuration folder
# Should already be in a jenkins folder when running this script.    
sudo mkdir /var/jenkins_home
chown 1000 /var/jenkins_home
docker run -d -p 80:8080 -v /var/jenkins_home:/var/jenkins_home:z -t jenkins/jenkins
docker logs --follow jenkins