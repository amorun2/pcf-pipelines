# Install Docker on ubuntu-xenial
# This is only necessary for building the docker image
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-get update

sudo apt-cache policy docker-engine
sudo apt-get install -y docker-engine
sudo systemctl status docker

# Build and push the docker image
sudo docker login
sudo docker build . -t pivotalservices/openstack-tools:latest
sudo docker push pivotalservices/openstack-tools

