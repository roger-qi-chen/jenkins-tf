#!/bin/bash

#install docker

sudo mkdir /var/jenkins_home

sudo apt-get -y install     apt-transport-https     ca-certificates     curl     gnupg-agent     software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository  -y  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker 
sudo docker version
sudo docker images

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
cd /var/www/html
echo "<html><h1> Jenkins is healthy</h1></html>" > index.html 

#mount ebs
sudo mkfs -t xfs /dev/nvme1n1  #sudo mkfs -t xfs /dev/xvdh
sudo mount /dev/nvme1n1 /var/jenkins_home  #sudo mount /dev/xvdh /var/jenkins_home

#to solve the mount error: "wrong fs type, bad option, bad superblock on /dev/nvme1n1, missing codepage or helper program, or other error."
sudo apt install nfs-common

#update /ets/fstab
sudo cp /etc/fstab  /etc/fstab.orig
sudo chmod 666 /etc/fstab


#sudo echo UUID=$(blkid |grep xvdh |awk -F "\"" '{print $2}') /var/jenkins_home xfs(changed to auto) defaults,nofail 0 2 >>/etc/fstab
sudo echo UUID=$(blkid |grep nvme1n1 |awk -F "\"" '{print $2}') /var/jenkins_home auto defaults,nofail 0 2 >>/etc/fstab
sudo chmod 644 /etc/fstab

sudo docker run --name jenkins -u root -d -v /var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-p 8080:8080 -p 50000:50000 jenkinsci/blueocean
