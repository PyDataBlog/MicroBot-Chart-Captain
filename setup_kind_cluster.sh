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

# Create a Kind cluster
echo "Creating a Kind cluster..."
kind create cluster

# Install the Nginx Ingress Controller
echo "Installing Nginx Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/kind/deploy.yaml

# Install Cert-Manager
echo "Installing Cert-Manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0-beta.1/cert-manager.yaml

# Create Let's Encrypt Issuer
echo "Creating Let's Encrypt Issuer..."
cat <<EOF | kubectl apply -f -
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