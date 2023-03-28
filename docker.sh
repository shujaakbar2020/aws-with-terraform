#! /bin/bash
sudo apt update -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update -y
sudo apt-get install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get install docker-compose -y
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker ${USER}
sudo apt update -y
sudo apt install mysql-server -y
sudo systemctl start mysql.service