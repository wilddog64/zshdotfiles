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

function is_linux() {
   if [[ "$(uname -s)" == "Linux" ]]; then
      return 0
   else
      return 1
   fi
}

function is_redhat_family() {
   [[ -f /etc/redhat-release ]] && return 0 || return 1
}

function is_debian_family() {
   [[ -f /etc/debian_version ]] && return 0 || return 1
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

   if is_mac; then
      install_colima
   fi
   if  ! command_exist docker ; then
      echo docker does not exist, install it
      brew install docker
   else
      echo docker installed already
   fi

   if is_mac; then
      docker context use colima
   fi
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
      curl -f -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
   else
      echo k3d installed already
   fi
}

function install_istioctl() {
   if  ! command_exist istioctl ; then
      curl -f -s https://raw.githubusercontent.com/istio/istio/master/release/downloadIstioCandidate.sh | bash
   fi
}

function create_k3d_cluster() {
   cluster_name=$1

   if k3d cluster list | grep -q "$cluster_name"; then
      echo "Cluster $cluster_name already exists, skip"
      return 0
   fi

   yaml=$(mktemp -t k3d-XXXX.yaml)
   cat > "$yaml" <<-EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata: { name: $cluster_name }
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

   install_istioctl
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

function install_smb_csi_driver() {
   if is_mac ; then
      echo "SMB CSI driver is not supported on macOS"
      echo "use nfs storage class instead"
      exit 1
   fi
   install_helm
   helm repo add smb-csi-driver https://kubernetes-sigs.github.io/smb-csi-driver
   helm repo update
   helm upgrade --install smb-csi-driver smb-csi-driver/smb-csi-driver \
      --namespace kube-system

   if [[ $? != 0 ]]; then
      echo "Failed to install SMB CSI driver"
      exit 1
   fi
}

function create_nfs_share() {
   if is_mac ; then
      echo "Creating NFS share on macOS"
      mkdir -p $HOME/k3d-nfs
      if ! grep "$HOME/k3d-nfs" /etc/exports > /dev/null; then
         echo "$HOME/k3d-nfs -alldirs -mapall=501:200 -network $(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}') -mask" | \
            sudo tee -a /etc/exports
         sudo nfsd enable
         sudo nfsd update
         showmount -e localhost
      fi
   fi
}
function install_nfscsi_storage_drivers() {
   create_nfs_share
   install_helm
   helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
   helm upgrade --install csi-nfs csi-driver-nfs/csi-driver-nfs -n kube-system

   cat <<-EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-csi
provisioner: csi-driver-nfs
parameters:
  archiveOnDelete: "false"
  server: host.docker.internal
  share: $HOME/k3d-nfs
mountOptions:
  - nolock
  - noatime
  - nfsvers=4.1
reclaimPolicy: Retain
volumeBindingMode: Immediate
EOF
kubectl annotate sc nfs csi storageclass.kubernetes.io/is-default-class=true --overwrite
}

## -- main --
install_k3d
create_k3d_cluster "k3d-cluster"
configure_k3d_cluster_istio "k3d-cluster"
if is_mac ; then
   install_nfscsi_storage_drivers
elif is_linux ; then
   install_smb_csi_driver
fi
