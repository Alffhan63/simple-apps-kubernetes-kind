#!/bin/bash

internalip=$(kubectl get nodes -o=wide |awk '{print $6}' |awk 'FNR == 2 {print}')
namecluster=fun
namespace=funflask

#install env
sudo apt-get update
sudo curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
sudo chmod 777 ./kind
sudo mv ./kind /usr/local/bin
kind create cluster --config env/cluster.yaml --name $namecluster
kind create cluster --name $namecluster
kubectx kind-fun
kubectl apply -f env/ingress.yaml
kubectl apply -f env/metrics-server.yaml

#build image
docker build -t $namespace:v3 app/

#send to local
kind load docker-image $namespace:v3 --name $namecluster

#set deploy apps
kubectl create ns $namespace
sleep 60s
echo ""
echo "Wait ingress ready"
echo ""
kubectl apply -f kube/deployment-flask.yaml -n $namespace
kubectl apply -f kube/metrics-server.yaml

echo ""
echo "Get Internal IP Ingress"
echo ""
sleep 5s
kubectl get nodes -o=wide |awk '{print $6}' |awk 'FNR == 2 {print}'

echo ""
echo "test apps"
sleep 5s
curl -i $internalip
