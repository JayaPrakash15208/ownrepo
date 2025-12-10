#!/bin/bash
set -e
# Install docker
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ubuntu


# Create simple runner dir
mkdir -p /opt/mini-devops
cat > /opt/mini-devops/run.sh <<'EOF'
#!/bin/bash
set -e
# IMAGE_PLACEHOLDER will be replaced by deployment step or you can manually set it
IMAGE="your_dockerhub_user/mini-devops-app:latest"
# Pull and run
/usr/bin/docker pull $IMAGE || true
# Stop any existing container
if /usr/bin/docker ps -q --filter "name=mini-devops" | grep -q .; then
/usr/bin/docker rm -f mini-devops || true
fi
/usr/bin/docker run -d --name mini-devops -p 5000:5000 $IMAGE
EOF


chmod +x /opt/mini-devops/run.sh
# Run once on boot (it may fail if image not present yet)
/opt/mini-devops/run.sh || true
