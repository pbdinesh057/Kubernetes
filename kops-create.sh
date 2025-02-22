#!/bin/bash

# Download and install kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/

# Download and install kubectl
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install bash-completion
sudo apt-get update
sudo apt-get install -y bash-completion

# Setup kubectl completion and alias
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc

# Add environment variables
echo 'export NAME=dineshtopgun.xyz' >>~/.bashrc
echo 'export KOPS_STATE_STORE=s3://dineshtopgun.xyz' >>~/.bashrc
echo 'export AWS_REGION=us-east-1' >>~/.bashrc
echo 'export CLUSTER_NAME=dineshtopgun.xyz' >>~/.bashrc
echo 'export EDITOR=/usr/bin/nano' >>~/.bashrc

# Generate SSH key
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# Clone repository and create cluster
git clone https://github.com/pbdinesh057/Kubernetes
cd Kubernetes

# Create and update cluster
kops create -f cluster.yml
kops update cluster --name dineshtopgun.xyz --yes --admin
kops validate cluster --wait 10m
