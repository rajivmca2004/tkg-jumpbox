#!/bin/sh

curl -sLo clusterawsadm https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v0.5.5/clusterawsadm-linux-amd64 && chmod +x clusterawsadm && sudo cp clusterawsadm /usr/local/bin/ && rm clusterawsadm

sudo DEBIAN_FRONTEND=noninteractive apt-get install jq -y

sudo DEBIAN_FRONTEND=noninteractive apt-get install git -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin