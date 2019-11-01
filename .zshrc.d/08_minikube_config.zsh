if [ "$(minikube status | grep -c Stopped)" -ge 1 ]; then
  minikube start
fi

if [ "$(minikube status | grep -c Stopped)" -ge 1 ]; then
  echo "Unable to start minikube, docker not setup"
else
  eval $(minikube docker-env)
fi

