# AWS Kubernetes Cluster Setup using KOPS

This guide provides detailed steps for setting up a production-grade Kubernetes cluster on AWS using KOPS (Kubernetes Operations).

## Prerequisites

- AWS Account with administrative access
- Registered DNS domain
- AWS CLI configured
- EC2 instance (t2.medium) for cluster management
- S3 bucket for storing cluster state
- IAM roles and permissions configured

## Environment Setup

### 1. System Requirements

Create an EC2 instance with the following specifications:
- Instance type: t2.medium
- Operating System: Linux
- IAM Role: Configured with necessary AWS permissions

### 2. Install Required Tools

```bash
# Install KOPS
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/

# Install kubectl
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### 3. Configure Environment Variables

Add the following to your `~/.bashrc`:

```bash
export NAME=cloudvishwakarma.in
export KOPS_STATE_STORE=s3://cloudvishwakarma.in
export AWS_REGION=us-east-1
export CLUSTER_NAME=cloudvishwakarma.in
export EDITOR='/usr/bin/nano'
```

Apply the changes:
```bash
source ~/.bashrc
```

## Cluster Creation

### 1. Generate SSH Keys

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### 2. Create Cluster Configuration

Standard 3-Node Cluster:
```bash
kops create cluster --name=cloudvishwakarma.in \
    --state=s3://cloudvishwakarma.in \
    --zones=us-east-1a,us-east-1b \
    --node-count=2 \
    --control-plane-count=1 \
    --node-size=t3.medium \
    --control-plane-size=t3.medium \
    --control-plane-zones=us-east-1a \
    --control-plane-volume-size 10 \
    --node-volume-size 10 \
    --ssh-public-key ~/.ssh/id_ed25519.pub \
    --dns-zone=cloudvishwakarma.in \
    --dry-run --output yaml > cluster.yml
```

### 3. Deploy the Cluster

```bash
# Create the cluster
kops create -f cluster.yml

# Update the cluster
kops update cluster --name cloudvishwakarma.in --yes --admin

# Validate the cluster
kops validate cluster --wait 10m
```

## Production Best Practices

1. **High Availability Setup**
   - Use multiple availability zones
   - Deploy multiple control plane nodes
   - Configure auto-scaling groups

2. **Security**
   - Implement proper IAM roles and policies
   - Regular security updates
   - Network policies configuration
   - Enable encryption at rest

3. **Monitoring and Backup**
   - Regular backup of cluster state
   - Implement monitoring solutions (Prometheus/Grafana)
   - Set up logging aggregation
   - Configure alerts for critical events

4. **Resource Management**
   - Implement resource quotas
   - Configure pod security policies
   - Set up proper node labels and taints

## Cluster Management

### Scaling
To modify the number of nodes:
```bash
kops edit ig nodes
kops update cluster --yes
```

### Updates
To update cluster configuration:
```bash
kops edit cluster
kops update cluster --yes
```

### Deletion
To delete the cluster:
```bash
kops delete -f cluster.yml --yes
```

## Troubleshooting Tips

1. Always validate cluster status after changes
2. Check AWS resources in the console
3. Verify DNS configuration
4. Monitor cluster logs
5. Ensure proper IAM permissions

## Important Notes

- Keep your SSH keys secure and backed up
- Regularly backup the S3 bucket containing cluster state
- Monitor AWS costs and resource usage
- Keep KOPS and kubectl versions up to date
- Document any custom modifications to the cluster configuration

## References

- [KOPS Official Documentation](https://kops.sigs.k8s.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [AWS Best Practices](https://aws.amazon.com/kubernetes/)