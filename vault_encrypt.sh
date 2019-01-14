#!/bin/bash

# Transit key to target for encryption - defaults to puppet
TRANSIT_KEY="${TRANSIT_KEY:-puppet}"

# Settings for controlling where some configuration elements should be stored
IBVAULT_HOME_DIR="${HOME}/.icebrg_vault"

# Checks if a command exists in a POSIX compatible way
function check_command {
    if ! command -v ${1} >> /dev/null; then
        echo "${0} requires the program ${1} to be present in your PATH."
        exit 1
    fi
}

# Store information for Vault in a known directory
if [[ ! -d "${IBVAULT_HOME_DIR}" ]]; then
    mkdir "${IBVAULT_HOME_DIR}"
fi

# Make sure jq, vault and base64 are installed and if not tell the user we need them
check_command jq
check_command vault
check_command base64

# Check to make sure the user passed us their LDAP username
if [[ ${#} -ne 2 ]] || [[ "${1}" != "-u" ]]; then
    echo -e "Encrypts secrets by reading from stdin.\nUsage: ${0} -u <LDAP Username>"
    exit 1
fi

# Capture the username in a nice variable
LDAP_USER="${2}"

# Export Vault specific parameters
export VAULT_ADDR="${VAULT_ADDR:-https://vault.icebrg.io}"

# Validate that we have a token
if ! vault token-lookup >> /dev/null 2>&1; then
    echo -en "No valid token found. Requesting a new one from Vault.\nPassword (will be hidden):"

    # Open up a TTY FD for user input
    exec 3</dev/tty
    if ! vault auth -method=ldap username=${LDAP_USER} <&3 >> /dev/null 2>&1; then
        echo -e "\nAuthentication failed."
        exit 1
    fi

    # Close the FD and echo a double newline
    exec 3<&-
    echo -e "\n"
fi

# Take stdin, base64 encode it, hurl this at vault and then store the JSON response
JSON_PAYLOAD=$(cat /dev/stdin | base64 | vault write -format=json transit/encrypt/${TRANSIT_KEY} plaintext=-)

# If the vault request failed, exit here
if [[ $? -ne 0 ]]; then
    exit 1
fi

# Take out the ciphertext from the JSON response and then base64 encode it for hiera
EM=$(echo ${JSON_PAYLOAD} | jq -r '.data.ciphertext' | base64 | tr -d '\n')

# Wrap the base64 encoded encrypted message in the format that EYAML expects
echo "ENC[PKCS7Vault,${EM}]"
