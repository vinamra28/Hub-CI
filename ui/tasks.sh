#!/bin/bash

ns=${NAMESPACE:-"hub"}
oc=${oc:-""}

echo ${ns}

kubectl apply -f secret.yaml -n ${ns}

kubectl apply -f serviceaccount.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/npm/0.1/npm.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildah/0.2/buildah.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/kubernetes-actions/0.1/kubernetes-actions.yaml -n ${ns}

[[ ! -z ${oc} ]] && \
oc adm policy add-scc-to-user privileged system:serviceaccount:${ns}:quay-login

kubectl apply -f pipelinerun.yaml -n ${ns}
