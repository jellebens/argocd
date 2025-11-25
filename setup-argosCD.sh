#!/bin/bash

namespace=argocd-system


minikube delete
minikube start --driver=docker
 


# kubectl create ns $namespace

# kubectl apply -n $namespace -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.8/manifests/install.yaml

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm install argocd argo/argo-cd --namespace $namespace --create-namespace --version 9.1.4 -f argocd-values.yaml

echo "Waiting for argocd-server pod to be ready..."
kubectl wait --namespace $namespace --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server --timeout=300s 
echo "argocd-server is ready!"

kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" -n $namespace | base64 -d; echo

helm upgrade --install cluster-bootstrap bootstrap --create-namespace --namespace argocd



# kubectl port-forward svc/argocd-server -n argocd 8080:443