#!/usr/bin/env bash

service_name=$1
env_name=$2
container=$3
if [ -z "$service_name" ] || [ -z "$env_name" ] || [ -z "$container" ]; then
   echo "Usage: $0 <service_name> <env_name> <container>"
   echo "Example: $0 config-manager-service qa2 odysseus-sailing-data-767886ff78-gp7qr"
   exit 1
fi

kubectl exec -n "$service_name-$env_name" "$container" -c istio-proxy -- curl -Ss -f -kv https://config-manager-service-qa2.k8s.qa.costcotravel.com/${service_name}/${env_name}

