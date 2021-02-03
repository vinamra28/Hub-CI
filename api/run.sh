#!/bin/bash

kubectl create secret generic quay-secret  \
        --type="kubernetes.io/basic-auth" \
        --from-literal=username= \
        --from-literal=password=

kubectl annotate secret quay-secret \
        tekton.dev/docker-0=quay.io

kubectl apply -f serviceaccount.yaml
oc adm policy add-scc-to-user privileged system:serviceaccount:tekton-hub:quay-login

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildah/0.2/buildah.yaml

# to be updated in catalg for path_context
#kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/golangci-lint/0.1/golangci-lint.yaml

kubectl apply -f golang-db-test.yaml

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/codecov/0.1/codecov.yaml

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/kubernetes-actions/0.2/kubernetes-actions.yaml