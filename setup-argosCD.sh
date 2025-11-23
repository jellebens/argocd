minikube delete
minikube start --driver=docker
 
kubectl create ns argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.8/manifests/install.yaml

kubectl get all -n argocd


echo "Waiting for argocd-server pod to be ready..."
kubectl wait --namespace argocd --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server --timeout=300s
echo "argocd-server is ready!"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

helm upgrade --install cluster-bootstrap bootstrap



# kubectl port-forward svc/argocd-server -n argocd 8080:443