#!/bin/bash

ns=${NAMESPACE:-"hub-ci"}
oc=${oc:-""}

echo ${ns}

oc delete namespace ${ns} --ignore-not-found

oc create namespace ${ns}

# this will apply the secrets, serviceaccount and configmap for replace-tokens task
kubectl apply -f commons/ -n ${ns}

kubectl create configmap kubeconfig --from-file="${HOME}/Downloads/kubeconfig" -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildah/0.2/buildah.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/replace-tokens/0.1/replace-tokens.yaml -n ${ns}

# to be updated in catalg for path_context
#kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/golangci-lint/0.1/golangci-lint.yaml -n ${ns}

kubectl apply -f api/golang-db-test.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/codecov/0.1/codecov.yaml -n ${ns}

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/kubernetes-actions/0.2/kubernetes-actions.yaml -n ${ns}

[[ ! -z ${oc} ]] &&
    oc adm policy add-scc-to-user privileged system:serviceaccount:${ns}:quay-login

kubectl -n ${ns} apply -f api/pipeline.yaml
kubectl -n ${ns} create -f api/pipelinerun.yaml
