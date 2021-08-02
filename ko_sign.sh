#!/bin/bash

source ./env.sh

KERNEL_BASE_DIR="/lib/modules"
KERNEL_VERSION=$(uname -r)
if [ $# -ge 1 ]; then
    KERNEL_VERSION=$1
fi
echo "kernel version: ${KERNEL_VERSION}"

function sign() {
    echo "signing: $1"
    /usr/src/kernels/${KERNEL_VERSION}/scripts/sign-file sha256 "${KEY}" "${CERT}" "$1"
}

if [[ $1 == "-i" ]]; then
    ALL_KERNEL_VERSIONS=(`ls ${KERNEL_BASE_DIR}`)
    for i in "${!ALL_KERNEL_VERSIONS[@]}"; do
        echo "${i}: ${ALL_KERNEL_VERSIONS[i]}"
    done
    read -p "Enter option (default ${ALL_KERNEL_VERSIONS[-1]}): " option
    if [ -z "$option" ]; then
        option="-1"
    fi
    KERNEL_VERSION=${ALL_KERNEL_VERSIONS[option]}
    echo "Selected kernel version: ${KERNEL_VERSION}"
    if [ -z "$KERNEL_VERSION" ]; then
        echo "ERROR: Option (${option}) is not valid."
        exit -1
    fi
fi

cd ${KERNEL_BASE_DIR}/${KERNEL_VERSION}/extra/nvidia/
for module_path in $(ls ${KERNEL_BASE_DIR}/${KERNEL_VERSION}/extra/nvidia/nvidia*); do
    sign "${module_path}"
done
