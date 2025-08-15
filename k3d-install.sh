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
    cat > "$yaml" <<EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: $cluster_name
servers: 1
agents: 3
ports:
  - port: 8080:80
    nodeFilters: [loadbalancer]
  - port: 8443:443
    nodeFilters: [loadbalancer]
options:
  k3d:
    wait: true
  k3s:
    extraArgs:
      - arg: "--disable=traefik"
        nodeFilters: ["server:*"]
      - arg: "--disable=local-storage"
        nodeFilters: ["server:*"]
hostAliases:
  - ip: "$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')"
    hostnames: ["host.k3d.internal"]
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
   if grep -q "k3d-nfs" /etc/exports ; then
      echo "NFS share already exists, skip"
      return 0
   fi

   if is_mac ; then
      echo "Creating NFS share on macOS"
      mkdir -p $HOME/k3d-nfs
      if ! grep "$HOME/k3d-nfs" /etc/exports > /dev/null; then
         echo "$HOME/k3d-nfs -alldirs -mapall=501:20 -network 0.0.0.0 -mask 255.255.255.0" | \
            sudo tee -a /etc/exports
         sudo nfsd enable
         sudo nfsd update
         sudo nfsd restart  # Full restart instead of update
         showmount -e localhost
      fi
   fi
}

function test_nfs_connectivity() {
  echo "Testing basic connectivity to NFS server..."

  # Create a pod with networking tools
  kubectl run nfs-connectivity-test --image=nicolaka/netshoot --rm -it --restart=Never -- bash -c "
    echo 'Attempting to reach NFS port on host...'
    nc -zv host.k3d.internal 2049
    echo 'DNS lookup for host...'
    nslookup host.k3d.internal
    echo 'Tracing route to host...'
    traceroute host.k3d.internal
    echo 'Testing rpcinfo...'
    rpcinfo -p host.k3d.internal 2>/dev/null || echo 'RPC failed'
  "
}

function test_nfs_direct() {
  echo "Testing NFS connectivity directly from a pod..."

  # Create a pod that mounts NFS directly
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nfs-test-direct
spec:
  containers:
  - name: nfs-mount-test
    image: busybox
    command: ["sh", "-c", "mount | grep nfs; echo 'Testing NFS mount...'; mkdir -p /mnt/test; mount -t nfs -o vers=3,nolock host.k3d.internal:/Users/$(whoami)/k3d-nfs /mnt/test && echo 'Mount successful' || echo 'Mount failed'; ls -la /mnt/test; sleep 3600"]
    securityContext:
      privileged: true
  restartPolicy: Never
EOF

  echo "Waiting for pod to be ready..."
  sleep 5
  kubectl logs nfs-test-direct
}

function debug_nfs_storage() {
  echo "===== DEBUGGING NFS STORAGE ====="

  echo "1. Checking NFS server status..."
  sudo nfsd status
  echo "NFS exports:"
  cat /etc/exports

  echo "2. Verifying NFS connectivity from host..."
  showmount -e localhost

  echo "3. Checking CSI driver pods..."
  kubectl get pods -n kube-system -l app.kubernetes.io/instance=csi-nfs

  echo "4. Checking StorageClass..."
  kubectl get sc nfs-mac -o yaml

  echo "5. Checking for PVC events..."
  kubectl get events -n storage-test | grep -i persistentvolumeclaim

  echo "6. Checking PVC status..."
  kubectl get pvc -n storage-test nfs-test-claim -o yaml

  kubectl get pv
  echo "===== DEBUG COMPLETE ====="
}

function test_nfs_storage() {
  echo "Testing NFS storage with a PVC and test pod..."

  # Create a test namespace
  kubectl create namespace storage-test

  # Create a test PVC
  cat <<-EOF | kubectl apply -f - -n storage-test
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-test-claim
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: nfs-mac
  resources:
    requests:
      storage: 10Mi
EOF

  echo "Waiting for PVC to be bound..."
  kubectl wait --for=condition=Bound pvc/nfs-test-claim -n storage-test --timeout=60s || debug_nfs_storage

  # Create a pod that writes to the volume
  cat <<EOF | kubectl apply -f - -n storage-test
apiVersion: v1
kind: Pod
metadata:
  name: nfs-test-pod
spec:
  containers:
  - name: test-container
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - echo "NFS test successful at $(date)" > /data/test.txt;
      cat /data/test.txt;
      sleep 3600;
    volumeMounts:
    - name: nfs-volume
      mountPath: /data
  volumes:
  - name: nfs-volume
    persistentVolumeClaim:
      claimName: nfs-test-claim
EOF

  echo "Waiting for test pod to be ready..."
  kubectl wait --for=condition=Ready pod/nfs-test-pod -n storage-test --timeout=60s

  echo "Checking if test file was written successfully:"
  kubectl exec -n storage-test nfs-test-pod -- cat /data/test.txt

  echo "Testing complete. You should see the test message above if successful."
  echo "To clean up the test, run: kubectl delete namespace storage-test"

  trap 'kubectl delete namespace storage-test' EXIT
}

function install_nfscsi_storage_drivers() {
   create_nfs_share
   install_helm
   helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
   helm upgrade --install csi-nfs csi-driver-nfs/csi-driver-nfs -n kube-system

   # First delete the StorageClass if it exists
   if kubectl get sc nfs-mac &>/dev/null; then
      echo "Deleting existing StorageClass nfs-mac..."
      kubectl delete sc nfs-mac

      # Wait for deletion to complete
      while kubectl get sc nfs-mac &>/dev/null; do
         echo "Waiting for StorageClass deletion..."
         sleep 2
      done
      echo "StorageClass nfs-mac deleted successfully"
   fi

   # Then create it
   echo "Creating new StorageClass nfs-mac..."
   cat <<-EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
name: nfs-mac
provisioner: nfs.csi.k8s.io
parameters:
server: host.k3d.internal  # Use host alias defined in k3d config
share: /Users/$(whoami)/k3d-nfs                                    # Use dynamic user path
reclaimPolicy: Delete
volumeBindingMode: Immediate
mountOptions:
- vers=3                                # Downgrade to NFS v3 for better compatibility
- noatime
- nolock
EOF
# Set the StorageClass as default with correct syntax
kubectl annotate storageclass nfs-mac storageclass.kubernetes.io/is-default-class=true --overwrite
}

## -- main --
# Command line argument handling
if [[ $# -gt 0 ]]; then
    function_name=$1
    shift  # Remove the function name from the arguments

    if [[ "$(type -t $function_name)" == "function" ]]; then
        # Call the function with remaining arguments
        $function_name "$@"
    else
        echo "Error: Function '$function_name' not found"
        exit 1
    fi
    exit 0
fi

install_k3d
create_k3d_cluster "k3d-cluster"
configure_k3d_cluster_istio "k3d-cluster"
if is_mac ; then
   install_nfscsi_storage_drivers
   test_nfs_storage
   test_nfs_direct
elif is_linux ; then
   install_smb_csi_driver
fi
