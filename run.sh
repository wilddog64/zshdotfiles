#!/usr/bin/env bash
podman run -v $(pwd):/mnt/workspace -w /mnt/workspace \
           -v $HOME/src/gitrepo/costco/build-deploy/config:/root/.config \
           -v $HOME/src/gitrepo/costco/build-deploy/local:/root/.local \
           -e PACIFIC_JENKINS_URL="${PACIFIC_JENKINS_URL}" \
           -e PACIFIC_JENKINS_USER=${PACIFIC_JENKINS_USER} \
           -e PACIFIC_JENKINS_PASS=${PACIFIC_JENKINS_PASS} \
           -e CMDB_ENDPOINT=${CMDB_ENDPOINT} \
           -e CMDB_SESSION_CREATE_ENDPOINT="${CMDB_SESSION_CREATE_ENDPOINT}" \
           -e CMDB_SESSION_AUTH_ENDPOINT="${CMDB_SESSION_AUTH_ENDPOINT}" \
           -e CMDB_API_KEY="${CMDB_API_KEY}" \
           --rm -it mcr.microsoft.com/azure-powershell pwsh

