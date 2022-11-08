#!/bin/bash

#install env
#apt-get update
#curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
#chmod +x ./kind
#mv ./kind /usr/local/bin
kind create cluster --config cluster.yaml --name fun
kind create cluster --name fun
kubectx kind-fun
kubectl apply -f ingress.yaml
kubectl apply -f metrics-server.yaml

#build image
docker build -t funflask:v3 app/

#send to local
kind load docker-image funflask:v3 --name fun

#set deploy apps
kubectl create ns funflask
sleep 60s
echo ""
echo "Wait ingress ready"
echo ""
kubectl apply -f kube/deployment-flask.yaml -n funflask
kubectl apply -f kube/metrics-server.yaml
