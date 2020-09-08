#!/bin/bash

KEY=$(pwd)/signing_key.priv
CERT=$(pwd)/signing_key.x509

KERNEL_VERSION=$(uname -r)
if [ $# -ge 1 ]; then
    KERNEL_VERSION=$1
fi
echo "kernel version: ${KERNEL_VERSION}"
KERNEL_CERT_PATH="/lib/modules/${KERNEL_VERSION}/source/certs/"

cp $KEY  $KERNEL_CERT_PATH
cp $CERT $KERNEL_CERT_PATH
