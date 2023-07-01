#!/bin/bash

# bash setup_kind_cluster.sh -e user@example.com

# Parse command line arguments
while getopts ":e:" opt; do
  case ${opt} in
    e )
      EMAIL=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      exit 1
      ;;
  esac
done

# Create a microk8s cluster
echo "Creating a cluster..."
sudo snap install microk8s --classic --channel=1.27/stable
microk8s status --wait-ready
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s

# Install the Nginx Ingress Controller
echo "Installing Nginx Ingress Controller..."
microk8s kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

# Wait for the Nginx Ingress Controller to be ready
echo "Waiting for the Nginx Ingress Controller to be ready..."
microk8s kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# Install Cert-Manager
echo "Installing Cert-Manager..."
microk8s kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml

# Wait for the Cert-Manager to be ready
echo "Waiting for the Cert-Manager to be ready..."
microk8s kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# Create Let's Encrypt Issuer
echo "Creating Let's Encrypt Issuer..."
cat <<EOF | microk8s kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: $EMAIL
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF