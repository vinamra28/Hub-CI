#!/bin/bash

ns=${NAMESPACE:-"hub-ci"}
oc=${oc:-"1"}

echo ${ns}

oc delete namespace ${ns} --ignore-not-found

oc create namespace ${ns}

kubectl apply -f secret.yaml -n ${ns}

kubectl create configmap kubeconfig --from-file="${HOME}/Downloads/kubeconfig" -n ${ns}

kubectl apply -f tokens-configmap.yaml -n ${ns}

kubectl apply -f serviceaccount.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/npm/0.1/npm.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildah/0.2/buildah.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/codecov/0.1/codecov.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/replace-tokens/0.1/replace-tokens.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/kubernetes-actions/0.2/kubernetes-actions.yaml -n ${ns}

[[ ! -z ${oc} ]] && \
oc adm policy add-scc-to-user privileged system:serviceaccount:${ns}:quay-login

kubectl apply -f pipeline.yaml -n ${ns}

kubectl apply -f pipelinerun.yaml -n ${ns}
