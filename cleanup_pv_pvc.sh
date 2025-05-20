#!/bin/bash

# Usage: ./cleanup-pv-pvc.sh <namespace> <pvc-name> <pv-name>

NAMESPACE=$1
PVC_NAME=$2
PV_NAME=$3

function K() {
   kubectl "$@"
   if [[ $? != 0  ]];; then
      echo "Error: kubectl command failed. Exiting."
      exit -1
   fi
}

function k_patch() {
   K patch "$@"
   if [[ $? != 0 ]]; then
      echo "Error: kubectl patch command failed. Exiting."
      exit -1
   fi
}

# patch PV -- remove finalizers
k_patch $NAMESPACE $PV_NAME -p '{"metadata":{"finalizers":null}}' --type=merge
# patch PVC -- remove finalizers
k_patch $NAMESPACE $PVC_NAME -p '{"spec":{"claimRef" null}}' --type=merge

# echo "==== Step 1: Deleting PVC: $PVC_NAME in namespace: $NAMESPACE ===="
# kubectl patch pvc $PVC_NAME -n $NAMESPACE -p '{"metadata":{"finalizers":null}}' --type=merge
# kubectl delete pvc $PVC_NAME -n $NAMESPACE --wait=false
#
# echo ""
# echo "==== Step 2: Patching PV: $PV_NAME to remove claimRef ===="
# kubectl patch pv $PV_NAME -p '{"spec":{"claimRef":null}}' --type=merge
#
# echo ""
# echo "==== Step 3: Removing PV finalizers if needed ===="
# kubectl patch pv $PV_NAME -p '{"metadata":{"finalizers":null}}' --type=merge
#
# echo ""
# echo "==== Step 4: Deleting PV: $PV_NAME ===="
# kubectl delete pv $PV_NAME --wait=false
#
# echo ""
# echo "==== Done. Now you can re-apply your fresh PV and PVC YAML files. ===="
