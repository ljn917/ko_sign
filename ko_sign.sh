#!/bin/bash

KEY=$(pwd)/signing_key.priv
CERT=$(pwd)/signing_key.x509

KERNEL_VERSION=$(uname -r)
if [ $# -ge 1 ]; then
    KERNEL_VERSION=$1
fi
echo "kernel version: ${KERNEL_VERSION}"

function sign() {
    echo "signing: $1"
    /usr/src/kernels/${KERNEL_VERSION}/scripts/sign-file sha256 "${KEY}" "${CERT}" "$1"
}

cd /lib/modules/${KERNEL_VERSION}/extra/nvidia/
for module_path in $(ls /lib/modules/${KERNEL_VERSION}/extra/nvidia/nvidia*); do
    sign "${module_path}"
done
