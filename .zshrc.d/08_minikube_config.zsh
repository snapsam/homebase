
# Until I can get this sorted
#if [ "$(minikube status | grep -c Stopped)" -ge 1 ]; then
#  minikube start
#fi
#
#if [ "$(minikube status | grep -c Stopped)" -ge 1 ]; then
#  echo "Unable to start minikube, docker not setup"
#else
#  eval $(minikube docker-env)
#fi

CURRENT_CONTEXT=$(kubectl config current-context)

if (minikube status | grep apiserver | grep "Running"); then
  [ "${CURRENT_CONTEXT}" = "minikube" ] || kubectl config use-context minikube

  kubectl apply -f ~/workspace/useful-pods/minikube-host.yaml

  [ "${CURRENT_CONTEXT}" = "minikube" ] || kubectl config use-context "${CURRENT_CONTEXT}"
fi
