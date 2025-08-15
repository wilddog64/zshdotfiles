#!/usr/bin/env bash

function command_exist() {
    command -v "$1" &> /dev/null
}


function is_mac() {
   if [[ "$(uname -s)" == "Darwin" ]]; then
      return 0
   else
      return 1
   fi
}

function install_colima() {

   if ! is_mac ; then
      echo "Colima is only supported on macOS"
      exit 1
   fi

   if ! command_exist colima ; then
      echo colima does not exist, install it
      brew install colima
      colima start
   else
      echo colima installed already
   fi
}

function install_docker() {

   install_colima
   if  ! command_exist docker ; then
      echo docker does not exist, install it
      brew install docker
   else
      echo docker installed already
   fi

   docker context use colima
   export DOCKER_HOST=unix:///Users/$USER/.colima/docker.sock

   if grep DOKER_HOST $HOME/.zsh/zshrc | wc -l == 0 ; then
      echo "export DOCKER_HOST=unix:///Users/$USER/.colima/docker.sock" >> $HOME/.zsh/zshrc
      echo "export DOCKER_CONTEXT=colima" >> $HOME/.zsh/zshrc
      echo "restart your shell to apply the changes"
   fi
}

function install_k3d() {
   install_docker

   if  ! command_exist k3d ; then
      echo k3d does not exist, install it
      brew install k3d
   else
      echo k3d installed already
   fi
}

function install_istioctl() {
   if  ! command_exist istioctl ; then
      echo istioctl does not exist, install it
      brew install istioctl
   else
      echo istioctl installed already
   fi
}

function create_k3d_cluster() {
   cluster_name=$1

   yaml=$(mktemp -t k3d-XXXX.yaml)
   cat > "$yaml" <<-EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata: { name: lab }
servers: 1
agents: 3
ports:
  - port: 8080:80
    nodeFilters: [loadbalancer]
  - port: 8443:443
    nodeFilters: [loadbalancer]
options:
  k3d: { wait: true }
  k3s:
    extraArgs:
      - arg: "--disable=traefik"
        nodeFilters: ["server:*"]
      - arg: "--disable=local-storage"
        nodeFilters: ["server:*"]
EOF
   k3d cluster create --config "$yaml"

   trap 'rm -f "$yaml"' EXIT INT

}

function configure_k3d_cluster_istio() {
   cluster_name=$1

   istioctl x precheck
   istioctl install -y \
     --set profile=default \
     --set values.pilot.resources.requests.cpu=100m \
     --set values.pilot.resources.requests.memory=256Mi \
     --set values.global.proxy.resources.requests.cpu=50m \
     --set values.global.proxy.resources.requests.memory=64Mi \
     --set values.gateways.istio-ingressgateway.resources.requests.cpu=100m \
     --set values.gateways.istio-ingressgateway.resources.requests.memory=256Mi \
     --set values.gateways.istio-ingressgateway.type=LoadBalancer
   kubectl label ns default istio-injection=enabled --overwrite
}

function install_helm() {
   if  ! command_exist helm ; then
      echo helm does not exist, install it
      brew install helm
   else
      echo helm installed already
   fi
}

function configure_smb_csi_driver() {
   helm repo add smb-csi-driver https://kubernetes-sigs.github.io/smb-csi-driver
   helm repo update
   helm upgrade --install smb-csi-driver smb-csi-driver/smb-csi-driver \
      --namespace kube-system

   if [[ $? != 0 ]]; then
      echo "Failed to install SMB CSI driver"
      exit 1
   fi
}

## -- main --
install_k3d
install_istioctl
install_helm
create_k3d_cluster "k3d-cluster"
configure_k3d_cluster_istio "k3d-cluster"
configure_smb_csi_driver
