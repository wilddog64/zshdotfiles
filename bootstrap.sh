#!/usr/bin/env bash

## Variables
APT_REPO_KEY_URL="http://aptrepo.uswest2.icebrg.io/repo.pub"

read -r -d '' APT_REPO_LIST <<'EOF'
deb http://aptrepo.uswest2.icebrg.io/puppetlabs/ xenial puppet5

deb http://aptrepo.uswest2.icebrg.io/ubuntu xenial restricted main universe multiverse
deb http://aptrepo.uswest2.icebrg.io/ubuntu xenial-updates restricted main universe multiverse
deb http://aptrepo.uswest2.icebrg.io/ubuntu xenial-backports main restricted universe multiverse
deb http://aptrepo.uswest2.icebrg.io/ubuntu xenial-security restricted main universe multiverse
EOF


## Functions
function halt {
    local retcode="$1"
    shift

    # If there are extra arguments, assume they're a message
    if [[ "$#" -gt 0 ]]; then
        echo -e "$@"
    fi

    if [[ "$retcode" -ne 0 ]]; then
        echo "Refusing to continue bootstrap."
    fi

    exit "$retcode"
}

function list_interfaces {
    ip addr list | grep -E '[0-9]+: [a-zA-Z0-9]+:' | awk '{print $2}' | sed 's/://g' | tr '\n' ' '
}

function find_target_interface {
    for iface in $(list_interfaces); do
        if [[ "$iface" == "lo" ]]; then
            continue
        fi

        echo "$iface"
        return
    done

    halt 1 "Unable to find a candidate interface to configure against."
}

function check_rdns {
    local fqdn="$1"

    if echo "$fqdn" | grep -q "ip-10"; then
        halt 2 "RDNS does not appear to be set up for this machine."
    fi
}

function set_hostname {
    local newHostname="$1"

    echo "${newHostname}" > /etc/hostname
    hostname "${newHostname}"
}

function setup_host_info {
    local targetInterface=$(find_target_interface)
    local hostIPAddress=$(ip address show "$targetInterface" | grep "inet " | awk '{print $2}' | sed 's/\/24//')
    local hostFQDN=$(dig +short -x "$hostIPAddress")
    local hostname=$(echo "$hostFQDN" | cut -d '.' -f1)

    check_rdns "$hostFQDN"
    set_hostname "$hostname"
}

function setup_apt {
    local output

    output=$(curl -s "$APT_REPO_KEY_URL" | apt-key add - 2>&1)
    if [[ "$?" -ne 0 ]]; then
        halt 2 "Failed to add apt-get repository keys:\n$output"
    fi

    # Use -e here to make sure newlines come through
    echo -e "$APT_REPO_LIST" > /etc/apt/sources.list
}

function update_apt {
    local output

    output=$(apt-get update -q 2>&1)
    if [[ "$?" -ne 0 ]]; then
        halt 3 "Failed to run apt-get update:\n$output"
    fi

    # Check for any failed repositories
    if echo -e "$output" | grep "Some index files failed to download."; then
        halt 3 "Failed to run apt-get update:\n$output"
    fi
}

function apt_install {
    local output

    output=$(apt-get install -qy $@ 2>&1)
    if [[ "$?" -ne 0 ]]; then
        halt 3 "Failed to apt-get install for $@:\n$output"
    fi
}

function initial_puppet_run {
    local logfile=$(mktemp)

    echo "[$(hostname -f)] Puppet run log can be found at: $logfile"
    nohup /opt/puppetlabs/bin/puppet agent --no-daemonize --onetime > "$logfile" 2>&1 &
}

## Script Start
echo "Updating local host information."
setup_host_info

echo "Setting up apt repositories."
setup_apt

echo "Updating apt package manifests."
update_apt

echo "Installing puppet agent."
apt_install puppet-agent

echo "Performing initial puppet run."
initial_puppet_run

# Exit cleanly if we get all the way through
halt 0 "OK"
