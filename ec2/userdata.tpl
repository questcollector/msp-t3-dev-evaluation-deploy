#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

### tcp keepalive settings
echo 240 > /proc/sys/net/ipv4/tcp_keepalive_time
echo 30 > /proc/sys/net/ipv4/tcp_keepalive_intvl

apt update

### awscli
apt install awscli -y

### docker
apt-get update

apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip -y

mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

cat <<EOF > "/etc/docker/daemon.json"
{
  "log-driver": "awslogs",
  "log-opts": {
    "awslogs-region": "us-east-1",
    "awslogs-group" : "msp-t3-dev-evaluation"
  }
}
EOF

service docker restart

docker swarm init

## init-settings

mkdir -p /app/rabbit-data
mkdir -p /app/db/data

aws s3 cp s3://${s3_bucket}/files.zip /app/files.zip

cd /app

unzip /app/files.zip

chmod 777 /app/db/initdb.d/init-mongo.js

## execute app

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 275291497228.dkr.ecr.us-east-1.amazonaws.com

docker stack deploy --compose-file /app/docker-compose.yml --with-registry-auth mspt3